<script setup>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
// import { Draggable } from 'gsap/Draggable.js'
import { onMounted, onUnmounted } from 'vue'
const list = 20
//定义一个初始化的对象数据，每次滚动时都会由此对象执行动画操作
let proxy = { blur: 0 }

onMounted(() => {
  gsap.registerPlugin(ScrollTrigger)
  //   gsap.registerPlugin(Draggable)

  let sections = gsap.utils.toArray('.blur-img')
  // 不要让模糊超过50
  let clamp = gsap.utils.clamp(-50, 50)
  gsap.to(sections, {
    xPercent: -100 * (sections.length - 1), // 每个部分都向左移动100％ 此处的100是每个section的宽度
    ease: 'none',
    scrollTrigger: {
      trigger: '.container', //容器
      pin: true, //钉住目标至窗口运动轨迹位置
      scrub: true, //将动画的进度直接链接到滚动条，这样它就像一个洗涤器
      markers: true, //显示触发器的位置
      // 垂直滚动是基于容器的宽度，这样感觉更自然.
      end: () => '+=5000',
      //   滚动条每次滚动时都会执行的操作
      onUpdate(self) {
        let blur = Math.abs(clamp(self.getVelocity() / 100))
        proxy.blur = blur
        setBlurGsap()
      }
    }
  })
  //   Draggable.create('.container', {
  //     type: 'x',
  //     bounds: '.app-content',
  //     inertia: true, //绿🧦会员福利才会有效果，相当于一个惯性效果
  //     onDrag: function () {
  //       setBlurGsap()
  //     }
  //   })
})
onUnmounted(() => {
  ScrollTrigger.killAll()
})
// 设置高斯模糊
const setBlurGsap = () => {
  // 执行高斯模糊的动画，由proxy对象的blur属性控制，动画时间为0.3秒，期间执行onUpdate回调函数，更新svg的高斯模糊属性
  gsap.to(proxy, {
    blur: 0,
    duration: 0.3,
    overwrite: true,
    onUpdate: () => {
      document.getElementById('blur').childNodes[0].setAttribute('stdDeviation', `${proxy.blur} 0`)
    }
  })
}
</script>
<template>
  <div class="app-content">
    <div class="container" :style="`width: ${list * 100}vw`">
      <div class="blur-img" v-for="item in list" :key="item">
        <div class="index">{{ item }}</div>
        <img
          width="600"
          height="400"
          :src="`https://picsum.photos/600/400?random=${item}`"
          alt=""
        />
      </div>
    </div>
    <svg
      style="display: none"
      version="1.1"
      id="Layer_1"
      width="0"
      height="0"
      viewBox="0 0 1366 768"
      xml:space="preserve"
    >
      <!-- Gaussian blur filtter progression to animate -->
      <defs>
        <filter id="blur">
          <feGaussianBlur in="SourceGraphic" stdDeviation="0 0" />
        </filter>
      </defs>
    </svg>
  </div>
</template>
<style scoped>
.app-content {
  overflow: hidden;
}
.container {
  height: 100vh;
  display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fill, 600px);
  grid-gap: 100px;
  position: relative;
  box-sizing: border-box;
  overscroll-behavior: none;
}
.blur-img {
  width: 600px;
  height: 400px;
  filter: url(#blur);
  position: relative;
  text-align: center;
  line-height: 400px;
}
.index {
  width: 100%;
  position: absolute;
  font-size: 50px;
  color: #fff;
  text-align: center;
  font-weight: bold;
}
</style>
