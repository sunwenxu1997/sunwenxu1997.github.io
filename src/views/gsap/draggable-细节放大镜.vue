<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { Draggable } from 'gsap/Draggable.js'
const imgUrl = ref('https://picsum.photos/id/819/3000/3000')
let bigDraggable, // 背景大图的拖动对象
  markerDraggable, // 小窗口的拖动对象
  bigImageContainer, // 背景大图的容器
  bigImage, //背景大图
  smallImage, //小窗口
  marker, // 小窗口的拖动框
  bigX, // 背景大图的x轴位置
  bigY, // 背景大图的y轴位置
  markerX, // 小图查看块的x轴位置
  markerY, // 小图查看块的y轴位置
  imageScale // 小窗口拖动块与背景大图的比例，保证拖动小窗口块时和背景大图位置信息保持一致

onMounted(() => {
  gsap.registerPlugin(Draggable) // 注册可拖拽插件
  bigImageContainer = document.querySelector('.big-image-container')
  bigImage = document.querySelector('.big-image')
  smallImage = document.querySelector('.mini-map')
  marker = document.querySelector('.marker')
  bigX = gsap.quickSetter(bigImage, 'x', 'px')
  bigY = gsap.quickSetter(bigImage, 'y', 'px')
  markerX = gsap.quickSetter(marker, 'x', 'px')
  markerY = gsap.quickSetter(marker, 'y', 'px')
  //   模拟异步请求获取图片宽度
  setTimeout(() => {
    console.log(bigImage.offsetWidth)
    setupSizing()
    init()
  }, 1000)
  window.addEventListener('resize', setupSizing)
})
onUnmounted(() => {
  window.removeEventListener('resize', setupSizing)
  bigDraggable.kill()
  markerDraggable.kill()
})
// 初始化拖拽，建议等待图片加载完成后执行
function init() {
  // 创建背景大图可拖拽对象
  bigDraggable = Draggable.create(bigImage, {
    bounds: bigImageContainer,
    inertia: true, //绿🧦会员福利才会有效果，相当于一个惯性效果
    onDrag: alignSmall,
    onThrowUpdate: alignSmall
  })[0]

  //   创建小窗口可拖拽对象
  markerDraggable = Draggable.create(marker, {
    bounds: smallImage,
    onDrag: alignBig,
    onThrowUpdate: alignBig,
    inertia: true
  })[0]
  //   设置背景大图的初始位置，这里设置为中心位置
  gsap.set(bigImage, {
    x: (bigDraggable.minX + bigDraggable.maxX) / 2,
    y: (bigDraggable.minY + bigDraggable.maxY) / 2
  })
  bigDraggable.update()
  alignSmall()
}
// 同步背景大图位置的方法
function alignBig() {
  // markerDraggable.x 小窗口拖拽块的x轴位置
  bigX(-markerDraggable.x / imageScale)
  bigY(-markerDraggable.y / imageScale)
}

function alignSmall() {
  markerX(-bigDraggable.x * imageScale)
  markerY(-bigDraggable.y * imageScale)
}

function setupSizing() {
  // 图片转换比例
  imageScale = smallImage.offsetWidth / bigImage.offsetWidth
  let screenToBigRatio = bigImageContainer.offsetWidth / bigImage.offsetWidth
  console.log(screenToBigRatio * smallImage.offsetWidth)
  gsap.set(marker, {
    width: screenToBigRatio * smallImage.offsetWidth,
    height: screenToBigRatio * smallImage.offsetWidth
  })
}
</script>
<template>
  <div class="app-content-center">
    <div class="container">
      <!-- 小窗口 -->
      <div class="mini-map">
        <img :src="imgUrl" alt="" />
        <div class="marker"></div>
      </div>
      <!-- 放大的视图 -->
      <div class="big-image-container">
        <img class="big-image" :src="imgUrl" alt="" />
      </div>
    </div>
  </div>
</template>
<style lang="scss" scoped>
$w: 600px;
$h: 600px;
.container {
  display: grid;
  grid-gap: 40px;
  grid-template-columns: 1fr 1fr;
  background-color: white;
  padding: 40px;
  img {
    display: block;
  }
}
.big-image-container {
  width: $w;
  height: $h;
  overflow: hidden;
  position: relative;
  .big-image {
    display: block;
    position: relative;
    // 可以选择默认给一个宽，否则图片未加载完成无法获取到宽度，会造成 imageScale 获取不到值
    // 这个宽尽量是需要放大图片的原始宽度
    // width: 4000px;
  }
}
.mini-map {
  width: $w;
  height: $h;
  position: relative;
  img {
    width: 100%;
    height: 100%;
    pointer-events: none;
  }
}
// 查看器
.marker {
  border: 2px solid #fff;
  background-color: #fff;
  opacity: 0.4;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 1;
}
</style>
