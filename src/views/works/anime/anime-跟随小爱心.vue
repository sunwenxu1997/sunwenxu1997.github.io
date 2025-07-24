<script>
export default {
  hidden: true
}
</script>
<script setup>
import { onMounted } from 'vue'
import { animate, createAnimatable, utils, createTimer } from 'animejs'
onMounted(() => {
  const [$icon] = utils.$('.icon-love')
  const [$square] = utils.$('.square')
  const loveIconMax = 20
  let mouseX = 0
  let mouseY = 0
  let hovering = false

  // 动画范围
  const bounds = $square.getBoundingClientRect()

  /**
   * 创建鼠标跟随的可动画方法createAnimatable
   * 高效地为目标属性制作动画，使其成为在值频繁更改的情况下（例如光标事件或动画循环）
   */
  const animatableSquare = createAnimatable('.icon-love-box', {
    x: 500, // Define the x duration to be 500ms
    y: 500, // Define the y duration to be 500ms
    opacity: 500,
    // translateX: { unit: 'px' },
    ease: 'out(3)'
  })

  // 监听鼠标位置，square跟随鼠标位置移动
  const onMouseMove = (e) => {
    const { width, height, left, top } = bounds
    const hw = width / 2
    const hh = height / 2
    const x = utils.clamp(e.clientX - left - hw, -hw, hw)
    const y = utils.clamp(e.clientY - top - hh, -hh, hh)
    // console.log(x, y)
    mouseX = x
    mouseY = y
    animatableSquare.x(x) // Animate the x value in 500ms
    animatableSquare.y(y) // Animate the y value in 500ms
    if (hovering) {
      animatableSquare.opacity(1)
    } else {
      animatableSquare.opacity(0)
    }
  }
  window.addEventListener('mousemove', onMouseMove)
  $square.addEventListener('mouseenter', () => {
    hovering = true
  })
  $square.addEventListener('mouseleave', () => {
    hovering = false
  })

  // 创建小爱心动画
  const animateIcon = () => {
    if (!hovering) return
    // 获取当前爱心元素图标个数，控制最多展示数量，超出不再添加
    if (utils.$('.icon-love').length > loveIconMax) return
    const $el = /** @type {HTMLElement} */ ($icon.cloneNode(true))
    $el.classList.add('icon-love')
    $square.appendChild($el)
    animate($el, {
      translateY: {
        from: mouseY,
        to: mouseY + utils.random(-155, -200),
        ease: 'out'
      },
      translateX: [
        {
          from: mouseX + utils.random(-10, 10),
          to: mouseX + utils.random(-40, 40),
          ease: 'out'
        },
        { to: mouseX + utils.random(-40, 40), ease: 'inOut(2)' }
      ],
      scale: [1, 1.2, 1, 0.1],
      opacity: [
        {
          from: 0,
          to: 1,
          ease: 'out'
        },
        { to: 0, ease: 'inOut(2)' }
      ],
      ease: 'inOut(2)',
      duration: utils.random(500, 1000),
      delay: utils.snap(utils.random(0, 500), 30)
    }).then(() => {
      $square.removeChild($el)
    })
  }
  const play = () => {
    // 执行一个重复动画
    createTimer({
      loop: true,
      duration: 30,
      onLoop: animateIcon
    })
  }
  play()
})
</script>
<template>
  <div class="body">
    <div class="square">
      <div class="icon-love-box">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="icon-love">
          <g fill="none" fill-rule="evenodd">
            <path
              fill="currentColor"
              fill-rule="nonzero"
              d="M12 18.445a.778.778 0 0 1-.34-.078C11.39 18.235 5 15.077 5 9.889a3.889 3.889 0 0 1 6.638-2.75L12 7.5l.362-.361A3.889 3.889 0 0 1 19 9.889c0 5.17-6.387 8.344-6.66 8.478a.778.778 0 0 1-.34.078z"
            ></path>
          </g>
        </svg>
      </div>
      <span>BUTTON</span>
    </div>
  </div>
</template>
<style lang="scss" scoped>
.body {
  background: #1a1a1a;
  width: 100vw;
  height: 100dvh;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.square {
  position: relative;
  border: 2px solid white;
  color: white;
  padding: 10px 20px;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 500;
  letter-spacing: 0.1rem;
  cursor: pointer;
  box-sizing: border-box;
}
.icon-love-box {
  width: 24px;
  height: 24px;
  position: absolute;
  opacity: 0;
}
.icon-love {
  width: 24px;
  height: 24px;
  display: block !important;
  color: #ff4b4b;
  position: absolute;
  mix-blend-mode: screen;
  /*   box-shadow: 0 0 10px #ff4b4b; */
  filter: drop-shadow(0 0 5px #ff4b4b);
  pointer-events: none;
}
</style>
