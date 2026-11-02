<script>
export default {
  cover: 'https://iili.io/K99P0Cv.gif',
  date: '2025-08-21',
  codepen: 'https://codepen.io/sunwenxu1997/pen/RNWMXOr',
  info: `近期网上看到的一个效果，实现起来也很简单。同时挖掘到了一个很牛的[Filip Zrnzevic😎大佬](https://codepen.io/filipz)，写的效果都很炫酷。
           \`animejs-text\` 官方提供的文本 [分割插件](https://animejs.cn/documentation/text/split/split-parameters/class)，相比于GSAP是不额外收费的，不过animejs版本要在4.0以上；
           \`fractalNoise\` background-image 引入本地定义好的噪点svg，通过重复动画随即修改 background-size 实现噪点波动效果
           `
}
</script>
<script setup>
import { onMounted } from 'vue'
import { animate, utils, text, stagger, createTimer } from 'animejs'
onMounted(() => {
  const [$text] = utils.$('.text')
  // 分割文字
  const { chars } = text.split($text, {
    chars: { class: 'anime-split-char' }
  })
  animate(chars, {
    y: [{ to: ['100%', '0%'] }, { to: '-100%', delay: 600, ease: 'in(3)' }],
    filter: [{ to: ['blur(8px)', 'blur(0px)'] }, { to: 'blur(8px)', delay: 600, ease: 'in(3)' }],
    opacity: [{ to: [0, 1] }, { to: 0, delay: 600, ease: 'in(3)' }],
    duration: 600,
    ease: 'out(3)',
    delay: stagger(50),
    loop: true
  })
  // 执行重复动画，通过改变噪点图尺寸，实现噪音波点效果
  createTimer({
    loop: true,
    duration: 60,
    onLoop: () => {
      animate('.noise', {
        backgroundSize: `${utils.random(100, 300)}px`
      })
    }
  })
})
</script>
<template>
  <div class="app-content-center">
    <div class="noise"></div>
    <div class="text">filter blur text.</div>
  </div>
</template>
<style>
.anime-split-char {
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 0 5px;
  margin: 0 2px;
}
</style>
<style lang="scss" scoped>
.app-content-center {
  display: flex;
  justify-content: center;
  align-items: center;
  background: #2e47da;
}
.noise {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 250 250' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='4' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
  //   opacity: 0.3;
  z-index: 100;
  pointer-events: none;
  mix-blend-mode: overlay;
  background-size: 300px;
}
.text {
  font-size: 20px;
  color: #fff;
  text-transform: uppercase;
  font-weight: bold;
}
</style>
