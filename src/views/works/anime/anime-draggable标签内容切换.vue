<script>
export default {
  hidden: true
}
</script>
<template>
  <div class="app-center">
    <div>
      <ul class="navigation">
        <li v-for="(item, index) in list" :key="item" class="nav-item" @click="clickNavItem(index)">
          {{ item }}
        </li>
        <div class="plan"></div>
      </ul>
      <div id="bounded-flick" class="flicker container margin">
        <ul class="carousel">
          <li v-for="item in list" :key="item" class="draggable carousel-item">{{ item }}</li>
        </ul>
      </div>
      <div class="controls">
        <button @click="slideTo(activeIndex - 1)" class="control-button">Prev</button>
        <button @click="slideTo(activeIndex + 1)" class="control-button">Next</button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { reactive, onMounted, toRefs, ref, watch } from 'vue'
import { animate, createDraggable, createTimeline, utils } from 'animejs'
const state = reactive({
  boundedFlicker: null,
  boundedFlickWidth: 280 + 10, //定义每个轮播项的宽度（280px内容 + 10px间距）
  list: [1, 2, 3, 4, 5],
  activeIndex: 2,
  planAnimation: null
})
const { list, activeIndex } = toRefs(state)
watch(
  () => state.activeIndex,
  (newVal) => {
    console.log(newVal)
  }
)
onMounted(() => {
  // 创建进度条动画
  /**
   * animate() 方法不解析从 CSS 样式声明中声明的转换，并且转换属性必须直接在元素的内联样式中设置。您可以使用内置的
   * utils.set()
   * 函数来独立设置您的转换值，然后再动画化元素，并定义它们必须设置的顺序。
   */
  utils.set('.plan', { width: 0, transformOrigin: 'left' })
  state.planAnimation = animate('.plan', {
    autoplay: false,
    width: '100%',
    ease: 'linear' //如果想要等比动画，这里一定要设置匀速！！！！
  })
  // 创建可拖拽的轮播容器
  state.boundedFlicker = createDraggable('#bounded-flick .carousel', {
    // Array<Number> ([top, right, bottom, left]) 设置X轴可拖动范围
    container: [0, 0, 0, -state.boundedFlickWidth * (state.list.length - 1)],
    y: false, // 禁止垂直拖动
    /**
     * 将两个轴或一个特定轴的最终值四舍五入到最接近的指定增量。
     * 如果提供一个 Array 作为增量，它将从数组中选择最接近的值
     */
    snap: state.boundedFlickWidth, // 拖动时以290px为单位吸附（实现分页效果）
    // 更新时
    onUpdate: (e) => {
      // 获取当前位置下标
      getActiveIndex(e.x)
    }
  })

  // 设置轮播容器的总宽度（所有轮播项宽度之和）
  utils.set('#bounded-flick .carousel', {
    width: `${state.list.length * state.boundedFlickWidth}`
  })

  // 初始化下标位置
  clickNavItem(state.activeIndex, true)
})
// 获取当前位置下标
const getActiveIndex = (x) => {
  const index = utils.round(x / -state.boundedFlickWidth, 0)
  state.activeIndex = index
  updateActiveIndexClass({ index, x })
}
// 导航控制函数
const slideTo = (targetIndex) => {
  const clampedIndex = Math.max(0, Math.min(targetIndex, state.list.length - 1))
  let x = utils.snap(-clampedIndex * state.boundedFlickWidth, state.boundedFlickWidth)
  animate(state.boundedFlicker, {
    x: x,
    duration: 500,
    ease: 'out(4)'
  })
}
// 导航点击事件
const clickNavItem = (index, isInit = false) => {
  // 根据坐标计算当前位置下标
  animate(state.boundedFlicker, {
    x: -index * state.boundedFlickWidth,
    duration: isInit ? 0 : 500,
    ease: 'out(4)'
  })
}
// 根据当前下标移除并添加样式
const updateActiveIndexClass = ({ index, x }) => {
  // 控制导航栏的文字效果动画
  utils.$('.nav-item').forEach((el, i) => {
    if (index === i) {
      animate(el, {
        color: '#fff',
        background: 'var(--color)',
        duration: 500,
        ease: 'out(4)'
      })
    } else {
      animate(el, {
        y: 0,
        color: '#000',
        background: 'none',
        duration: 500,
        ease: 'out(4)'
      })
    }
  })

  // 根据当前拖拽距离同步进度条动画的播放时间，默认动画时间为1000ms
  state.planAnimation.seek((x / (-state.boundedFlickWidth * state.list.length)) * 1000 + 1000 / state.list.length)
}
</script>
<style scoped>
.app-center {
  height: 100vh;
  display: grid;
  place-content: center;
  overflow: hidden;
  --bounded-flick-width: 280px;
  --color: #987eec;
  --color1: #b09def;
}
ul {
  padding: 0;
  margin: 0;
  list-style: none;
  display: flex;
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
  background-color: var(--color);
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
  background-color: var(--color1) !important;
}
.carousel-item:last-child {
  margin-right: 0;
}
.controls {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}
.control-button {
  border-radius: 20px;
  padding: 10px 20px;
  background-color: var(--color1);
  border: none;
  color: white;
  font-weight: bold;
  cursor: pointer;
}
.control-button:nth-child(2n) {
  background-color: var(--color);
}
.control-button:active {
  opacity: 0.8;
}
.navigation {
  display: flex;
  align-items: center;
  justify-content: space-around;
  margin-bottom: 20px;
  position: relative;
}
.nav-item {
  padding: 10px 0;
  flex: 1;
  font-weight: bold;
  cursor: pointer;
  user-select: none;
  color: #373737;
  text-align: center;
  border-radius: 20px;
}
.plan {
  position: absolute;
  height: 100%;
  background: var(--color1);
  z-index: -1;
  border-radius: 20px;
  left: 0;
}
</style>
