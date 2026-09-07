import { supabase } from '@/lib/supabase'

/**
 * works_meta 表 CRUD 封装
 * RLS 策略：
 *   - anon       → 只能读 is_published=true 且 is_hidden=false 的记录
 *   - authenticated → 能读所有记录（后台管理列表）
 *   - admin      → 可增删改
 */

const TABLE = 'works_meta'
const SELECT_COLUMNS = '*'

/** 默认排序：sort_weight DESC → date DESC → id DESC */
const DEFAULT_ORDER = [
  { column: 'sort_weight', ascending: false },
  { column: 'date', ascending: false, nullsFirst: false },
  { column: 'id', ascending: false }
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
 * RLS 自动过滤 is_published=true & is_hidden=false
 * @returns {Promise<Array>} works_meta 记录数组
 */
export async function fetchPublishedWorks() {
  const query = applyOrder(supabase.from(TABLE).select(SELECT_COLUMNS))
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
  const { data, error } = await supabase
    .from(TABLE)
    .upsert(record, { onConflict: 'slug' })
    .select()
    .single()
  if (error) throw error
  return data
}

/**
 * 删除作品（admin only）
 * @param {number} id - works_meta.id
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
    hidden: row.is_hidden ?? false,
    tags: row.tags || []
  }
}
