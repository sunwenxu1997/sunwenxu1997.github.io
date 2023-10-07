<script setup>
// 仿苹果浏览器窗口
import { ref, reactive, onMounted } from 'vue'
let appleWindow, appleWindowContent
const w = ref(600) //默认宽度
const h = ref(0)
onMounted(() => {
  appleWindow = document.querySelector('#apple-window')
  appleWindowContent = document.querySelector('#apple-window-content')
  h.value = appleWindow.offsetHeight
  draggable(document.querySelector('#apple-window-drag'))
})
const draggable = (el) => {
  el.onmousedown = (e) => {
    appleWindowContent.style.pointerEvents = 'none'
    const disX = e.clientX - el.offsetLeft
    document.onmousemove = (e) => {
      const left = e.clientX - disX
      appleWindow.style.width = left + 'px'
      w.value = appleWindow.offsetWidth
    }
    document.onmouseup = () => {
      document.onmousemove = null
      document.onmouseup = null
      appleWindowContent.style.pointerEvents = 'auto'
    }
  }
}
</script>
<template>
  <div class="h-auto max-w-[80vw]">
    <p class="t text-xs text-zinc-600 text-center my-3">{{ w }} * {{ h }} px</p>
    <div
      id="apple-window"
      class="relative shadow-md rounded-xl min-w-[350px] max-w-full"
      :style="`width: ${w}px;`"
    >
      <div
        title="改变窗口"
        id="apple-window-drag"
        class="absolute z-10 top-1/2 -translate-y-4 -right-6 p-2 pointer-events-auto cursor-ew-resize select-none"
      >
        <div class="w-1.5 h-8 bg-slate-500/60 rounded-full"></div>
      </div>
      <div class="rounded-xl ring-1 ring-slate-900/5">
        <div
          class="rounded-t-xl bg-gradient-to-b from-white to-[#FBFBFB] dark:bg-none dark:bg-slate-700 dark:highlight-white/10"
        >
          <div
            class="py-2.5 grid items-center px-4 gap-6"
            style="grid-template-columns: 2.625rem 1fr 2.625rem"
          >
            <div class="flex items-center">
              <div class="w-2.5 h-2.5 rounded-full bg-[#EC6A5F]"></div>
              <div class="ml-1.5 w-2.5 h-2.5 rounded-full bg-[#F4BF50]"></div>
              <div class="ml-1.5 w-2.5 h-2.5 rounded-full bg-[#61C454]"></div>
            </div>
            <div>
              <div
                class="bg-slate-100 rounded-md font-medium text-xs leading-6 py-1 flex items-center justify-center ring-1 ring-inset ring-slate-900/5 mx-auto w-4/5 dark:bg-slate-800 dark:text-slate-500"
              >
                <svg
                  viewBox="0 0 20 20"
                  fill="currentColor"
                  class="text-slate-300 w-3.5 h-3.5 mr-1.5 dark:text-slate-500"
                >
                  <path
                    fill-rule="evenodd"
                    d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                    clip-rule="evenodd"
                  ></path>
                </svg>
                sunwenxu1997.github.io
              </div>
            </div>
          </div>
        </div>
        <div
          id="apple-window-content"
          style="height: 351px"
          class="relative bg-white border-t border-slate-200 rounded-b-xl dark:bg-slate-800 dark:border-slate-900/50 h-full max-h-[80vh] overflow-y-auto"
        >
          <slot></slot>
        </div>
      </div>
    </div>
  </div>
</template>
<style scoped>
#apple-window-content::-webkit-scrollbar {
  width: 4px;
  height: 4px;
  background-color: #eaeaea;
}
#apple-window-content::-webkit-scrollbar-thumb {
  background: #646464;
}
</style>
