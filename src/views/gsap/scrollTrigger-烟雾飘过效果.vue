<template>
  <div class="cloud-container">
    <div class="smoke-canvas"></div>
  </div>
</template>

<script>
import smoke from '@/assets/js/threejsSmokeMoveCanvas.js'
export default {
  mounted() {
    smoke.play('.smoke-canvas')
    let nowHour = new Date().getHours()
    let container = document.querySelector('.cloud-container')
    if (nowHour < 6) {
      container.style.background =
        'linear-gradient(20deg,rgb(205, 248, 248) 0%,rgb(51, 139, 161) 50%,rgb(3, 84, 122) 100%)'
      // document.write("早上好！");
    } else if (nowHour < 15) {
      container.style.background =
        'linear-gradient(-150deg, rgb(205, 224, 248) 0%, rgb(51, 99, 161) 50%,rgb(3, 55, 122) 100%)'
      // document.write("中午好！");
    } else if (nowHour < 19) {
      container.style.background =
        'linear-gradient(-10deg,rgb(248, 205, 112) 0%,rgb(216, 89, 16) 50%,rgb(126, 30, 86) 100%)'
      // document.write("下午好！");
    } else {
      this.moon = true
      container.style.background =
        'linear-gradient(0deg,rgb(16, 44, 95) 0%,rgb(9, 29, 66) 50%,rgb(0, 7, 19) 100%)'
      // document.write("夜里好！");
    }
  },
  unmounted() {
    smoke.clear()
  }
}
</script>

<style lang="scss" scoped>
.cloud-container {
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(
    20deg,
    rgb(205, 248, 248) 0%,
    rgb(51, 139, 161) 50%,
    rgb(3, 84, 122) 100%
  );
  //   background: linear-gradient(
  //     -150deg,
  //     rgb(205, 224, 248) 0%,
  //     rgb(51, 99, 161) 50%,
  //     rgb(3, 55, 122) 100%
  //   );
  contain: strict;
  backface-visibility: visible;
}

.smoke-canvas {
  mix-blend-mode: screen;
}
</style>
