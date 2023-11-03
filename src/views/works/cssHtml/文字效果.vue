<script>
export default {
  cover: 'https://iili.io/JqJOqRS.png',
  link: 'https://juejin.cn/post/7165675529763454983',
  info: ` 
    <p>🌈属于文字效果，里面有各种样式类型的文本，当然不仅仅可以应用于文字上，你也可以应用在其他地方。首先你要先学会他，不是吗？</p>
    <p>知识点：</p>
    <p>1. <code>background-clip: text;</code> 背景文本裁切</p>
    <p>2. <code>mask</code> 遮罩层 </p>
    <p>3. <code>svg，fliter</code>等效果应用 </p>
    `
}
</script>
<template>
  <div class="text-box">
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <h1>Hello World</h1>
    <svg width="100%" height="100%">
      <mask id="mask">
        <filter
          id="filter"
          filterUnits="objectBoundingBox"
          x="0%"
          y="0%"
          width="100%"
          height="100%"
        >
          <feTurbulence type="fractalNoise" baseFrequency="0.1" numOctaves="5"></feTurbulence>
          <feDisplacementMap
            id="feDisplacementMap"
            in="SourceGraphic"
            scale="100"
            xChannelSelector="R"
            yChannelSelector="G"
          >
            <animate
              attributeName="scale"
              dur="5s"
              values="100;10000;100;"
              repeatCount="indefinite"
            />
          </feDisplacementMap>
        </filter>
        <rect width="1000" height="1000" fill="white" filter="url(#filter)"></rect>
      </mask>
      <text class="mask-text" mask="url(#mask)" x="50" y="125">Hello World</text>
    </svg>
  </div>
</template>
<style scoped>
.text-box {
  display: grid;
  grid-template-columns: repeat(auto-fill, 25rem);
  justify-content: center;
}

h1,
.mask-text {
  font-size: 3rem;
  font-weight: bold;
  white-space: nowrap;
  text-align: center;
  padding: 5rem 0;
  /* box-shadow: 0 0 3px #ccc; */
}

h1:nth-child(1) {
  /* 文字反射倒影 */
  /* -webkit-box-reflect: below -0.55em linear-gradient(transparent 0%, rgba(255, 255, 255, 0.6) 100%); */
}

h1:nth-child(2) {
  /* 文字描边 width color */
  -webkit-text-stroke: 0.05rem black;
  color: transparent;
  text-shadow:
    -5px 0 rgba(0, 255, 255, 0.4),
    5px 0 rgba(255, 0, 255, 0.4);
}

h1:nth-child(3) {
  text-decoration: line-through;
}

h1:nth-child(4) {
  color: #f4f4f4;
  text-shadow:
    -1px -1px white,
    1px 1px gray,
    2px 2px #7a7a7a,
    3px 3px #757575,
    4px 4px #707070,
    5px 5px #6b6b6b,
    6px 6px #666666,
    7px 7px #616161,
    8px 8px #5c5c5c,
    9px 9px #575757;
}

h1:nth-child(5) {
  color: transparent;
  background-image: linear-gradient(transparent 0%, transparent 50%, #447df7 50%, #447df7 100%);
  -webkit-background-clip: text;
  -webkit-text-stroke: 0.05rem #447df7;
}

h1:nth-child(6) {
  color: transparent;
  text-shadow: 0 0 5px black;
}

h1:nth-child(7) {
  /* 文字间距 */
  letter-spacing: 0.3rem;
  text-shadow:
    1px 1px 0px white,
    3px 3px 0px black;
}
h1:nth-child(8) {
  mask: radial-gradient(circle at 50% 50%, white, transparent 50%, transparent);
  mask-size: 2px 2px;
}
h1:nth-child(9) {
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  color: transparent;
  background-position: center;
  background-size: 400% 400%;
  background-clip: text;
  animation: gradientBG 15s ease infinite;
}
@keyframes gradientBG {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}
h1:nth-child(10) {
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  color: transparent;
  background-position: center;
  background-size: 400% 400%;
  background-clip: text;
  animation: gradientBG 15s ease infinite;
}
</style>
