<script setup>
import IconRefresh from './icons/IconRefresh.vue'
import IconSearch from './icons/IconSearch.vue'
import 'element-plus/es/components/message/style/css'
import { ElMessage } from 'element-plus'
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAppStore } from '../stores/index'
const navs = [
  {
    name: '作品',
    path: '/works'
  },
//   {
//     name: '关于',
//     path: '/about'
//   }
]
const $router = useRouter()
const $route = useRoute()
const store = useAppStore()
// 当前页面是首页
const isHome = computed(() => {
  return $route.path === '/'
})
onMounted(() => {})
const toPath = (path) => {
  $router.push(path)
}
const toTop = ()=>{
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    })
}
</script>
<template>
  <!-- 默认只会在对应导航和首页显示 -->
  <div
    v-if="[...navs.map((item) => item.path), '/'].includes($route.path)"
    class="absolute z-20 w-full left-0 top-0 p-5 box-border text-base flex justify-between items-center px-12 sm:px-24 py-10"
  >
    <div
      class="fixed text-lg flex items-center font-bold"
      style="font-family: 'Rajdhani', sans-serif"
    >
      <span
        class="cursor-pointer sm:text-black"
        :class="isHome ? 'text-white' : 'text-black'"
        @click="toPath('/')"
        >WHO.</span
      >
      <span
        v-if="!isHome"
        @click="toTop()"
        class="mx-4 px-4 tracking-widest font-normal text-sm relative cursor-pointer hover:underline before:content-[''] before:absolute before:w-1 before:h-3/4 before:bg-stone-700 before:top-[2px] before:left-0"
        >{{ $route.meta.title }}</span
      >
    </div>
    <div
      class="relative cursor-pointer w-7 h-3 before:content-[''] before:absolute before:top-0 before:w-full before:h-[2px] after:content-[''] after:absolute after:bottom-0 after:w-full after:h-[2px] sm:after:bg-black sm:before:bg-black sm:hidden"
      :class="isHome ? 'before:bg-white after:bg-white' : 'before:bg-black after:bg-black'"
    ></div>
    <div class="w-full px-10 justify-center hidden sm:flex">
      <div class="flex group">
        <div
          class="uppercase p-5 text-xs font-bold text-stone-800 cursor-pointer group-hover:opacity-50 hover:!opacity-100"
          :class="{ '!opacity-100': $route.path === item.path, 'opacity-50': !isHome }"
          v-for="(item, index) in navs"
          :key="index"
          @click="toPath(item.path)"
        >
          {{ item.name }}
        </div>
      </div>
    </div>
  </div>
</template>
<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');
</style>
