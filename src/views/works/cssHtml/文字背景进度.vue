<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
export default {
  date: '2023-12-26',
  cover:'https://iili.io/JRauCrl.gif',
  link: 'http://manifesto.clapat.com/',
  info: `今天又是忙碌的一天，今天周二还有生产发布，但是发现这个有意思得效果还是要学习下的！😄
    知识点：
    1. <code>-webkit-text-fill-color</code>设置文本的填充颜色，这里建议设置透明度低得，否则颜色过渡上会有冲突
    2. <code>-webkit-background-clip: text</code>用于将背景应用到文本内容内部，创建文本填充效果 
    3. <code>background-size: 0% 100%;</code>文字进度完成度 x轴控制水平进度，y轴控制垂直进度
    `,
  mounted() {
    gsap.registerPlugin(ScrollTrigger)
    gsap.utils.toArray('.text-plan').forEach((elem) => {
      gsap.to(elem, {
        backgroundSize: '100% 100%',
        scrollTrigger: {
          trigger: elem, //容器
          start: 'top center',
          end: 'bottom center',
        //   markers: true,
          scrub: 2 //将动画的进度直接链接到滚动条，这样它就像一个洗涤器
          // 垂直滚动是基于容器的宽度，这样感觉更自然.
        }
      })
    })
  },
  unmounted() {
    ScrollTrigger.killAll()
  }
}
</script>
<template>
  <div class="app-content">
    <div class="text-box">
      <span class="text-plan"
        >Stand out from the crowd and make a statement with our sleek and stylish portfolio template
        that speaks volumes about your creativity.</span
      >
    </div>
    <div class="text-box">
      <span class="text-plan"
        >Stand out from the crowd and make a statement with our sleek and stylish portfolio template
        that speaks volumes about your creativity.</span
      >
    </div>
    <div class="text-box">
      <span class="text-plan"
        >Stand out from the crowd and make a statement with our sleek and stylish portfolio template
        that speaks volumes about your creativity.</span
      >
    </div>
  </div>
</template>
<style lang="scss" scoped>
.text-box {
  width: clamp(300px, 40vmax, 400px);
  margin: 50vh auto;
}
.text-plan {
  font-size: 2rem;
  font-weight: bold;
  display: inline; //必须是行标签
  -webkit-text-fill-color: rgba(0, 0, 0, 0.1);
  -webkit-background-clip: text; //背景裁剪，背景颜色用于文字之上
  background-repeat: no-repeat; //背景不重复
  background-image: linear-gradient(#000, #000); //背景颜色，相当于文字进度完成颜色
  background-size: 0% 100%; // 文字进度完成度 x轴控制水平进度，y轴控制垂直进度
}

.text-box:nth-child(2) .text-plan {
  background-size: 100% 0%;
}

.text-box:nth-child(3) .text-plan {
  background-image: linear-gradient(to right,rgb(26, 222, 12), rgb(23, 212, 222)); //背景颜色，相当于文字进度完成颜色
}
</style>
