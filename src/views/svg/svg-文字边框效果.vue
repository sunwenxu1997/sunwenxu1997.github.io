<script>
export default {
    articleLink:'https://juejin.cn/spost/7267092779280695337'
}
</script>
<template>
  <div class="app-content-center">
    <div class="svg-box">
      <svg width="100%" height="100">
        <text class="text" text-anchor="middle" x="50%" y="70%">Text Border</text>
      </svg>
      <svg width="100%" height="100">
        <text class="text t2" text-anchor="middle" x="50%" y="70%">Text Border</text>
      </svg>
      <svg width="100%" height="100">
        <text class="text t3" text-anchor="middle" x="50%" y="70%">Text Border</text>
      </svg>
      <svg width="100%" height="100">
        <text class="text t4" text-anchor="middle" x="50%" y="70%">Text Border</text>
      </svg>
      <svg width="100%" height="100">
        <symbol id="s-text">
          <text text-anchor="middle" x="50%" y="70%">Text Border</text>
        </symbol>
        <use class="text_use t1" xlink:href="#s-text"></use>
        <use class="text_use t2" xlink:href="#s-text"></use>
        <use class="text_use t3" xlink:href="#s-text"></use>
      </svg>
    </div>
  </div>
</template>
<style lang="scss" scoped>
.svg-box{
    width: 50vw;
}
svg {
  cursor: pointer;
}

svg:hover .text {
  fill: #d3d3d3;
}

.text {
  font-size: 60px;
  font-weight: bold;
  stroke-width: 2;
  fill: transparent;
  stroke: rgb(0, 0, 0);
  letter-spacing: 0.5rem;
  transition: 0.3s;
}

.text.t2 {
  /* stroke-linejoin 圆角 */
  stroke-linejoin: round;
  stroke-dasharray: 10;
}

.text.t3 {
  stroke-linejoin: round;
  stroke-dasharray: 10;
  stroke-dashoffset: 0;
  animation: dong3 3s linear infinite;
}

.text.t4 {
  stroke-dasharray: 10 400;
  animation: dong4 3s linear infinite;
}

@keyframes dong3 {
  100% {
    stroke-dashoffset: 400;
  }
}

@keyframes dong4 {
  100% {
    stroke-dasharray: 400 0;
  }
}

.text_use {
  font-size: 60px;
  font-weight: bold;
  stroke-width: 2;
  fill: transparent;
  letter-spacing: 0.5rem;
  stroke-dasharray: 30 30;
  animation: dong5 3s linear infinite;
}

.text_use.t1 {
  animation-delay: -1s;
  stroke: rgb(219, 56, 56);
}

.text_use.t2 {
  animation-delay: -0.2s;
  stroke: rgb(65, 209, 149);
}

.text_use.t3 {
  animation-delay: -0.1s;
  stroke: rgb(127, 52, 224);
}

@keyframes dong5 {
  100% {
    stroke-dashoffset: -300;
  }
}
</style>
