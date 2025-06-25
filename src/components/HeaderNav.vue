<script setup>
import 'element-plus/es/components/message/style/css'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { emitBus } from '@/utils/bus.js'
import defaultSet from '../settings'
import IconGithub from '@/components/icons/github.vue'
import IconEmail from '@/components/icons/email.vue'
const navs = [
  {
    name: '作品',
    path: '/works',
    dot: true //是否展示小红点
  },
  {
    name: '关于',
    path: '/about'
  }
]
const searchInputRef = ref(null),
  searchInputShow = ref(false),
  searchInputValue = ref('')
const clickSearchIcon = () => {
  searchInputShow.value = !searchInputShow.value
  if (searchInputShow.value) {
    setTimeout(() => {
      searchInputRef.value.focus()
    }, 300)
  }
}
const onSearchInputBlur = () => {
  if (searchInputValue.value === '') searchInputShow.value = false
}
const $router = useRouter()
const $route = useRoute()
// 是否显示导航
const navShow = computed(() => {
  return [...navs.map((item) => item.path), '/'].includes($route.path)
})
// 移动端导航展示
const navMobileShow = ref(false)
// 监听路由变化，关闭移动端导航
watch(
  () => $route.path,
  () => {
    navMobileShow.value = false
    document.body.style.overflow = 'auto'
  }
)
// 点击移动端导航按钮
const clickNavMobile = () => {
  navMobileShow.value = !navMobileShow.value
  if (navMobileShow.value) {
    document.body.style.overflow = 'hidden'
  } else {
    document.body.style.overflow = 'auto'
  }
}
// 当前页面是首页
const isHome = computed(() => {
  return $route.path === '/'
})
onMounted(() => {})
const toPath = (path) => {
  $router.push(path)
}
const toTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>
<template>
  <!-- 默认只会在对应导航和首页显示 -->
  <div v-if="navShow">
    <!-- pc端导航显示 -->
    <!-- 任意属性值，解决mask不支持问题 https://tailwind.nodejs.cn/docs/adding-custom-styles#-2 -->
    <div
      class="fixed flex sm:absolute z-50 w-full left-0 top-0 box-border text-base justify-between items-center px-12 py-10 sm:px-24"
      :class="!isHome && !navMobileShow ? 'backdrop-blur-sm bg-gradient-to-b from-white from-20% to-transparent sm:bg-none sm:backdrop-blur-none nav-mobile-mask sm:[mask-image:none]' : ''
      "
    >
      <div
        class="sm:fixed text-lg flex items-center font-bold"
        style="font-family: 'Rajdhani', sans-serif"
      >
        <span
          class="cursor-pointer sm:text-black"
          :class="isHome && !navMobileShow ? 'text-white' : 'text-black'"
          @click="toPath('/')"
          >WHO.</span
        >
        <span
          v-if="!isHome && !navMobileShow && !searchInputShow"
          @click="toTop()"
          class="mx-4 px-4 whitespace-nowrap tracking-widest font-normal text-sm relative cursor-pointer before:content-[''] before:absolute before:w-1 before:h-3/4 before:bg-stone-700 before:top-[2px] before:left-0"
          >{{ $route.meta.title }}</span
        >
      </div>
      <div class="flex items-center sm:hidden">
        <div
          class="flex items-center mr-2 p-2 box-border rounded-full"
          :class="{
            'bg-slate-50': searchInputShow,
            'opacity-0 pointer-events-none': navMobileShow || $route.path !== '/works'
          }"
        >
          <svg
            @click="clickSearchIcon()"
            class="icon fill-stone-700 w-6 h-6"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M16.9994165,16.2923098 L20.8535534,20.1464466 C21.0488155,20.3417088 21.0488155,20.6582912 20.8535534,20.8535534 C20.6582912,21.0488155 20.3417088,21.0488155 20.1464466,20.8535534 L16.2923098,16.9994165 C14.8819612,18.2444908 13.0292099,19 11,19 C6.581722,19 3,15.418278 3,11 C3,6.581722 6.581722,3 11,3 C15.418278,3 19,6.581722 19,11 C19,13.0292099 18.2444908,14.8819612 16.9994165,16.2923098 Z M11,18 C14.8659932,18 18,14.8659932 18,11 C18,7.13400675 14.8659932,4 11,4 C7.13400675,4 4,7.13400675 4,11 C4,14.8659932 7.13400675,18 11,18 Z"
            />
          </svg>
          <input
            ref="searchInputRef"
            class="select-none outline-none border-0 transition-all bg-transparent"
            :class="searchInputShow ? 'w-20 px-2' : 'w-0 p-0'"
            placeholder="搜索关键字"
            type="text"
            v-model="searchInputValue"
            @input="emitBus('searchInput', searchInputValue)"
            @blur="onSearchInputBlur()"
          />
        </div>
        <div
          @click="clickNavMobile()"
          class="relative cursor-pointer w-6 h-3 before:content-[''] before:absolute before:top-0 before:w-full before:h-[2px] before:transition after:transition after:content-[''] after:absolute after:bottom-0 after:w-full after:h-[2px] sm:after:bg-stone-700 sm:before:bg-stone-700"
          :class="[
            isHome && !navMobileShow
              ? 'before:bg-white after:bg-white'
              : 'before:bg-stone-700 after:bg-stone-700',
            navMobileShow &&
              ' before:rotate-45 before:top-[0.3rem] after:bottom-[0.3rem] after:-rotate-45'
          ]"
        ></div>
      </div>
      <!-- pc导航菜单部分 -->
      <div class="w-full px-10 justify-center hidden sm:flex">
        <div class="flex group">
          <div
            class="uppercase p-5 text-xs font-bold text-stone-800 cursor-pointer group-hover:opacity-50 hover:!opacity-100"
            :class="{ '!opacity-100': $route.path === item.path, 'opacity-50': !isHome }"
            v-for="(item, index) in navs"
            :key="index"
            @click="toPath(item.path)"
          >
            <span
              class="relative before:content-['']"
              :class="{
                ' before:opacity-80 before:w-2 before:h-2 before:rounded-full before:-z-10  before:bg-red-700  before:absolute before:top-0 before:-right-1':
                  item.dot
              }"
              >{{ item.name }}</span
            >
          </div>
        </div>
      </div>
      <!-- mobile 导航菜单部分 -->
      <div
        v-if="navMobileShow"
        class="absolute -z-10 w-full h-screen box-border left-0 top-0 pt-28 px-12 bg-white"
      >
        <div class="group">
          <div
            class="uppercase py-5 tracking-[1rem] text-xl text-center font-bold text-stone-800"
            v-for="(item, index) in navs"
            :key="index"
          >
            <span
              @click="toPath(item.path)"
              class="relative cursor-pointer group-hover:opacity-50 hover:!opacity-100 select-none before:content-['']"
              :class="{
                '!opacity-100': $route.path === item.path,
                'opacity-50': !isHome,
                ' before:opacity-80 before:w-2 before:h-2 before:rounded-full before:-z-10  before:bg-red-700  before:absolute before:top-0 before:-right-1':
                  item.dot
              }"
              >{{ item.name }}</span
            >
          </div>
        </div>
        <div
          class="absolute w-full bottom-12 left-0 px-12 box-border text-stone-800 text-sm font-bold"
        >
          <p class="mb-2 flex items-center">
            <IconEmail class="mr-2" />
            <a
              :href="'mailto:' + defaultSet.email"
              class="text-stone-800 text-sm font-bold hover:opacity-50 hover:no-underline"
              rel="email"
              >{{ defaultSet.email }}</a
            >
          </p>
          <p class="mb-2 flex items-center">
            <IconGithub class="mr-2" />
            <a
              :href="defaultSet.github"
              class="text-stone-800 text-sm font-bold hover:opacity-50 hover:no-underline"
              target="_blank"
              >Github.com</a
            >
          </p>
          <p
            class="my-0 mt-10 text-xs flex justify-between"
            style="font-family: 'Rajdhani', sans-serif"
          >
            <span>©2023 {{ defaultSet.userName }}</span>
            <span>github.io</span>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
<style lang="scss" scoped>
// @import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');
.nav-mobile-mask{
  mask-image:linear-gradient(to bottom, white 55%, transparent 100%)
}
</style>
