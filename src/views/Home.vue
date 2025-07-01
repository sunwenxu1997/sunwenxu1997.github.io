<script setup>
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import defaultSet from '../settings'
const layer = ref(null)
onMounted(() => {
  window.addEventListener('mousemove', mouseListener)
})
onUnmounted(() => {
  window.removeEventListener('mousemove', mouseListener)
})
// 图层根据鼠标移动
const mouseListener = function (event) {
  let rect = layer.value.getBoundingClientRect()
  let x = event.pageX - rect.width / 2
  let y = event.pageY - rect.height / 2
  gsap.to(layer.value, {
    x: x * 0.05,
    y: y * 0.05
  })
}
</script>
<template>
  <div class="w-screen h-svh flex items-center justify-center overflow-hidden">
    <div
      class="w-screen h-svh box-border relative flex items-center overflow-hidden sm:bg-clip-content sm:w-[calc(100%-12rem)] sm:max-w-screen-lg sm:h-2/3"
    >
      <div
        ref="layer"
        class="absolute left-0 w-full h-full bg-[url('https://picsum.photos/1920/1080')] bg-cover bg-center bg-zinc-800 scale-125"
      ></div>

      <div class="w-80 h-full absolute left-0 top-0 hidden sm:block home-glass" style="backdrop-filter: blur(3px); filter: url(#image5)"></div>
      <div class="text-white text-2xl font-black tracking-[.5rem] z-10 px-24 pointer-events-none">
        <p>A LIKE</p>
        <p>花里胡哨，</p>
        <p>前端程序员</p>
        <p>彩鸡。</p>
      </div>
    </div>
    <div
      class="absolute bottom-12 left-12 sm:left-24 font-bold text-white sm:text-black text-xs"
      style="font-family: 'Rajdhani', sans-serif"
    >
      ©2023 {{ defaultSet.userName }}
    </div>
    <svg width="0" height="0">
      <defs>
        <filter id="image5">
          <feImage
            result="pict7"
            xlink:href="/images/displacement/10.jpg"
            x="0"
            y="0"
            width="517"
            height="517"
          ></feImage>
          <feDisplacementMap
            scale="20"
            xChannelSelector="R"
            yChannelSelector="R"
            in2="pict7"
            in="SourceGraphic"
          ></feDisplacementMap>
        </filter>
      </defs>
    </svg>
  </div>
</template>
<style lang="scss" scoped>
// @import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');
.home-glass {
  mask: linear-gradient(to left,transparent 0%,  #000 100%);
}
</style>
