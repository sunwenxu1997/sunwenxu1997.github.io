<script>
export default {
   cover:'https://i.imgur.com/xFdqroU.png'
}
</script>
<script setup>
import { ref, reactive, onMounted } from 'vue'
onMounted(() => {})
</script>
<template>
  <div class="app-content">
    <div class="mask"></div>
  </div>
</template>
<style lang="scss" scoped>
.app-content {
  background: white;
}
.mask {
  width: 100vw;
  height: 100vh;
  //   clip-path: inset(20vh 20vw);
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  background-size: 400% 400%;
  animation: gradientBG 15s ease infinite;
  position: relative;
}
@keyframes gradientBG {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}
// 网点效果图
.mask:nth-child(1) {
  mask: linear-gradient(
      to right,
      white 0%,
      white calc(100% - 1px),
      transparent calc(100% - 1px),
      transparent 100%
    ),
    linear-gradient(
      to bottom,
      white 0%,
      white calc(100% - 1px),
      transparent calc(100% - 1px),
      transparent 100%
    );
  mask-size: 20px 20px;
}
// // 噪点图
// .mask:nth-child(2) {
//   mask:
//     repeating-radial-gradient(#000 0 0.0001%, transparent 0 0.0002%) 60% 60%/3000px 3000px,
//     repeating-conic-gradient(#000 0 0.0001%, transparent 0 0.0002%) 40% 40%/2000px 3000px;
//   mask-size: 200px 200px;
// }
// // 动态擦除效果图
// .mask:nth-child(3) {
//   mask: url(https://i.imgur.com/AYJuRke.png);
//   mask-size: 3000% 100%;
//   animation: maskMove 2s steps(29) infinite alternate;
// }
// @keyframes maskMove {
//   from {
//     mask-position: 0 0;
//   }
//   to {
//     mask-position: 100% 0;
//   }
// }
</style>
