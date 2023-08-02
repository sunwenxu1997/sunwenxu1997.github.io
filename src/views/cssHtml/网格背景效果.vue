<template>
  <div class="overall">
    <div class="grid-xu"></div>
    <div class="grid-shi"></div>
    <!-- <div class="content">
      <h1>网格背景</h1>
      <p>The grid background</p>
    </div> -->
  </div>
</template>

<script>
export default {}
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
  //  animation: play 15s linear infinite ;
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
  // animation: play 10s linear infinite ;
}
@keyframes play {
  100% {
    background-position:  120px 120px;
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