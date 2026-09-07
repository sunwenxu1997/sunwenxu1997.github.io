import { defineStore } from 'pinia'
import { ref } from 'vue'
import { fetchPublishedWorks, mapDbRowToMeta } from '@/api/works'

/**
 * 自动发现 src/views/works/ 下所有 Vue 组件
 * 与 router/works.js 使用相同的 glob 模式，保证路径一致
 */
const routeFiles = import.meta.glob('../views/works/**/*.vue', { eager: true })

/**
 * 作品数据 Store
 *
 * 数据来源合并策略：
 *   1. Supabase works_meta 表（外部链接类作品，slug 前缀 /external/）
 *   2. glob 自动发现的 Vue 组件（内嵌 demo，path 前缀 /anime/ 等）
 *
 * 合并规则：
 *   - DB 中 slug 匹配 glob path → DB 优先，跳过该 glob 组件
 *   - DB 中无匹配 → glob 组件保留，使用组件内 default export 的 meta
 *   - meta.hidden=true 的 glob 组件直接过滤（DB 的 is_hidden 由 RLS 处理）
 */
export const useWorksStore = defineStore('works', () => {
  /** 合并后的作品列表（已排序） */
  const works = ref([])
  const loading = ref(false)
  const error = ref(null)

  /**
   * 初始化：拉取 DB 数据并与 glob 合并
   * 在 Works.vue 的 onActivated 中调用
   * DB 失败时降级为仅展示 glob 组件，不阻断页面
   */
  async function init() {
    loading.value = true
    error.value = null
    try {
      const [dbWorks] = await Promise.all([fetchPublishedWorks()])
      works.value = mergeRoutes(dbWorks)
    } catch (e) {
      console.error('[works] 加载失败:', e)
      error.value = e.message
      // DB 不可用时仍展示本地 glob 组件
      works.value = mergeRoutes([])
    } finally {
      loading.value = false
    }
  }

  /**
   * 合并 DB 记录与 glob Vue 组件，返回排序后的统一列表
   * 排序优先级：sort_weight DESC → 有封面优先 → date DESC
   * @param {Array} dbWorks - works_meta 表查询结果
   * @returns {Array<{path, name, meta}>} 与 Works.vue 模板兼容的路由数组
   */
  function mergeRoutes(dbWorks) {
    const dbSlugSet = new Set(dbWorks.map((w) => w.slug))

    // 遍历 glob 组件，跳过已被 DB 托管的（slug 匹配）和 hidden 的
    const globRoutes = []
    for (const filePath in routeFiles) {
      const mod = routeFiles[filePath]
      const config = mod.default
      const path = filePath.replace(/.vue*$/g, '').split('../views/works')[1]

      // DB 已有同名 slug，由 DB 接管元数据
      if (dbSlugSet.has(path)) continue

      const { link, hidden, code, cover, info, sort, date, codepen, open } = config
      if (hidden) continue

      globRoutes.push({
        path: encodeURI(path),
        name: path.split('/').reverse()[0],
        meta: { code, link, cover, info, sort, date, codepen, open }
      })
    }

    // DB 记录转为与 glob 路由相同的结构
    const dbRoutes = dbWorks.map((row) => ({
      // 有 open_url 则用作跳转地址，否则 slug 作为内部路由
      path: row.open_url || row.slug,
      name: row.name,
      meta: mapDbRowToMeta(row)
    }))

    // 三级排序：sort_weight → 封面存在性 → 发布日期
    return [...dbRoutes, ...globRoutes]
      .sort((a, b) => new Date(b.meta.date || 0).getTime() - new Date(a.meta.date || 0).getTime())
      .sort((a, b) => (b.meta.cover ? 1 : 0) - (a.meta.cover ? 1 : 0))
      .sort((a, b) => (b.meta.sort || 0) - (a.meta.sort || 0))
  }

  return { works, loading, error, init }
})
