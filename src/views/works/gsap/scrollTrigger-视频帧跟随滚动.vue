<template>
  <div class="app-content">
    <video id="video">
      <!-- <source
        src="https://res.cloudinary.com/mkpill/video/upload/v1691752608/launch_pill_795f2be8d2.mp4"
        type='video/mp4'
      /> -->
      <source
        type="video/webm"
        src="https://res.cloudinary.com/mkpill/video/upload/v1691752608/launch_pill_6ae3865c71.webm"
      />
    </video>
  </div>
</template>

<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
export default {
  link: 'https://juejin.cn/post/7162001311225888782',
  mounted() {
    gsap.registerPlugin(ScrollTrigger)
    function videoGurrentTime(elem, progress, direction) {
      let videoEl = document.querySelector(elem)
      let videoTime = 6 //引入视频的时间，此完整视频全长为3s
      videoEl.currentTime = progress * videoTime
    }
    ScrollTrigger.create({
      trigger: '#video',
      //   markers: true,
      pin: true, //钉住目标至窗口运动轨迹位置
      start: 'center center',
      end: '+=5000',
      onUpdate: (self) => {
        videoGurrentTime('#video', self.progress.toFixed(3), self.direction)
        // console.log(
        //   '进度:',
        //   self.progress.toFixed(3),
        //   '朝向:',
        //   self.direction,
        //   '滚动速度',
        //   self.getVelocity()
        // )
      }
    })
  }
}
</script>

<style lang="scss" scoped>
#video {
  width: 300px;
  display: block;
  margin: 0 auto;
}
</style>
