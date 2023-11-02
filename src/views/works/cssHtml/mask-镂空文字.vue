<script>
export default {
  articleLink: 'https://github.com/chokcoco/iCSS/issues/80',
  cover:'https://iili.io/JqJOTfj.png'
}
</script>
<script setup>
import { onMounted } from 'vue'
onMounted(() => {})
</script>
<template>
  <div class="app-content-center">
    <div class="bg"></div>
    <div class="mask"></div>
  </div>
</template>
<style lang="scss" scoped>
.bg {
  position: fixed;
  // top left right bottom 同比例拉伸20px;
  top: -20px;
  left: -20px;
  right: -20px;
  bottom: -20px;
  overflow: hidden;
  background: url('https://sp-webfront.skypixel.com/skypixel/v2/public/website/assets/1535027674204-f6eca6369ec03e70262b58b0e25cda7b.jpg');
  background-size: cover;
  //   背景模糊 亮度0.5
  filter: blur(10px) brightness(0.5);
}
.mask {
  width: 340px;
  height: 196px;
  // 背景山川图片
  background: url('https://sp-webfront.skypixel.com/skypixel/v2/public/website/assets/1535027674204-f6eca6369ec03e70262b58b0e25cda7b.jpg');
  background-size: cover;
  // 遮罩层svg -- dij
  mask: url('http://www2.djicdn.com/assets/images/v3/logo-black2-145dcb13c56f36a65d084180a42136fa.svg');
  mask-size: cover;
  filter: brightness(1.3);
  animation: move 100s infinite;
}

@keyframes move {
  0% {
    background-position: 0 0;
  }
  50% {
    background-position: 100% 0;
  }
}
</style>
