<script>
export default {
  // hidden: true
}
</script>
<template>
  <div class="app-center">
    <div>
      <ul class="navigation">
        <li v-for="item in list" :key="item" class="nav-item">{{ item }}</li>
      </ul>
      <div id="bounded-flick" class="flicker container margin">
        <ul class="carousel">
          <li v-for="item in list" :key="item" class="draggable carousel-item">{{ item }}</li>
        </ul>
      </div>
      <div class="controls">
        <button @click="prevSlide" class="control-button">Prev</button>
        <button @click="nextSlide" class="control-button">Next</button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { reactive, onMounted, toRefs } from 'vue'
import { animate, createDraggable, utils } from 'animejs'
const state = reactive({
  boundedFlicker: null,
  boundedFlickWidth: 280 + 10, //定义每个轮播项的宽度（280px内容 + 10px间距）
  boundedFlickLength: 0,
  list: [1, 2, 3, 4, 5],
  activeIndex: 0
})
const { list } = toRefs(state)
onMounted(() => {
  // 获取轮播项的数量（计算轮播内容的总宽度需要）
  state.boundedFlickLength = utils.$('#bounded-flick .carousel-item').length

  // 创建可拖拽的轮播容器
  state.boundedFlicker = createDraggable('#bounded-flick .carousel', {
    // Array<Number> ([top, right, bottom, left]) 设置X轴可拖动范围
    container: [0, 0, 0, -state.boundedFlickWidth * (state.boundedFlickLength - 1)],
    y: false, // 禁止垂直拖动
    /**
     * 将两个轴或一个特定轴的最终值四舍五入到最接近的指定增量。
     * 如果提供一个 Array 作为增量，它将从数组中选择最接近的值
     */
    snap: state.boundedFlickWidth, // 拖动时以290px为单位吸附（实现分页效果）
    // 更新时
    onUpdate: (e) => {
      // 获取当前位置小标
      // console.log(e.x)
    }
  })

  // 设置轮播容器的总宽度（所有轮播项宽度之和）
  utils.set('#bounded-flick .carousel', {
    width: `${state.boundedFlickLength * state.boundedFlickWidth}`
  })
})
// 导航控制函数
const slide = (offset) => {
  const { containerBounds } = state.boundedFlicker
  const v = state.boundedFlicker.x - offset
  let x = utils.snap(v, state.boundedFlickWidth)
  if (x > containerBounds[1]) x = containerBounds[1]
  if (x < containerBounds[3]) x = containerBounds[3]
  animate(state.boundedFlicker, {
    x: x,
    duration: 500,
    ease: 'out(4)',
    onComplete: (self) => {
      getActiveIndex(x)
    }
  })
}
// 获取当前位置下标
const getActiveIndex = (x) => {
  const index = utils.round(x / -state.boundedFlickWidth, 0)
  state.activeIndex = index
  console.log(index)
  utils.$('.navigation .nav-item').forEach((item, i) => {
    if (index === i) {
      item.classList.add('active')
    } else {
      item.classList.remove('active')
    }
  })
  const activeItem = utils.$('.navigation .nav-item.active')
  animate(activeItem, {
    color: '#409eff',
    duration: 500,
    scale: 1.5,
    ease: 'out(4)'
  })
}
const prevSlide = () => {
  slide(-state.boundedFlickWidth)
}
const nextSlide = () => {
  slide(state.boundedFlickWidth)
}
</script>
<style scoped>
.app-center {
  height: 100vh;
  display: grid;
  place-content: center;
  overflow: hidden;
}
ul {
  padding: 0;
  margin: 0;
  list-style: none;
  display: flex;
}
#bounded-flick {
  --bounded-flick-width: 280px;
  --yellow: rgb(238, 185, 78);
}
.container {
  width: var(--bounded-flick-width);
  height: var(--bounded-flick-width);
  border-radius: 10px;
  overflow: hidden;
  position: relative;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}
.margin {
  border-radius: 20px;
  padding: 10px;
}
#bounded-flick .carousel-item {
  width: var(--bounded-flick-width);
  height: var(--bounded-flick-width);
  background-color: rgb(239, 85, 85);
  border-radius: 10px;
  margin-right: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-size: 2rem;
  font-weight: bold;
}
.carousel-item:nth-child(2n) {
  background-color: var(--yellow) !important;
}
.carousel-item:last-child {
  margin-right: 0;
}
.controls {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}
.navigation {
  display: flex;
  align-items: center;
  justify-content: space-around;
  margin-bottom: 20px;
}
.nav-item {
  font-weight: bold;
}
</style>
