/**
 * 点击空白处的礼花彩带爆炸效果（原生 Canvas 2D，无第三方依赖）
 *
 * 用法：
 *   burstConfetti(clientX, clientY)  // 在视口坐标处炸开一批纸片
 *   disposeConfetti()                // 组件卸载时清理
 *
 * 实现要点：
 * - 全屏 fixed canvas + pointer-events: none，不拦截页面任何交互
 * - 连续点击复用同一个 canvas 与 rAF 循环，可以反复爆炸
 * - 粒子清空后自动移除 canvas，DOM 里不留空节点
 * - 用户开启"减少动态效果"时直接不播放
 */

// 与站点 stone 主色搭配的彩色纸片
const COLORS = ['#f97316', '#f43f5e', '#facc15', '#4ade80', '#38bdf8', '#a78bfa', '#fb7185']
const GRAVITY = 0.22 // 每帧下落加速度
const DRAG = 0.982 // 速度衰减（越接近 1 飞得越远，控制爆炸半径的关键参数）
const MAX_PARTICLES = 600 // 快速连点时的粒子总数上限
const DEFAULT_COUNT = 42
const FADE_FRAMES = 12 // 末段淡出的帧数
const SPEED_MIN = 1.8 // 初速下限
const SPEED_MAX = 5.6 // 初速上限（飞散程度主要由它和 DRAG 决定）

let canvas = null
let ctx = null
let particles = []
let rafId = 0
let lastTime = 0
let viewWidth = 0
let viewHeight = 0

/** 用户是否开启了"减少动态效果" */
function prefersReducedMotion() {
  return window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ?? false
}

/** 首次播放时创建全屏画布，后续点击复用 */
function ensureCanvas() {
  if (canvas) return
  canvas = document.createElement('canvas')
  canvas.setAttribute('aria-hidden', 'true')
  canvas.style.cssText = [
    'position: fixed',
    'top: 0',
    'left: 0',
    'width: 100%',
    'height: 100%',
    'pointer-events: none',
    'z-index: 9999'
  ].join(';')
  document.body.appendChild(canvas)
  ctx = canvas.getContext('2d')
  resize()
  window.addEventListener('resize', resize)
}

/** 按 DPR 重建画布尺寸，避免高分屏发虚 */
function resize() {
  if (!canvas || !ctx) return
  const dpr = Math.min(window.devicePixelRatio || 1, 2)
  viewWidth = window.innerWidth
  viewHeight = window.innerHeight
  canvas.width = Math.round(viewWidth * dpr)
  canvas.height = Math.round(viewHeight * dpr)
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
}

/** 在 (x, y) 处生成一批粒子：以点击点为圆心向外炸开，整体再向上抛一点 */
function createParticles(x, y, count) {
  const room = Math.max(0, MAX_PARTICLES - particles.length)
  const total = Math.min(count, room)
  for (let i = 0; i < total; i += 1) {
    const angle = Math.random() * Math.PI * 2
    const speed = SPEED_MIN + Math.random() * (SPEED_MAX - SPEED_MIN)
    const isDot = Math.random() < 0.22
    particles.push({
      x,
      y,
      vx: Math.cos(angle) * speed,
      vy: Math.sin(angle) * speed - 2.6,
      size: isDot ? 2 + Math.random() * 3 : 5 + Math.random() * 5,
      ratio: 0.5 + Math.random() * 0.9, // 纸片长宽比
      rot: Math.random() * Math.PI * 2,
      spin: (Math.random() * 2 - 1) * 0.32,
      wobble: Math.random() * Math.PI * 2,
      wobbleSpeed: 0.05 + Math.random() * 0.08,
      color: COLORS[(Math.random() * COLORS.length) | 0],
      isDot,
      life: 0,
      ttl: 48 + Math.random() * 28
    })
  }
}

function updateParticle(p, k) {
  p.vy += GRAVITY * k
  p.vx *= DRAG ** k
  p.vy *= DRAG ** k
  p.x += p.vx * k
  p.y += p.vy * k
  p.rot += p.spin * k
  p.wobble += p.wobbleSpeed * k
  p.life += k
}

function drawParticle(p) {
  const remain = p.ttl - p.life
  const alpha = remain < FADE_FRAMES ? Math.max(remain / FADE_FRAMES, 0) : 1
  ctx.save()
  ctx.globalAlpha = alpha
  ctx.fillStyle = p.color
  ctx.translate(p.x, p.y)
  ctx.rotate(p.rot)
  if (p.isDot) {
    ctx.beginPath()
    ctx.arc(0, 0, p.size / 2, 0, Math.PI * 2)
    ctx.fill()
  } else {
    // 用 cos 模拟纸片翻转时的宽度收缩
    const flutter = Math.abs(Math.cos(p.wobble)) * 0.6 + 0.4
    const h = p.size * p.ratio
    ctx.fillRect((-p.size / 2) * flutter, -h / 2, p.size * flutter, h)
  }
  ctx.restore()
}

function tick(now) {
  rafId = 0
  // 以 60fps 为基准换算帧步长，高刷屏与掉帧时速度保持一致
  const k = lastTime ? Math.min((now - lastTime) / 16.667, 3) : 1
  lastTime = now

  ctx?.clearRect(0, 0, viewWidth, viewHeight)
  particles = particles.filter((p) => p.life < p.ttl && p.y < viewHeight + 100)

  for (const p of particles) {
    updateParticle(p, k)
    drawParticle(p)
  }

  if (particles.length) {
    rafId = requestAnimationFrame(tick)
  } else {
    stop()
  }
}

/** 清理循环、画布与监听，粒子结束后自动调用 */
function stop() {
  if (rafId) cancelAnimationFrame(rafId)
  rafId = 0
  lastTime = 0
  particles = []
  window.removeEventListener('resize', resize)
  if (canvas) {
    canvas.remove()
    canvas = null
    ctx = null
  }
}

/**
 * 在指定视口坐标处播放一次礼花彩带爆炸
 * @param {number} x - 视口横坐标（一般传 clientX）
 * @param {number} y - 视口纵坐标（一般传 clientY）
 * @param {Object} [options]
 * @param {number} [options.count] - 本次生成的粒子数量
 */
export function burstConfetti(x, y, { count = DEFAULT_COUNT } = {}) {
  if (prefersReducedMotion()) return
  if (!Number.isFinite(x) || !Number.isFinite(y)) return
  ensureCanvas()
  createParticles(x, y, count)
  if (!rafId) rafId = requestAnimationFrame(tick)
}

/** 停止动画并移除画布，组件卸载时调用 */
export function disposeConfetti() {
  stop()
}
