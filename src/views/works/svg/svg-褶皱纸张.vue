<script>
export default {
  articleLink:
    'https://juejin.cn/post/6943032791122575390?searchId=20231025171909A1A3EA985C27827359F6#heading-18'
}
</script>
<template>
  <svg width="0" height="0">
    <defs>
      <filter id="filterPaper" x="0%" y="0%" width="100%" height="100%">
        <feTurbulence
          type="fractalNoise"
          baseFrequency="0.04"
          result="noise"
          numOctaves="5"
        ></feTurbulence>
        <feDiffuseLighting in="noise" lighting-color="#fff" surfaceScale="2">
          <feDistantLight azimuth="45" elevation="60" />
        </feDiffuseLighting>
      </filter>
    </defs>
    <defs>
      <filter id="filterText" x="0%" y="0%" width="100%" height="100%">
        <feTurbulence type="fractalNoise" baseFrequency="0.04" numOctaves="5"></feTurbulence>
        <feDisplacementMap
          id="feDisplacementMap"
          in="SourceGraphic"
          scale="3"
        ></feDisplacementMap>
      </filter>
    </defs>
  </svg>
  <div class="app-content-center">
    <div class="paper">
      <div class="content">
        <h1>一封书信</h1>
        <p>亲爱的</p>
        <p>好吧，我知道你会把这封信给扔进垃圾桶，那么在这之前，请你也好好思考一下。</p>
        <br>
        <br>
        <br>
        <br>
        <p style="text-align:right">你的宝</p>
      </div>
    </div>
  </div>
</template>
<style lang="scss" scoped>
h1{
    text-align: center;
}
.paper {
  width: 40vw;
  height: 80vh;
  position: relative;
  z-index: 2;
  padding: 2em;
  font-size: 1.5em;
  &::before {
    content: '';
    width: 100%;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    background: white;
    filter: url(#filterPaper);
    z-index: -1;
  }
  .content {
    filter: url(#filterText);
  }
}
</style>
