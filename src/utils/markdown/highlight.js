/**
 * shiki 代码高亮（懒加载）
 *
 * - 只在需要时（详情页 / 卡片展开）动态 import，首屏零成本
 * - 只打包白名单语言的 grammar，不用 shiki 全量 bundle
 * - 用 JavaScript 正则引擎，避免额外加载 oniguruma wasm
 */

const THEME = 'vitesse-dark'

/** 白名单语言：值必须是 node_modules/shiki/dist/langs 里存在的文件名 */
const LANG_LOADERS = {
  javascript: () => import('shiki/langs/javascript.mjs'),
  typescript: () => import('shiki/langs/typescript.mjs'),
  vue: () => import('shiki/langs/vue.mjs'),
  html: () => import('shiki/langs/html.mjs'),
  css: () => import('shiki/langs/css.mjs'),
  scss: () => import('shiki/langs/scss.mjs'),
  json: () => import('shiki/langs/json.mjs'),
  bash: () => import('shiki/langs/bash.mjs'),
  glsl: () => import('shiki/langs/glsl.mjs'),
  markdown: () => import('shiki/langs/markdown.mjs')
}

/** 代码块里常见写法 -> shiki 语言 id */
const LANG_ALIAS = {
  js: 'javascript',
  jsx: 'javascript',
  mjs: 'javascript',
  cjs: 'javascript',
  ts: 'typescript',
  tsx: 'typescript',
  xml: 'html',
  svg: 'html',
  sass: 'scss',
  less: 'css',
  sh: 'bash',
  shell: 'bash',
  zsh: 'bash',
  console: 'bash',
  shellscript: 'bash',
  md: 'markdown'
}

let highlighterPromise = null

async function getHighlighter() {
  if (!highlighterPromise) {
    highlighterPromise = (async () => {
      const [{ createHighlighterCore }, { createJavaScriptRegexEngine }, themeModule] =
        await Promise.all([
          import('shiki/core'),
          import('shiki/engine/javascript'),
          import('shiki/themes/vitesse-dark.mjs')
        ])
      const langModules = await Promise.all(
        Object.values(LANG_LOADERS).map((loader) => loader())
      )
      return createHighlighterCore({
        themes: [themeModule.default],
        langs: langModules.map((mod) => mod.default),
        engine: createJavaScriptRegexEngine()
      })
    })().catch((err) => {
      // 加载失败时允许下次重试
      highlighterPromise = null
      throw err
    })
  }
  return highlighterPromise
}

/** 代码块顶部工具条：左侧语言/文件名，右侧复制按钮 */
function buildBar(label, code) {
  const bar = document.createElement('div')
  bar.className = 'md-code__bar'

  const lang = document.createElement('span')
  lang.className = 'md-code__lang'
  lang.textContent = label

  const copy = document.createElement('button')
  copy.type = 'button'
  copy.className = 'md-code__copy'
  copy.textContent = '复制'
  copy.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(code)
      copy.textContent = '已复制'
      copy.classList.add('is-done')
    } catch {
      copy.textContent = '复制失败'
    }
    setTimeout(() => {
      copy.textContent = '复制'
      copy.classList.remove('is-done')
    }, 1500)
  })

  bar.append(lang, copy)
  return bar
}

/**
 * 把 rootEl 内所有代码块替换为 shiki 高亮版本
 * 幂等：已处理过的节点会跳过
 * @param {HTMLElement} rootEl
 */
export async function highlightAll(rootEl) {
  if (!rootEl) return

  const blocks = rootEl.querySelectorAll('.md-code[data-lang]')
  if (!blocks.length) return

  let highlighter
  try {
    highlighter = await getHighlighter()
  } catch (err) {
    console.warn('[markdown] shiki 加载失败，代码块保留纯文本', err)
    return
  }

  const loadedLangs = highlighter.getLoadedLanguages()

  blocks.forEach((block) => {
    if (block.dataset.highlighted === 'true') return

    const rawLang = (block.dataset.lang || 'text').toLowerCase()
    const lang = LANG_ALIAS[rawLang] || rawLang
    const codeEl = block.querySelector('code')
    const code = codeEl ? codeEl.textContent : ''

    const label = block.dataset.title || rawLang
    block.dataset.highlighted = 'true'

    if (!code || !loadedLangs.includes(lang)) {
      // 未支持的语言：只加工具条，保留纯文本
      const pre = block.querySelector('pre')
      block.insertBefore(buildBar(label, code), pre)
      return
    }

    const html = highlighter.codeToHtml(code, { lang, theme: THEME })
    block.innerHTML = html
    block.insertBefore(buildBar(label, code), block.firstChild)
  })
}
