<template>
  <div class="overall">
    <div class="grid-xu"></div>
    <div class="grid-shi"></div>
  </div>
</template>

<script>
export default {
  cover: 'https://iili.io/JqJOoxe.png',
  link: 'https://juejin.cn/post/7160858048636911652',
  info: `某一天感觉单纯的背景色有点单一，同时看到掘金有些文章背部有类似网格形状的东西，所以就好奇的尝试实现下。其实原理还是挺简单的，当然你也可以直接通过图片来实现（放大会模糊），但是当你真正掌握后，它不仅仅能实现网格，还有其他更多花样背景呢。
  知识点：
  1. <code>linear-gradient</code> 背景渐变；
  2. <code>background-size</code> 背景尺寸；
  3. <code>background-repeat</code> 背景重复；
`
}
</script>

<style lang="scss" scoped>
$gridSizeXu: 20px;
$gridSizeShi: 60px;
$gridColor: #5f5f5f;
/* 虚线部分 */
.grid-xu {
  overflow: hidden;
  width: 100%;
  height: 100%;
  position: fixed;
  z-index: -2;
  transform: scale(1.1);
}
.grid-xu::before,
.grid-xu::after {
  opacity: 0.5;
  content: '';
  background-repeat: repeat;
  position: absolute;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  animation: play 15s linear infinite;
}
.grid-xu::before {
  /* 从左往右 */
  background: linear-gradient(to right, white 1px, transparent 1px),
    linear-gradient(to bottom, $gridColor 0.5px, transparent 0.5px);
  background-size: 3px $gridSizeXu;
}
.grid-xu::after {
  /* 从上往下 */
  background: linear-gradient(to bottom, white 1px, transparent 1px),
    linear-gradient(to right, $gridColor 0.5px, transparent 0.5px);
  background-size: $gridSizeXu 3px;
}
/* 实线条部分 */
.grid-shi {
  overflow: hidden;
  width: 100%;
  height: 100%;
  position: fixed;
  z-index: -1;
  transform: scale(1.1);
  background: linear-gradient(to right, $gridColor 0.5px, transparent 0.5px),
    linear-gradient(to bottom, $gridColor 0.5px, transparent 0.5px);
  background-size: $gridSizeShi $gridSizeShi;
  background-repeat: repeat;
  animation: play 10s linear infinite;
}
@keyframes play {
  100% {
    background-position: 120px 120px;
    //  background-size: 70px 70px;
  }
}
.content {
  text-align: center;
}
.content h1 {
  font-weight: 300;
  letter-spacing: 0.7rem;
  margin: 0;
}
.content p {
  font-size: 14px;
  font-weight: 200;
  text-transform: uppercase;
  letter-spacing: 0.1rem;
  text-decoration: line-through;
  color: #5a5a5a;
}
</style>
