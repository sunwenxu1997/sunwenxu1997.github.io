<script setup>
// 悬浮跟随鼠标的搜索按钮
import { ref, reactive, onMounted, onUnmounted, defineProps } from 'vue'
import { gsap } from 'gsap'
import { isMobileDevice } from '@/utils/index.js'
const props = defineProps({
  searchIconShow: { Boolean, default: true }
})
const $emit = defineEmits(['input', 'search'])
const searchBtnRef = ref(null),
  searchInputShow = ref(false),
  searchInputRef = ref(null),
  searchInputValue = ref('')
let mouseDownTimeout = null
onMounted(() => {
  document.body.style.cursor = 'none'
  //   非移动端才执行自定义的鼠标样式
  if (!isMobileDevice()) {
    window.addEventListener('mousemove', mousemoveSearchBtnListener)
    window.addEventListener('mousedown', mousedownSearchBtnListener)
    window.addEventListener('mouseup', function () {
      clearTimeout(mouseDownTimeout)
    })
    window.addEventListener('keydown', keydownSearchBtnListener)
  }
})
onUnmounted(() => {
  document.body.style.cursor = 'auto'
  window.removeEventListener('mousemove', mousemoveSearchBtnListener)
  window.removeEventListener('mousedown', mousedownSearchBtnListener)
  window.removeEventListener('keydown', keydownSearchBtnListener)
})
const keydownSearchBtnListener = (e) => {
  if (e.key === 'Enter') {
    // 在这里执行回车键按下后的操作
    console.log('回车键被按下')
    if (!searchInputValue.value) searchInputShow.value = false
    $emit('input', searchInputValue.value)
    searchInputRef.value.blur()
  }
  if (e.key === 'Escape') {
    // 在这里执行 Esc 键按下后的操作
    console.log('Esc 键被按下')
    searchInputShow.value = false
    $emit('input', searchInputValue.value)
    searchInputRef.value.blur()
  }
}
const mousedownSearchBtnListener = () => {
  mouseDownTimeout = setTimeout(function () {
    // 在这里执行按下 500ms 秒钟后的操作
    console.log('鼠标按下 500ms 秒钟')
    searchInputShow.value = true
    searchInputRef.value.focus()
  }, 500)
}
const mousemoveSearchBtnListener = (e) => {
  if (!searchInputValue.value) searchInputShow.value = false
  let el = searchBtnRef.value
  //圆灯相对于 容器的坐标位置
  let x = e.clientX - el.getBoundingClientRect().width / 2
  let y = e.clientY - el.getBoundingClientRect().height / 2
  gsap.to(el, {
    left: x,
    top: y,
    opacity: 0.8,
    ease: 'back(0.1)',
    duration: 0.3
  })
}
</script>
<template>
  <!-- 非移动端设备时，都采用自定义的悬浮搜索按钮 -->
  <div
    ref="searchBtnRef"
    v-if="!isMobileDevice()"
    class="flex fixed opacity-0 transition top-0 left-0 z-50 pointer-events-none min-w-[2.5rem] min-h-[2.5rem] rounded-full justify-center items-center"
    :class="[
      searchInputShow && props.searchIconShow ? 'px-2' : 'px-0',
      props.searchIconShow ? ' bg-slate-100' : ' bg-red-600 scale-75 mix-blend-difference'
    ]"
  >
    <svg
      v-if="props.searchIconShow"
      fill="#000000"
      class="icon"
      viewBox="0 0 24 24"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M16.9994165,16.2923098 L20.8535534,20.1464466 C21.0488155,20.3417088 21.0488155,20.6582912 20.8535534,20.8535534 C20.6582912,21.0488155 20.3417088,21.0488155 20.1464466,20.8535534 L16.2923098,16.9994165 C14.8819612,18.2444908 13.0292099,19 11,19 C6.581722,19 3,15.418278 3,11 C3,6.581722 6.581722,3 11,3 C15.418278,3 19,6.581722 19,11 C19,13.0292099 18.2444908,14.8819612 16.9994165,16.2923098 Z M11,18 C14.8659932,18 18,14.8659932 18,11 C18,7.13400675 14.8659932,4 11,4 C7.13400675,4 4,7.13400675 4,11 C4,14.8659932 7.13400675,18 11,18 Z"
      />
    </svg>
    <input
      v-if="props.searchIconShow"
      ref="searchInputRef"
      class="select-none outline-none border-0 transition-all bg-transparent"
      :class="searchInputShow ? 'w-20 px-2' : 'w-0 p-0'"
      type="text"
      v-model="searchInputValue"
      @input="$emit('input', searchInputValue)"
    />
    <div v-show="!props.searchIconShow" class="w-1 h-1 rounded-full bg-black"></div>
  </div>
</template>
<style lang="scss" scoped></style>
