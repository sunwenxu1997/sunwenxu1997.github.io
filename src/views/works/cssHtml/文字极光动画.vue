<script>
/**
 * 知识点：
 * mix-blend-mode
 * https://blog.csdn.net/qq_51248309/article/details/129857020
 * 降暗混合模式  darken,multiply,color-burn  减色模式，滤掉图像中高亮色，从而达到图像变暗
 */
export default {
  info: ` 
    <p>🌈属于文字效果，但更适合于纯黑色背景，有点局限性。更推荐用背景裁切 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-clip">background-clip: text;</a></p>
    <p>知识点：</p>
    <p>1. <code>mix-blend-mode</code> 混合模式</p>
    <p>2. <code>clamp()</code> 函数的作用是把一个值限制在一个上限和下限之间，当这个值超过最小值和最大值的范围时，在最小值和最大值之间选择一个值使用。它接收三个参数：最小值、首选值、最大值。 </p>
    `
}
</script>
<template>
  <div class="app-content-center">
    <h1 class="title">
      the beautiful aurora
      <div class="aurora">
        <div class="aurora__item"></div>
        <div class="aurora__item"></div>
        <div class="aurora__item"></div>
        <div class="aurora__item"></div>
      </div>
    </h1>
  </div>
</template>
<style scoped lang="scss">
$--bg: #000000;
$--clr-1: #00c2ff;
$--clr-2: #33ff8c;
$--clr-3: #ffc640;
$--clr-4: #e54cff;
$--blur: 1rem;
$--fs: clamp(3rem, 8vw, 7rem);
$--ls: clamp(-1.75px, -0.25vw, -3.5px);
.app-content-center {
  background-color: $--bg;
}
.title {
  font-size: $--fs;
  font-weight: 800;
  letter-spacing: $--ls;
  position: relative;
  overflow: hidden;
  margin: 0;
  padding: 30px;
  color: white;
  background-color: $--bg;
  text-align: center;
}

.aurora {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2;
  // 降暗混合模式  darken,multiply,color-burn  减色模式，滤掉图像中高亮色，从而达到图像变暗
  // 加亮混合模式  screen,lighten,color-dodge  加色模式，滤掉图像中暗色，从而达到图像变亮
  mix-blend-mode: darken; // 混合模式 变暗
  pointer-events: none;
}

.aurora__item {
  overflow: hidden;
  position: absolute;
  width: 60vw;
  height: 60vw;
  background-color: $--clr-1;
  border-radius: 37% 29% 27% 27% / 28% 25% 41% 37%;
  filter: blur($--blur);
  mix-blend-mode: overlay; // 混合模式 叠加
}

// 定义每个极光的颜色和运动轨迹动画
.aurora__item:nth-of-type(1) {
  top: -50%;
  animation:
    aurora-border 6s ease-in-out infinite,
    aurora-1 12s ease-in-out infinite alternate;
}

.aurora__item:nth-of-type(2) {
  background-color: $--clr-3;
  right: 0;
  top: 0;
  animation:
    aurora-border 6s ease-in-out infinite,
    aurora-2 12s ease-in-out infinite alternate;
}

.aurora__item:nth-of-type(3) {
  background-color: $--clr-2;
  left: 0;
  bottom: 0;
  animation:
    aurora-border 6s ease-in-out infinite,
    aurora-3 8s ease-in-out infinite alternate;
}

.aurora__item:nth-of-type(4) {
  background-color: $--clr-4;
  right: 0;
  bottom: -50%;
  animation:
    aurora-border 6s ease-in-out infinite,
    aurora-4 24s ease-in-out infinite alternate;
}

@keyframes aurora-1 {
  0% {
    top: 0;
    right: 0;
  }

  50% {
    top: 100%;
    right: 75%;
  }

  75% {
    top: 100%;
    right: 25%;
  }

  100% {
    top: 0;
    right: 0;
  }
}

@keyframes aurora-2 {
  0% {
    top: -50%;
    left: 0%;
  }

  60% {
    top: 100%;
    left: 75%;
  }

  85% {
    top: 100%;
    left: 25%;
  }

  100% {
    top: -50%;
    left: 0%;
  }
}

@keyframes aurora-3 {
  0% {
    bottom: 0;
    left: 0;
  }

  40% {
    bottom: 100%;
    left: 75%;
  }

  65% {
    bottom: 40%;
    left: 50%;
  }

  100% {
    bottom: 0;
    left: 0;
  }
}

@keyframes aurora-4 {
  0% {
    bottom: -50%;
    right: 0;
  }

  50% {
    bottom: 0%;
    right: 40%;
  }

  90% {
    bottom: 50%;
    right: 25%;
  }

  100% {
    bottom: -50%;
    right: 0;
  }
}

@keyframes aurora-border {
  0% {
    border-radius: 37% 29% 27% 27% / 28% 25% 41% 37%;
  }

  25% {
    border-radius: 47% 29% 39% 49% / 61% 19% 66% 26%;
  }

  50% {
    border-radius: 57% 23% 47% 72% / 63% 17% 66% 33%;
  }

  75% {
    border-radius: 28% 49% 29% 100% / 93% 20% 64% 25%;
  }

  100% {
    border-radius: 37% 29% 27% 27% / 28% 25% 41% 37%;
  }
}
</style>
