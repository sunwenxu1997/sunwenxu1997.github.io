import { supabase } from '@/lib/supabase'
import defaultSet from '@/settings'
import { deleteCoverByUrl } from './storage'
import { fetchLocalWorks } from './works.local'

/**
 * works_meta 表 CRUD 封装
 * RLS 策略：
 *   - anon       → 只能读 is_published=true 的记录
 *   - authenticated → 能读所有记录（后台管理列表）
 *   - admin      → 可增删改
 */

const TABLE = 'works_meta'
const SELECT_COLUMNS = '*'
// works_meta.id 为 uuid 类型：非 uuid 的值（空串、非法路由参数）直接走 eq('id') 会被数据库拒绝（22P02）
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

/**
 * 默认排序：sort_weight DESC → date DESC → created_at DESC → id ASC
 * 最后一列 id 是唯一键兑底：种子数据里大量记录 sort_weight=0、date=NULL、
 * created_at 相同（同一个事务插入），没有唯一列时 Postgres 对并列行的返回
 * 顺序不确定，LIMIT/OFFSET 分页会出现重复或漏行。
 */
const DEFAULT_ORDER = [
  { column: 'sort_weight', ascending: false },
  { column: 'date', ascending: false, nullsFirst: false },
  { column: 'created_at', ascending: false },
  { column: 'id', ascending: true }
]

function applyOrder(query) {
  let q = query
  for (const { column, ascending, nullsFirst } of DEFAULT_ORDER) {
    q = q.order(column, { ascending, nullsFirst })
  }
  return q
}

/**
 * 获取已发布的作品列表（公开接口，anon 可调用）
 * RLS 自动过滤 is_published=true
 * @returns {Promise<Array>} works_meta 记录数组
 */
export async function fetchPublishedWorks() {
  const query = applyOrder(
    supabase
      .from(TABLE)
      .select(SELECT_COLUMNS)
      .eq('is_published', true)
  )
  const { data, error } = await query
  if (error) throw error
  return data
}

/**
 * 获取全部作品（含未发布/隐藏，需登录态）
 * admin 用于后台管理列表
 * @returns {Promise<Array>} works_meta 全量记录
 */
export async function fetchAllWorks() {
  const query = applyOrder(supabase.from(TABLE).select(SELECT_COLUMNS))
  const { data, error } = await query
  if (error) throw error
  return data
}

/**
 * 「字段是否已配置」筛选项：逻辑键 → 真实列名
 * 编辑器保存时空串统一写成 null，种子数据也用 NULL，所以只按 null 判断即可
 */
const PRESENCE_COLUMNS = {
  cover: 'cover_url',
  date: 'date'
}

// 四个外链字段作为一个整体筛：任一有值即算已配置（与侧边栏「已配置链接」统计口径一致）
const LINK_COLUMNS = ['code_url', 'link_url', 'codepen_url', 'open_url']

/**
 * 追加「字段是否已配置」条件
 * @param {Object} query - supabase 查询构造器
 * @param {Object} filters - { cover|date|links: 'any' | 'filled' | 'empty' }
 * @returns {Object} 追加条件后的查询构造器
 */
function applyPresenceFilters(query, filters) {
  let q = query
  for (const [key, column] of Object.entries(PRESENCE_COLUMNS)) {
    const mode = filters?.[key]
    if (mode !== 'filled' && mode !== 'empty') continue
    q = mode === 'filled' ? q.not(column, 'is', null) : q.is(column, null)
  }

  const linkMode = filters?.links
  if (linkMode === 'filled') {
    // 任一外链非空；多个同列条件与 or 组之间都是 AND，不影响其他筛选
    q = q.or(LINK_COLUMNS.map((column) => `${column}.not.is.null`).join(','))
  } else if (linkMode === 'empty') {
    for (const column of LINK_COLUMNS) q = q.is(column, null)
  }
  return q
}

/**
 * 服务端分页查询作品（含搜索/标签/条件筛选，需登录态）
 * @param {Object} params
 * @param {number} params.page - 页码（从 1 开始）
 * @param {number} params.pageSize - 每页条数
 * @param {string} [params.search] - 搜索关键词（匹配 name）
 * @param {string[]} [params.tags] - 标签过滤（多选，AND 关系）
 * @param {Object} [params.filters] - 条件筛选：封面/日期/链接（links）取 'any' | 'filled' | 'empty'，status 取 'any' | 'published' | 'draft'
 * @returns {Promise<{data: Array, total: number}>}
 */
export async function fetchWorksPage({ page = 1, pageSize = 10, search = '', tags = [], filters = {} }) {
  let query = supabase.from(TABLE).select(SELECT_COLUMNS, { count: 'exact' })

  if (search) {
    query = query.ilike('name', `%${search}%`)
  }
  if (tags.length > 0) {
    query = query.contains('tags', tags)
  }
  query = applyPresenceFilters(query, filters)
  if (filters?.status === 'published') {
    query = query.eq('is_published', true)
  } else if (filters?.status === 'draft') {
    query = query.eq('is_published', false)
  }

  query = applyOrder(query)

  const from = (page - 1) * pageSize
  const to = from + pageSize - 1
  query = query.range(from, to)

  const { data, error, count } = await query
  if (error) throw error
  return { data: data || [], total: count || 0 }
}

/**
 * 获取作品统计信息（侧边栏数据，需登录态）
 * @returns {Promise<{total: number, published: number, withCover: number, withLink: number}>}
 */
export async function fetchWorksStats() {
  // 只查轻量字段，减少数据传输
  const { data, error } = await supabase
    .from(TABLE)
    .select('id, is_published, cover_url, code_url, link_url, codepen_url, open_url')
  if (error) throw error
  const list = data || []
  return {
    total: list.length,
    published: list.filter((w) => w.is_published).length,
    withCover: list.filter((w) => w.cover_url).length,
    // 任意一个外链字段有值即算已配置链接
    withLink: list.filter(
      (w) => w.code_url || w.link_url || w.codepen_url || w.open_url
    ).length
  }
}

/**
 * 按 id 查询单条作品
 * @param {string} id - works_meta.id（本地数据源时为 /external/<name>）
 * @returns {Promise<Object|null>} 单条记录或 null
 */
export async function fetchWorkById(id) {
  if (!id) return null
  const { data, error } = await supabase
    .from(TABLE)
    .select(SELECT_COLUMNS)
    .eq('id', id)
    .maybeSingle()
  if (error) throw error
  return data
}

/**
 * 查询单条作品（详情页）
 * useLocalWorks 开启时改读本地静态数据
 * @param {string} key - 作品 id
 * @returns {Promise<Object|null>}
 */
export async function fetchWorkDetail(key) {
  // 空 key（如 /work/ 无参数）直接视为不存在，不发起请求
  if (!key) return null
  if (defaultSet.useLocalWorks) {
    return fetchLocalWorks().find((item) => item.id === key) || null
  }
  // 非 uuid 的 key 直接视为不存在，避开 uuid 类型校验报错（22P02）
  if (!UUID_RE.test(key)) return null
  return fetchWorkById(key)
}

/**
 * 新增或更新作品（admin only）
 * 有 id 执行更新，无 id 新增（sort_weight 自动分配）
 * @param {Object} record - works_meta 行对象，需包含 name
 * @returns {Promise<Object>} 写入后的完整记录
 */
export async function upsertWork(record) {
  if (record.id) {
    const { id, ...fields } = record
    const { data, error } = await supabase
      .from(TABLE)
      .update(fields)
      .eq('id', id)
      .select()
      .single()
    if (error) throw error
    return data
  }
  // 新建时自动分配 sort_weight，避免多条记录权重相同导致首次拖拽触发全量重排
  if (!record.sort_weight) {
    const { data: maxRow } = await supabase
      .from(TABLE)
      .select('sort_weight')
      .order('sort_weight', { ascending: false })
      .limit(1)
      .maybeSingle()
    record.sort_weight = (maxRow?.sort_weight || 0) + 1
  }
  const { data, error } = await supabase
    .from(TABLE)
    .insert(record)
    .select()
    .single()
  if (error) throw error
  return data
}

/**
 * 批量 upsert（用于拖拽排序后批量更新 sort_weight）
 * @param {Array<Object>} records - 需要更新的记录数组
 * @param {string} [conflictKey='id'] - 冲突检测字段
 * @returns {Promise<Array<Object>>} 写入后的记录数组
 */
export async function bulkUpdateSortWeights(records) {
  const updates = records.map((r) => ({ id: r.id, sort_weight: r.sort_weight }))
  for (const row of updates) {
    const { error } = await supabase
      .from(TABLE)
      .update({ sort_weight: row.sort_weight })
      .eq('id', row.id)
    if (error) throw error
  }
}

/**
 * 删除作品（admin only）
 * 记录删成功后连带清理 Storage 里的封面文件（外链封面会被 deleteCoverByUrl 忽略）
 * @param {string} id - works_meta.id (UUID)
 */
export async function deleteWork(id) {
  const { data, error } = await supabase
    .from(TABLE)
    .delete()
    .eq('id', id)
    .select('cover_url')
    .maybeSingle()
  if (error) throw error
  // 先删记录再删文件：文件清理失败只告警，不会让作品删不掉
  await deleteCoverByUrl(data?.cover_url)
}
