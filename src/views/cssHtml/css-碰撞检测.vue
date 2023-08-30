<script>
export default {
  articleLink: 'https://juejin.cn/post/7269797025863499837'
}
</script>
<script setup>
/**
 * 知识点：
 * animation-composition 动画合成
 *  animation-composition: replace;        // 表示动画值替换
    animation-composition: add;              // 表示动画值追加
    animation-composition: accumulate; // 表示动画值累加
 */
</script>
<template>
  <div class="dot one"></div>
  <div class="dot two"></div>
  <svg width="0" height="0" viewBox="0 0 16 16">
    <clipPath id="clipPath">
      <path
        transform="scale(4)"
        d="M8 0c-.787 0-1.292.592-1.572 1.151A4.347 4.347 0 0 0 6 3v3.691l-2 1V7.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.191l-1.17.585A1.5 1.5 0 0 0 0 10.618V12a.5.5 0 0 0 .582.493l1.631-.272.313.937a.5.5 0 0 0 .948 0l.405-1.214 2.21-.369.375 2.253-1.318 1.318A.5.5 0 0 0 5.5 16h5a.5.5 0 0 0 .354-.854l-1.318-1.318.375-2.253 2.21.369.405 1.214a.5.5 0 0 0 .948 0l.313-.937 1.63.272A.5.5 0 0 0 16 12v-1.382a1.5 1.5 0 0 0-.83-1.342L14 8.691V7.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v.191l-2-1V3c0-.568-.14-1.271-.428-1.849C9.292.591 8.787 0 8 0Z"
      />
    </clipPath>
  </svg>
</template>
<style scoped lang="scss">
$dotSize: 64px;
.dot {
  clip-path: url('#clipPath');
  width: $dotSize;
  height: $dotSize;
  position: absolute;
  top: 0;
  left: 0;
  animation-composition: accumulate;
  background-color: #409eff;
}
.dot.one {
  animation:
    horizontal 3s linear infinite -1s alternate,
    vertical 5s linear infinite -2s alternate,
    colorX 24s infinite -1s steps(8),
    // 24 = 8 * 3
    colorY 35s infinite -2s steps(7); // 35 = 7 * 5
}
.dot.two {
  background-color: #b940ff;
  animation-delay: 3s;
  animation:
    horizontal 3s linear infinite alternate,
    vertical 5s linear infinite alternate,
    colorX 24s infinite steps(8),
    colorY 35s infinite steps(7);
}

/* 水平移动 */
@keyframes horizontal {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(calc(100vw - #{$dotSize}));
  }
}
// 纵向移动
@keyframes vertical {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(calc(100vh - #{$dotSize}));
  }
}
// 变换颜色
@keyframes colorX {
  to {
    filter: hue-rotate(360deg);
  }
}
@keyframes colorY {
  to {
    filter: hue-rotate(360deg);
  }
}
</style>
