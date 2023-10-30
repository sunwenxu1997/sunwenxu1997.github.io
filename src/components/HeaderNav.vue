<script setup>
import IconRefresh from './icons/IconRefresh.vue'
import IconGithub from './icons/IconGithub.vue'
import IconLink from './icons/IconLink.vue'
import IconSearch from './icons/IconSearch.vue'
import 'element-plus/es/components/message/style/css'
import { ElMessage } from 'element-plus'
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import routes from '../router/works'
import { useAppStore } from '../stores/index'
const navs = [
  {
    name: '作品',
    path: '/works'
  },
  {
    name: '关于',
    path: '/about'
  }
]
onMounted(() => {})
const $router = useRouter()
const $route = useRoute()
const store = useAppStore()
const toPath = (path)=>{
    $router.push(path)
}
</script>
<template>
  <div
    class="fixed z-20 w-screen p-5 box-border text-base flex justify-between items-center px-12 sm:px-24 py-10"
  >
    <div
      class="text-lg font-bold cursor-pointer sm:text-black"
      :class="$route.path == '/' ? 'text-white' : 'text-black'"
      style="font-family: 'Rajdhani', sans-serif"
      @click="toPath('/')"
    >
      WHO.
    </div>
    <div
      class="relative cursor-pointer w-7 h-3 before:content-[''] before:absolute before:top-0 before:w-full before:h-[2px]  after:content-[''] after:absolute after:bottom-0 after:w-full after:h-[2px]  sm:after:bg-black sm:before:bg-black sm:hidden"
      :class="$route.path == '/' ? 'before:bg-white after:bg-white' : 'before:bg-black after:bg-black'"
    ></div>
    <div class="w-full px-10  justify-center hidden sm:flex">
      <div
        class=" uppercase p-5 text-xs font-bold text-stone-800 cursor-pointer hover:underline "
        :class="{'underline': $route.path === item.path}"
        v-for="(item, index) in navs"
        :key="index"
        @click="toPath(item.path)"
      >
        {{ item.name }}
      </div>
    </div>
  </div>
</template>
<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');
</style>
