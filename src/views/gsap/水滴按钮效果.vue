<script>
export default {
  articleLink: 'https://juejin.cn/post/7159379138648735780'
}
</script>
<script setup>
import { onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
var bt
onMounted(() => {
  bt = document.querySelector('.btn')
  bt.addEventListener('mousemove', mouseListener)
})
onUnmounted(() => {
  bt.removeEventListener('mousemove', mouseListener)
})
const mouseListener = (e) => {
  let blob = document.querySelectorAll('.ball')
  let rect = bt.getBoundingClientRect()
  let x = (e.pageX - rect.left - rect.width / 2) * 0.3
  let y = (e.pageY - rect.top - rect.height / 2) * 0.3
  gsap.to(blob[0], { x: x, y: y, duration: 4.2, ease: 'elastic(1,0.1)' })
  gsap.to(blob[1], { x: x, y: -y, duration: 2.8, ease: 'elastic(1,0.1)' })
  gsap.to(blob[2], { x: -x, y: -y, duration: 2.8, ease: 'elastic(1,0.1)' })
}
</script>
<template>
  <div class="app-content-center">
    <div class="btn">
      <span class="ball"></span>
      <span class="ball"></span>
      <span class="ball"></span>
      <span class="text">HOVER</span>
    </div>
    <svg style="width: 0; height: 0">
      <defs>
        <filter id="shadowed-goo">
          <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="10" />
          <feColorMatrix
            in="blur"
            mode="matrix"
            values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7"
            result="goo"
          />
          <feGaussianBlur in="goo" stdDeviation="3" result="shadow" />
          <feColorMatrix
            in="shadow"
            mode="matrix"
            values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 -0.2"
            result="shadow"
          />
          <feOffset in="shadow" dx="1" dy="1" result="shadow" />
          <feBlend in2="shadow" in="goo" result="goo" />
          <feBlend in2="goo" in="SourceGraphic" result="mix" />
        </filter>
      </defs>
    </svg>
  </div>
</template>
<style scoped>
.btn {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  background: #208cf1;
  filter: url('#shadowed-goo');
  position: relative;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
}

.ball {
  display: inline-block;
  width: 100%;
  height: 100%;
  background: #208cf1;
  border-radius: 50%;
  position: absolute;
  left: 0;
  top: 0;
  opacity: 1;
}

.text {
  position: relative;
  z-index: 5;
  color: white;
  font-weight: 100;
}
</style>
