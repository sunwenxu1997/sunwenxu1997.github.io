import { supabase } from '@/lib/supabase'

/**
 * works_meta 表 CRUD 封装
 * RLS 策略：
 *   - anon       → 只能读 is_published=true 的记录
 *   - authenticated → 能读所有记录（后台管理列表）
 *   - admin      → 可增删改
 */

const TABLE = 'works_meta'
const SELECT_COLUMNS = '*'

/** 默认排序：sort_weight DESC → date DESC → created_at DESC */
const DEFAULT_ORDER = [
  { column: 'sort_weight', ascending: false },
  { column: 'date', ascending: false, nullsFirst: false },
  { column: 'created_at', ascending: false }
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
 * 服务端分页查询作品（含搜索/标签过滤，需登录态）
 * @param {Object} params
 * @param {number} params.page - 页码（从 1 开始）
 * @param {number} params.pageSize - 每页条数
 * @param {string} [params.search] - 搜索关键词（匹配 name / slug）
 * @param {string[]} [params.tags] - 标签过滤（多选，AND 关系）
 * @returns {Promise<{data: Array, total: number}>}
 */
export async function fetchWorksPage({ page = 1, pageSize = 10, search = '', tags = [] }) {
  let query = supabase.from(TABLE).select(SELECT_COLUMNS, { count: 'exact' })

  if (search) {
    query = query.or(`name.ilike.%${search}%,slug.ilike.%${search}%`)
  }
  if (tags.length > 0) {
    query = query.contains('tags', tags)
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
 * @returns {Promise<{total: number, published: number, withCover: number, vueDemo: number}>}
 */
export async function fetchWorksStats() {
  // 只查轻量字段，减少数据传输
  const { data, error } = await supabase
    .from(TABLE)
    .select('id, is_published, cover_url, slug, tags')
  if (error) throw error
  const list = data || []
  return {
    total: list.length,
    published: list.filter((w) => w.is_published).length,
    withCover: list.filter((w) => w.cover_url).length,
    vueDemo: list.filter(
      (w) => w.slug?.includes('/external/vue-') || (w.tags || []).includes('vue')
    ).length
  }
}

/**
 * 按 slug 查询单条作品
 * @param {string} slug - 路由标识，如 '/external/vue-组件页面装修demo'
 * @returns {Promise<Object|null>} 单条记录或 null
 */
export async function fetchWorkBySlug(slug) {
  const { data, error } = await supabase
    .from(TABLE)
    .select(SELECT_COLUMNS)
    .eq('slug', slug)
    .maybeSingle()
  if (error) throw error
  return data
}

/**
 * 新增或更新作品（admin only）
 * slug 相同时执行更新，否则新增
 * @param {Object} record - works_meta 行对象，需包含 slug 和 name
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
 * @param {string} id - works_meta.id (UUID)
 */
export async function deleteWork(id) {
  const { error } = await supabase.from(TABLE).delete().eq('id', id)
  if (error) throw error
}

/**
 * DB 字段名 → Works.vue meta 字段名映射
 * 数据库用 snake_case（code_url），前端沿用原有驼峰命名（code）
 * @param {Object} row - works_meta 单行记录
 * @returns {Object} 与 settings.js externalRoutes.meta 兼容的对象
 */
export function mapDbRowToMeta(row) {
  return {
    code: row.code_url || undefined,
    link: row.link_url || undefined,
    cover: row.cover_url || undefined,
    info: row.info_html || undefined,
    sort: row.sort_weight ?? 0,
    date: row.date || undefined,
    codepen: row.codepen_url || undefined,
    open: row.open_url || undefined,
    tags: row.tags || []
  }
}
