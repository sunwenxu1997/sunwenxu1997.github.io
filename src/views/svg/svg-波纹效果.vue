<script>
/**
 * 实现波纹的方式有很多种，这里推荐使用svg滤镜，简单易用
 * 方式一：使用svg静态滤镜，通过控制css动画以静制动
 * https://www.jianshu.com/p/4928085a633f
 * 
 * 方式2：使用svg动态滤镜，比较推荐。而且本文也是用的这种方案
 * https://www.jianshu.com/p/5923bd4d8774
 */
/**
 * https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence/
 * baseFrequency 表示噪声的基本频率参数，默认值是0，频率越高，噪声越密集
 * numOctaves 属性numOctaves就表示倍频的数量，默认值是1，不能是小数，只能是整数，如果是小数会当作默认值1处理。
 */
export default {
  articleLink: 'https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence'
}
</script>
<template>
  <div class="app-content">
    <h1>ripple</h1>
    <img class="img" src="https://picsum.photos/id/581/2509/1672" alt="" />
  </div>
  <!-- <svg display="none">
    <defs>
      <filter id="wreckit">
        <feTurbulence id="turbulence" baseFrequency="0.02" numOctaves="3" result="noise" seed="4" />
        <feDisplacementMap in="SourceGraphic" in2="noise" scale="8" />
      </filter>
    </defs>
  </svg> -->
  <svg width="0" height="0">
    <filter id="water">
      <!-- baseFrequency 水平，垂直噪点数值，越大越噪点越多 -->
      <!-- dur  波纹波动频率 -->
      <!-- scale 波纹密集度 -->
      <feTurbulence type="fractalNoise" baseFrequency=".01 .01" numOctaves="1" result="noise1" />
      <feColorMatrix in="noise1" type="hueRotate" values="0" result="noise2">
        <animate attributeName="values" from="0" to="360" dur="3s" repeatCount="indefinite" />
      </feColorMatrix>
      <feDisplacementMap
        xChannelSelector="R"
        yChannelSelector="G"
        scale="50"
        in="SourceGraphic"
        in2="noise2"
      />
    </filter>
  </svg>
</template>
<style scoped>
.app-content {
  width: 100%;
  height: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
}
h1 {
  position: relative;
  z-index: 2;
  font-size: 5vw;
  letter-spacing: 1rem;
  color: white;
}
.img {
  display: block;
  width: 100%;
  height: 100%;
  filter: url(#water);
  object-fit: cover;
  transform: scale(1.1);
  position: absolute;
  left: 0;
  top: 0;
}
</style>
