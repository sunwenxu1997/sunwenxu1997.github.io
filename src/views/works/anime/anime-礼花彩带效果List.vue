<script>
export default {
  hidden: true
}
</script>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { animate, createAnimatable, utils, createTimer } from 'animejs'
const bgFlowerArr = ref([])

onMounted(() => {
  const [$body] = utils.$('.body')
  const bounds = $body.getBoundingClientRect()
  const bgFlowerSpeed = 0.5 // 背景礼花飘落速度
  const bgFlowerNum = 200 // 背景礼花数量
  const bgFlowerSize = 10 // 背景礼花大小
  const { width, height } = bounds
  for (let i = 0; i < bgFlowerNum; i++) {
    const scale = utils.random(0.2, 1.2, 1)
    const style = {
      width: `${bgFlowerSize * scale}px`,
      height: `${bgFlowerSize * scale}px`,
      position: 'absolute',
      left: `${utils.random(0, width)}px`,
      top: `${utils.random(-50, -20)}px`,
      background: utils.randomPick([
        '#dce90d',
        '#0de9be',
        '#0dbce9',
        '#e9530d',
        '#e90d59',
        '#ffffff'
      ]),
      transform: `translate3d(0px, 0px, 0px) rotate3d(1, 1, 1, 0turn)`,
    }
    const styleStr = styleToStr(style)
    console.log(styleStr);
    bgFlowerArr.value.push({ styleStr })

    animate(style, {
      transform: `translate3d(
        ${utils.random(-100, 100)}px,
        ${utils.random(height + 50, height + 100)}px, 
        0px) rotate3d(1, 1, 1, ${
          // 计算总旋转角度（这里取三个轴旋转角度的最大值，也可按需求调整）
          Math.max(utils.random(1, 3), utils.random(1, 3), 1)
        }turn)`,
      duration: (6000 - 2000 * scale) / bgFlowerSpeed,
      delay: utils.snap(utils.random(-5000, 5000), 500) / bgFlowerSpeed,
      ease: 'inOut(2)',
      loop: true,
      onUpdate: () => {
        bgFlowerArr.value[i].style = style
        bgFlowerArr.value[i].styleStr = styleToStr(style)
      },
      onComplete:() => { 
        console.log(styleToStr(style));
      },
    })
  }
})
// 将样式对象转为字符串
const styleToStr = (style) => {
  return Object.keys(style).reduce((acc, cur) => {
    acc += `${cur}:${style[cur]};`
    return acc
  }, '')
}
</script>
<template>
  <div class="body">
    <div class="dot" v-for="(item, i) in bgFlowerArr" :key="i" :style="item.styleStr"></div>
  </div>
</template>
<style lang="scss" scoped>
.body {
  background: #127de9;
  width: 100vw;
  height: 100dvh;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  perspective: 1000px;
}
.anime-box {
  position: relative;
}
.button {
  position: relative;
  z-index: 2;
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
