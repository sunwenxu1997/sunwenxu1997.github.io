<script>
/**
 * 知识点：
 * backdrop-filter 背景模块滤镜，类似于filter 推荐
 */
/**
 *  filter 配合 也可以实现背景图片引入方式实现毛玻璃效果
 *  clip-path: inset(15em);
    filter: blur(20px);
 */
export default {
  link: 'https://juejin.cn/post/6979391400844460068?searchId=20230807153325C066903F9072D51F4CEE',
  cover: 'https://iili.io/JqJOBO7.png',
  info: `之前尝试实现磨砂效果，都会想着用fliter滤镜加模糊实现。但是效果总是那么差点意思，后来css推出了 <b>backdrop-filter</b> 属性，值得一试。
    知识点：
    1. <code>backdrop-filter</code> 背景模块滤镜，类似于filter
    2. <code>clip-path: inset(10px)</code> 相当于整体向内裁切10px
    `
}
</script>
<template>
  <div class="app-content-center">
    <div class="glass">GLASS</div>
  </div>
</template>
<style scoped>
/* @import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap'); */

.app-content-center {
  background-image: url('https://picsum.photos/id/821/1920/1080');
  background-size: cover;
  background-position: center;
  font-family: 'Rajdhani', sans-serif;
}

.glass {
  width: 40vmax;
  height: 30vmin;
  font-size: 4vmax;
  color: white;
  text-align: center;
  line-height: 30vmin;
  letter-spacing: 0.75em;
  padding-left: 0.75em;
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
  /* filter: drop-shadow(0px 20px 10px rgba(0, 0, 0, 0.3)); */
  box-shadow: 0px 20px 10px rgba(0, 0, 0, 0.3);
}
</style>
