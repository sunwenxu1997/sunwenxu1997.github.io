import defaultSet from '@/settings'

/**
 * 本地静态数据源（settings.useLocalWorks = true 时启用）
 *
 * 把 settings.externalRoutes 映射成 works_meta 结构，
 * 让 Works.vue 用和 Supabase 返回完全一致的字段渲染，切换数据源时页面无需改动。
 *
 * 字段对应关系：
 *   settings 侧               →  works_meta 侧
 *   cover                     →  cover_url
 *   info                      →  info_md（Markdown）
 *   code                      →  code_url
 *   link                      →  link_url
 *   codepen                   →  codepen_url
 *   open                      →  open_url
 *   sort                      →  sort_weight
 *   hidden                    →  is_published（取反）
 *   tags                      →  tags（不写时固定为 external）
 */

/** settings.externalRoutes 条目 → works_meta 结构；id 用 /external/<name>，与旧版详情链接兼容 */
function fromExternal(item) {
  const id = `/external/${item.name}`
  const { cover, info, code, link, codepen, open, sort, date, hidden, tags } = item.meta || {}
  return {
    id,
    name: item.name,
    cover_url: cover || null,
    info_md: info || null,
    code_url: code || null,
    link_url: link || null,
    codepen_url: codepen || null,
    open_url: open || null,
    date: date || null,
    sort_weight: sort || 0,
    is_published: !hidden,
    tags: tags || ['external']
  }
}

/** 排序对齐 DB 的 DEFAULT_ORDER：sort_weight 降序 → date 降序 */
function compare(a, b) {
  const weight = (b.sort_weight || 0) - (a.sort_weight || 0)
  if (weight !== 0) return weight
  return new Date(b.date || 0).getTime() - new Date(a.date || 0).getTime()
}

/**
 * 获取静态作品列表（等价于 Supabase 的 fetchPublishedWorks）
 * @returns {Array<Object>} works_meta 结构的记录数组（已过滤 hidden，已排序）
 */
export function fetchLocalWorks() {
  return (defaultSet.externalRoutes || [])
    .map(fromExternal)
    .filter((item) => item.is_published)
    .sort(compare)
}
