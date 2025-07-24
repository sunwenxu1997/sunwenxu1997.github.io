<script setup>
import { ref, reactive, onMounted } from 'vue'
import { animate, createAnimatable, utils, createTimer } from 'animejs'
onMounted(() => {
  const [$body] = utils.$('.body')
  let bgFlowerArr = []
  // 速度
  const bgFlowerSpeed = 0.3
  const bgFlowerNum = 200
  const bgFlowerSize = 10
  // 创建背景礼花下落动画
  const createBgFlower = () => {
    const bounds = $body.getBoundingClientRect()
    const { width, height, left, top } = bounds
    // console.log(width)
    for (let i = 0; i < bgFlowerNum; i++) {
      const $el = document.createElement('div')
      const scale = utils.random(0.2, 1.2, 1)
      utils.set($el, {
        width: `${bgFlowerSize * scale}px`,
        height: `${bgFlowerSize * scale}px`,
        position: 'absolute',
        top: `${utils.random(-50, -20)}px`,
        left: `${utils.random(0, width)}px`,
        transformStyle: 'preserve-3d',
        background: utils.randomPick([
          '#dce90d',
          '#0de9be',
          '#0dbce9',
          '#e9530d',
          '#e90d59',
          '#ffffff'
        ]),
        borderRadius: utils.randomPick(['50%', '0%']),
        userSelect: 'none'
      })
      $el.classList.add('bg-flower')
      $body.appendChild($el)

      const animation = animate($el, {
        translateX: [
          {
            from: utils.random(-200, 200),
            to: utils.random(-10, 10),
            ease: 'out'
          },
          { to: utils.random(-100, 100), ease: 'inOut(2)' }
        ],
        translateY: [{ to: utils.random(height + 50, height + 100), ease: 'inOut(2)' }],
        duration: (6000 - 2000 * scale) / bgFlowerSpeed,
        rotate: `${utils.random(1, 3)}turn`,
        rotateX: `${utils.random(1, 3)}turn`,
        rotateY: `1turn`,
        //   scale: [1, 1.2, 1, 0.1],
        ease: 'inOut(2)',
        delay: utils.snap(utils.random(-5000, 5000), 500) / bgFlowerSpeed,
        loop: true
      })
      bgFlowerArr.push({ $el, animation })
    }
  }
  const draw = () => {
    bgFlowerArr.forEach(({ $el, animation }) => {
      animation.revert()
      $body.removeChild($el)
    })
    bgFlowerArr = []
    createBgFlower()
  }
  draw()
  // 监听窗口尺寸改变
  window.addEventListener('resize', () => {
    // console.log(utils.$('.bg-flower').length)
    draw()
  })
})
</script>
<template>
  <div class="body">
    <div class="button">🎉 click me</div>
  </div>
</template>
<style lang="scss" scoped>
.body {
  background: #127de9;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  perspective: 1000px;
}
.button {
  user-select: none;
  font-size: 14px;
  padding: 15px 20px;
  text-transform: uppercase;
  background-color: #f0f0f0;
  color: #393838;
  border-radius: 0.5em;
  font-weight: 600;
  box-shadow:
    inset 0 0.0625em 0 0 #f4f4f4,
    0 0.0625em 0 0 #efefef,
    0 0.125em 0 0 #ececec,
    0 0.25em 0 0 #e0e0e0,
    0 0.3125em 0 0 #dedede,
    0 0.375em 0 0 #dcdcdc,
    0 0.425em 0 0 #cacaca,
    0 0.425em 0.5em 0 #cecece;
  transition: 0.15s ease;
  cursor: pointer;
}
.button:active {
  translate: 0 0.225em;
  box-shadow:
    inset 0 0.03em 0 0 #f4f4f4,
    0 0.03em 0 0 #efefef,
    0 0.0625em 0 0 #ececec,
    0 0.125em 0 0 #e0e0e0,
    0 0.125em 0 0 #dedede,
    0 0.2em 0 0 #dcdcdc,
    0 0.225em 0 0 #cacaca,
    0 0.225em 0.375em 0 #cecece;
}
</style>
