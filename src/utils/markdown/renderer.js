import MarkdownIt from 'markdown-it'

/**
 * Markdown 渲染内核
 *
 * 设计要点：
 * 1. 同步渲染：列表页 72 条作品不能等异步渲染器，所以 md -> html 全程同步
 * 2. 代码块只输出占位：由 highlight.js 在 DOM 挂载后用 shiki 替换（异步、按需加载）
 * 3. html: false：正文里写的原始 HTML 一律转义，不引入 DOMPurify
 */

const md = new MarkdownIt({
  html: false,
  linkify: true,
  breaks: true
})

export function escapeHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

/** 标题文本转锚点 id，保留中文，其余非单词字符转 - */
function slugify(text) {
  return text
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^\w\u4e00-\u9fa5-]/g, '')
}

/**
 * 围栏代码块：` ```js title="a.js" `
 * 同步阶段只输出结构与原始代码，shiki 挂载后替换内容
 */
md.renderer.rules.fence = (tokens, idx) => {
  const token = tokens[idx]
  const info = (token.info || '').trim()
  const lang = (info.split(/\s+/)[0] || 'text').toLowerCase()
  const titleMatch = info.match(/title="([^"]+)"/) || info.match(/title='([^']+)'/)
  const title = titleMatch ? titleMatch[1] : ''

  return (
    `<div class="md-code" data-lang="${escapeHtml(lang)}"` +
    `${title ? ` data-title="${escapeHtml(title)}"` : ''}>` +
    `<pre><code>${escapeHtml(token.content)}</code></pre>` +
    `</div>`
  )
}

/** 给 h2/h3 生成 id，供详情页目录跳转 */
md.renderer.rules.heading_open = (tokens, idx, options, env, self) => {
  const token = tokens[idx]
  const inline = tokens[idx + 1]
  const text = (inline?.children || [])
    .filter((child) => child.type === 'text' || child.type === 'code_inline')
    .map((child) => child.content)
    .join('')

  if (text && (token.tag === 'h2' || token.tag === 'h3')) {
    token.attrSet('id', slugify(text))
  }
  return self.renderToken(tokens, idx, options)
}

/**
 * Markdown -> HTML
 * @param {string} source - Markdown 源码
 * @returns {string} HTML 字符串
 */
export function renderMarkdown(source) {
  return md.render(source || '')
}

/**
 * 抽取纯文本摘要，供列表卡使用（列表页不渲染 md）
 * @param {string} source - Markdown 源码
 * @param {number} max - 最大字数
 * @returns {string} 纯文本摘要
 */
export function extractSummary(source, max = 110) {
  if (!source) return ''

  const text = source
    .replace(/```[\s\S]*?(```|$)/g, ' ') // 围栏代码块
    .replace(/~~~[\s\S]*?(~~~|$)/g, ' ') // 另一种围栏
    .replace(/!\[[^\]]*\]\([^)]*\)/g, ' ') // 图片
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1') // 链接保留文字
    .replace(/^#{1,6}\s+/gm, '') // 标题标记
    .replace(/^\s{0,3}>\s?/gm, '') // 引用
    .replace(/^\s*([-*+]|\d+\.)\s+/gm, '') // 列表标记
    .replace(/^\s*([-*_]\s*){3,}$/gm, ' ') // 分割线
    .replace(/`([^`]+)`/g, '$1') // 行内代码
    .replace(/[*_~]{1,3}/g, '') // 强调标记
    .replace(/<[^>]+>/g, ' ') // 残留 HTML
    .replace(/\s+/g, ' ')
    .trim()

  return text.length > max ? `${text.slice(0, max)}…` : text
}
