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
const num = 10
</script>
<template>
  <!-- 通过控制动画延迟时间和透明度，实现运动模糊轨迹效果 -->
  <div
    class="dot"
    v-for="item in num"
    :key="item"
    :style="`animation-delay: ${0.02 * item}s; opacity: ${(num - item) * 0.05};`"
  ></div>
  <div
    class="dot two"
    v-for="item in num"
    :key="item"
    :style="`animation-delay: ${0.02 * item}s; opacity: ${(num - item) * 0.05};`"
  ></div>
  <div
    class="dot three"
    v-for="item in num"
    :key="item"
    :style="`animation-delay: ${0.02 * item}s; opacity: ${(num - item) * 0.05};`"
  ></div>
  <div
    class="dot four"
    v-for="item in num"
    :key="item"
    :style="`animation-delay: ${0.02 * item}s; opacity: ${(num - item) * 0.05};`"
  ></div>
</template>
<style scoped lang="scss">
$dotSize: 80px;
.dot {
  position: absolute;
  top: 0;
  left: 0;
  width: $dotSize;
  height: $dotSize;
  border-radius: 50%;
  animation-composition: accumulate;
  background-color: #409eff;
  animation:
    horizontal 2s linear infinite alternate,
    vertical 5s linear infinite alternate,
    // 24 = 8 * 2
    colorX 16s infinite steps(8),
    // 35 = 7 * 5
    colorY 35s infinite steps(7);
}
.dot.two {
  animation:
    horizontal 2s linear infinite alternate-reverse,
    vertical 5s linear infinite alternate-reverse,
    // 24 = 8 * 2
    colorX 16s infinite steps(8) alternate-reverse,
    // 35 = 7 * 5
    colorY 35s infinite steps(7) alternate-reverse;
}
.dot.three {
  animation:
    horizontal 2s linear infinite alternate-reverse,
    vertical 5s linear infinite alternate,
    // 24 = 8 * 2
    colorX 16s infinite steps(8) alternate-reverse,
    // 35 = 7 * 5
    colorY 35s infinite steps(7) alternate;
}
.dot.four {
  animation:
    horizontal 2s linear infinite alternate,
    vertical 5s linear infinite alternate-reverse,
    // 24 = 8 * 2
    colorX 16s infinite steps(8) alternate,
    // 35 = 7 * 5
    colorY 35s infinite steps(7) alternate-reverse;
}
/* 水平移动 */
@keyframes horizontal {
  to {
    transform: translateX(calc(100vw - #{$dotSize}));
  }
}
// 纵向移动
@keyframes vertical {
  to {
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
