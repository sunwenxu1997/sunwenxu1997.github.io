<script>
export default {
  cover:'https://iili.io/J7b3Ext.gif',
  link:'https://codepen.io/sunwenxu1997/pen/eYXzqpG',
  date:'2024-01-11',
  info:`通过多张图片的方式模拟视频动画，通过滚动条平滑过渡，控制图片播放。相比于直接控制视频进度动画可能会好一点。
  实现原理：
  主要是通过 <code>gsap + scrollTrigger</code> 来实现的，通过控制 playhead 对象参数的 frame(图片index) 从0到最后一张图片的过程来实现图片的播放动画。
  `,
}
</script>
<script setup>
import { onMounted } from 'vue'
// 引入gsap和scrollTrigger
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
onMounted(() => {
  // 注册scrollTrigger
  gsap.registerPlugin(ScrollTrigger)
  // 定义图片数量，一共有147张图片
  const frameCount = 147
  const urls = new Array(frameCount)
    .fill()
    .map(
      (o, i) =>
        `https://www.apple.com/105/media/us/airpods-pro/2019/1299e2f5_9206_4470_b28e_08307a42f19b/anim/sequence/large/01-hero-lightpass/${(
          i + 1
        )
          .toString()
          .padStart(4, '0')}.jpg`
    )

  // 这里先尝试执行一边动画，然后再通过滚动条控制
  // 当然你也可以忽略，直接通过滚动条来控制
  imageSequence({
    urls,
    canvas: '#canvas',
    paused: false,
    onStart: () => {
      console.log('start')
      document.querySelector('.app-content').style.height = '100vh'
    },
    onComplete: () => {
      console.log('complete')
      document.querySelector('.app-content').style.height = '300vh'
      imageSequence({
        urls,
        canvas: '#canvas',
        scrollTrigger: {
          markers: false,
          scrub: true // 必要参数，滚动条平滑过渡
        }
      })
    }
  })
})
// 将图片按照循序绘制到canvas标签中
function imageSequence(config) {
  //  获取canvas标签
  let canvas = gsap.utils.toArray(config.canvas)[0] || console.warn('canvas not defined')
  let ctx = canvas.getContext('2d')

  // 加载所有图片
  let images = config.urls.map((url, i) => {
    let img = new Image()
    img.src = url
    // 默认执行updateImage加载第一张图片
    i || (img.onload = updateImage)
    return img
  })

  // 从头播放时的对象参数
  // frame 为0时表示第一张图片
  let playhead = { frame: 0 }
  let curFrame = -1

  // 更新图片，绘制到canvas标签中
  function updateImage() {
    let frame = Math.round(playhead.frame)
    if (frame !== curFrame) {
      // 只在必要时绘制
      config.clear && ctx.clearRect(0, 0, canvas.width, canvas.height)
      ctx.drawImage(images[Math.round(playhead.frame)], 0, 0, canvas.width, canvas.height)
      curFrame = frame
      // 回传onUpdate方法事件
      config.onUpdate && config.onUpdate.call(this, frame, images[frame])
    }
  }
  let gsapProperty = {
    frame: images.length - 1, // 最后一张图片下标
    ease: 'none', // 动画效果
    onStart: config.onStart, // 动画开始时的回调
    onUpdate: updateImage, // 更新图片
    onComplete: config.onComplete, // 动画完成后的回调
    duration: images.length / (config.fps || 30), // 持续时间
    paused: !!config.paused // 是否暂停
    // scrollTrigger: config.scrollTrigger // 通过滚动条平滑过渡，控制图片播放}
  }
  if (config.scrollTrigger) gsapProperty.scrollTrigger = config.scrollTrigger
  // 返回一个gsap动画对象
  return gsap.to(playhead, gsapProperty)
}
</script>
<template>
  <div class="app-content">
    <canvas id="canvas" width="1158" height="770"></canvas>
  </div>
</template>
<style lang="scss" scoped>
.app-content {
  height: 300vh;
  background-color: #000;
}
#canvas {
  position: fixed;
  // 居中对齐
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%) scale(0.3);
}
</style>
