<script>
export default {
    cover: 'https://iili.io/FsuNQu1.gif',
    date: '2025-08-08',
    codepen: 'https://codepen.io/sunwenxu1997/pen/pvjrzew',
    link: 'https://juejin.cn/post/7412490116793909286',
    info: `闲逛掘金时发现的一个好玩效果🌊，作者是通过scss实现的动画效果，这里我尝试用 animejs 做了实现。
           \`.cloneNode:\` 克隆复制dom节点，批量创建26（涉及到后面的裁切，这个数量基本能达到100%的裁切）个文字元素层；
           \`clip-path:\` 第一块裁切比例 clip-path: polygon(-30% 0, -20% 0, 20% 100%, 0% 100%)，clip-path: polygon(-25% 0, -15% 0, 25% 100%, 5% 100%)，以此类推...
           动画执行时间和旋转角度这些就不做过多陈述了，基本都是经过实践得到的最优效果👻
           `
}
</script>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { animate, utils } from 'animejs'
onMounted(() => {
  const rate = 1.5 // 速度

  const [$body] = utils.$('.app-content-center')
  const [textBox] = utils.$(`.text-box`)
  for (let i = 0; i < 26; i++) {
    const $el = textBox.cloneNode(true)
    $body.appendChild($el)
    const deviation = 5 // 裁切偏差
    utils.set($el, {
      clipPath: `polygon(
        ${-30 + i * deviation}% 0%,
        ${-20 + i * deviation}% 0%,
        ${20 + i * deviation}% 100%,
        ${0 + i * deviation}% 100%
    )`
      // color: utils.randomPick(['rgb(60, 27, 221)','rgb(50, 230, 255)']),
    })
    animate($el, {
      scale: [0.9, 1.1],
      rotateX: [10, -10],
      rotateY: [10, -10],
      color: ['rgba(0, 30, 100, 1)', 'rgba(50, 230, 255, 1)'],
      duration: 2000 / rate,
      delay: (i * 200) / rate - 10000,
      ease: 'inOut(2)',
      loop: true,
      alternate: true
    })
  }
})
</script>
<template>
  <div class="app-content-center">
    <div class="text-box">WHO.</div>
  </div>
</template>
<style lang="scss" scoped>
@import "https://fonts.googleapis.com/css?family=Anton";
.app-content-center {
  display: flex;
  justify-content: center;
  align-items: center;
  background: #1a1a1a;
  perspective: 1000px;
}
.text-box {
  position: absolute;
  font-size: 12vmax;
  font-weight: 900;
  font-family: "Anton", sans-serif;
  transform-style: preserve-3d;
  mix-blend-mode: screen;
  color: #fff;
}
.text-box:first-child {
  display: none;
}
</style>
