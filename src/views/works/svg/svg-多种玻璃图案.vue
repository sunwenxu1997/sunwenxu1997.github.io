<script>
export default {
  sort: 99,
  cover: 'https://iili.io/JqJO5JV.png',
  date: '2023.11.03',
  info: ` 
    <p>起初对玻璃滤镜这种概念并没有。一直以为只能用图片实现，直到后来发现有些网站上通过 <b>WebGl</b> 可以实现，因此就比较痴迷于它了。但是往往代码比较复杂，对于我这种菜鸡来说还没到那一层，于是就想到了如何通过svg滤镜来实现。终于功夫不负有心人，被我搞出来了。但是也有一些不足，就是对玻璃纹路尺寸大小有要求，太小的纹理图片无法重复平铺，且无法占满。so，搞得时候搞大点。这里简单给到效果给大家。</p>
    <p>知识点：</p>
    <p>1. <code>svg filter</code>svg滤镜</p>
    <p>2. <code>feImage</code>滤镜从外部来源取得图像数据，并提供像素数据作为输出（意味着如果外部来源是一个 SVG 图像，这个图像将被栅格化。） </p>
    <p>3. <code>feDisplacementMap</code>映射置换滤镜，该滤镜用来自图像中从in2 (en-US)到空间的像素值置换图像从in到空间的像素值。</p>
    `
}
</script>
<script setup>
/**
 * https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence/
 * baseFrequency 表示噪声的基本频率参数，默认值是0，频率越高，噪声越密集
 * numOctaves 属性numOctaves就表示倍频的数量，默认值是1，不能是小数，只能是整数，如果是小数会当作默认值1处理。
 */
/**
 * https://www.zhangxinxu.com/wordpress/2017/12/understand-svg-fedisplacementmap-filter/
 * 深入理解SVG feDisplacementMap滤镜及实际应用
 */
</script>
<template>
  <div class="app-content">
    <div class="item" v-for="item in 8" :key="item">
      <img src="@/assets/images/home.jpg" alt="" />
      <div class="glass"></div>
    </div>
  </div>
  <svg style="display: none">
    <defs>
      <filter id="image1">
        <feImage result="pict1" xlink:href="/images/displacement/1.jpg" x="0" y="0"
          width="527"
          height="336"
        ></feImage>
        <feDisplacementMap  scale="30" xChannelSelector="R" yChannelSelector="R"
          in2="pict1"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image2">
        <feImage
          result="pict2"
          xlink:href="/images/displacement/2.jpg"
          x="0"
          y="0"
          width="527"
          height="336"
        ></feImage>
        <feDisplacementMap
          scale="30"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict2"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image3">
        <feImage
          result="pict7"
          xlink:href="/images/displacement/7.jpg"
          x="0"
          y="0"
          width="523"
          height="330"
        ></feImage>
        <feDisplacementMap
          scale="30"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict7"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image4">
        <feImage
          result="pict4"
          xlink:href="/images/displacement/4.jpg"
          x="0"
          y="0"
          width="1000"
          height="1000"
        />
        <feDisplacementMap
          scale="30"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict4"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image5">
        <feImage
          result="pict7"
          xlink:href="/images/displacement/10.jpg"
          x="0"
          y="0"
          width="517"
          height="517"
        ></feImage>
        <feDisplacementMap
          scale="20"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict7"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image6">
        <feImage
          result="pict7"
          xlink:href="/images/displacement/14.jpg"
          x="0"
          y="0"
          width="500"
          height="500"
        ></feImage>
        <feDisplacementMap
          scale="20"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict7"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image7">
        <feImage
          result="pict13"
          xlink:href="/images/displacement/13.jpg"
          x="0"
          y="0"
          width="603"
          height="582"
        ></feImage>
        <feDisplacementMap
          scale="30"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict13"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
    <defs>
      <filter id="image8">
        <feImage
          result="pict7"
          xlink:href="/images/displacement/16.jpg"
          x="0"
          y="0"
          width="510"
          height="502"
        ></feImage>
        <feDisplacementMap
          scale="30"
          xChannelSelector="R"
          yChannelSelector="R"
          in2="pict7"
          in="SourceGraphic"
        ></feDisplacementMap>
      </filter>
    </defs>
  </svg>
</template>
<style scoped lang="scss">
.app-content {
  width: 100vw;
  display: grid;
  grid-template-columns: repeat(auto-fit, 40vmax);
  justify-content: center;
  background-color: white;
}

.item {
  position: relative;
  clip-path: inset(2rem);
}

.item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  position: relative;
  z-index: 1;
}

.item .glass {
  transition: 0.5s;
  width: 50%;
  height: 50%;
  position: absolute;
  top: 25%;
  left: 25%;
  z-index: 2;
  overflow: hidden;
  box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
  //   玻璃模糊度和蒙层效果
  // backdrop-filter: blur(2px) url(#image1);
}
.item:nth-child(1) .glass {
  //   玻璃模糊度和蒙层效果
  -webkit-backdrop-filter: blur(2px) url(#image1);
  backdrop-filter: blur(2px) url(#image1);
}
.item:nth-child(2) .glass {
  //   玻璃模糊度和蒙层效果
  backdrop-filter: blur(2px) url(#image2);
}
.item:nth-child(3) .glass {
  //   玻璃模糊度和蒙层效果
  backdrop-filter: blur(2px) url(#image3);
}
.item:nth-child(4) .glass {
  //   玻璃模糊度和蒙层效果
  backdrop-filter: blur(2px) url(#image4);
}
.item:nth-child(5) .glass {
  backdrop-filter: blur(2px) url(#image5);
}
.item:nth-child(6) .glass {
  backdrop-filter: blur(2px) url(#image6);
}
.item:nth-child(7) .glass {
  backdrop-filter: blur(2px) url(#image7);
}
.item:nth-child(8) .glass {
  backdrop-filter: blur(2px) url(#image8);
}
</style>
