/**
 * 首屏加载进度
 *
 * 设计原则：
 * 1. 百分比只由真实事件推进 —— 静态资源完成、路由就绪、字体就绪、图片就绪、首帧渲染
 * 2. 唯一与时间相关的逻辑是「兜底超时」，避免某个请求挂起把首屏卡死
 * 3. 数字滚动用 rAF 插值做视觉平滑，但不会凭空推进目标值
 *
 * 用法：
 *   index.html 里以 module script 引入本文件，模块执行即自动 start()
 *   main.js 里继续调用 waitRoute / waitFonts / waitImages / finish 推进真实阶段
 */

// 各阶段的真实里程碑，值是「该事件完成时至少到达的百分比」
export const STAGE = {
  DOM: 8, // HTML 解析完成
  ASSETS: 40, // 入口 JS / CSS 等静态资源陆续完成
  ROUTE: 55, // 首屏路由组件 chunk + 路由守卫（登录态请求）完成
  FONTS: 70, // 字体就绪
  IMAGES: 90, // 首屏关键图片就绪
  RENDER: 100 // 首帧渲染完成
}

// 单个阶段最长等待时间，超时直接放行
const STAGE_TIMEOUT = 8000
// 数字插值系数，越小滚得越慢
const TWEEN_FACTOR = 0.16
// 100% 停留时间，让用户看清
const FINISH_DELAY = 300

let started = false
let finished = false
let target = 0
let current = 0
let rafId = 0
let elValue = null
let elBar = null
let assetObserver = null

function render() {
  const value = Math.round(current)
  if (elValue) elValue.textContent = value
  if (elBar) elBar.style.width = value + '%'
}

function tick() {
  rafId = 0
  const diff = target - current
  if (Math.abs(diff) < 0.5) {
    current = target
    render()
    return
  }
  current += diff * TWEEN_FACTOR
  render()
  rafId = requestAnimationFrame(tick)
}

// 设置进度（只增不减，避免多个阶段并行时数字来回跳）
function setProgress(value) {
  if (finished) return
  const next = Math.min(STAGE.RENDER, value)
  if (next <= target) return
  target = next
  if (!rafId) rafId = requestAnimationFrame(tick)
}

// 真实资源完成一个算一个，用渐近曲线逼近阶段上限（不会自己跑到 100%）
function observeAssets() {
  if (typeof PerformanceObserver === 'undefined') {
    setProgress(STAGE.ASSETS)
    return
  }
  let count = 0
  assetObserver = new PerformanceObserver((list) => {
    count += list.getEntries().length
    setProgress(STAGE.DOM + (STAGE.ASSETS - STAGE.DOM) * (1 - Math.exp(-count / 8)))
  })
  try {
    assetObserver.observe({ type: 'resource', buffered: true })
  } catch (e) {
    setProgress(STAGE.ASSETS)
  }
}

function withTimeout(promise, ms = STAGE_TIMEOUT) {
  return Promise.race([
    promise,
    new Promise((resolve) => {
      setTimeout(resolve, ms)
    })
  ])
}

function start() {
  if (started) return
  started = true

  elValue = document.querySelector('#loading-progress .value')
  elBar = document.querySelector('#loading-progress .progress')
  render()

  observeAssets()

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => setProgress(STAGE.DOM), { once: true })
  } else {
    setProgress(STAGE.DOM)
  }

  // 兜底：任何阶段卡住都不影响进入页面
  setTimeout(() => {
    if (!finished) finish()
  }, STAGE_TIMEOUT)
}

// 等待首屏路由就绪：懒加载 chunk + 路由守卫里的异步请求
// 注意：必须在 app.use(router) 之后调用，否则初始导航还没开始，isReady 会一直挂起
async function waitRoute(router) {
  start()
  try {
    await withTimeout(router.isReady())
  } catch (e) {
    // 初始导航失败（比如守卫里的请求出错）也要放行，交给应用自己处理
  }
  if (assetObserver) {
    assetObserver.disconnect()
    assetObserver = null
  }
  setProgress(STAGE.ROUTE)
}

async function waitFonts() {
  start()
  if (document.fonts) {
    const tasks = []
    // 主动触发一次字体加载，避免字体还没开始请求时 ready 提前 resolve
    if (document.fonts.load) {
      tasks.push(document.fonts.load('0.88rem Rajdhani').catch(() => {}))
    }
    if (document.fonts.ready) tasks.push(document.fonts.ready)
    await withTimeout(Promise.all(tasks))
  }
  setProgress(STAGE.FONTS)
}

async function waitImages(urls = []) {
  start()
  if (!urls.length) {
    setProgress(STAGE.IMAGES)
    return
  }
  const from = STAGE.FONTS
  const span = STAGE.IMAGES - from
  let done = 0
  await Promise.all(
    urls.map(
      (url) =>
        new Promise((resolve) => {
          const img = new Image()
          const onSettled = () => {
            done += 1
            setProgress(from + (span * done) / urls.length)
            resolve()
          }
          img.onload = onSettled
          // 加载失败也放行，不让一张图卡死首屏
          img.onerror = onSettled
          img.src = url
        })
    )
  )
}

// 补到 100% 并淡出移除遮罩，返回的 Promise 在遮罩移除后 resolve
function finish() {
  if (finished) return Promise.resolve()
  finished = true
  if (rafId) {
    cancelAnimationFrame(rafId)
    rafId = 0
  }
  target = STAGE.RENDER
  current = STAGE.RENDER
  render()

  return new Promise((resolve) => {
    setTimeout(() => {
      const el = document.getElementById('loading-progress')
      if (el) {
        el.style.transition = 'opacity 0.3s ease'
        el.style.opacity = '0'
        setTimeout(() => el.remove(), 320)
      }
      resolve()
    }, FINISH_DELAY)
  })
}

const loading = { start, set: setProgress, waitRoute, waitFonts, waitImages, finish }

export { loading }
export default loading

// module script 直接引入本文件时立即开始；main.js 再调用 start() 不会重复启动
if (typeof window !== 'undefined') start()
