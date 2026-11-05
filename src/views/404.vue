<template>
  <div class="flex min-h-screen flex-col items-center justify-center px-4 text-center">
    <h1 class="m-4 mt-0 animate-pulse font-mono text-9xl font-bold text-stone-800">404</h1>
    <p class="text-2xl font-medium text-stone-600">页面未找到</p>
    <p class="text-stone-500">抱歉，您访问的页面不存在或已被移除</p>
    <div class="pt-4">
      <button
        type="button"
        class="cursor-pointer rounded-lg border-0 bg-white px-6 py-3 font-medium text-stone-800 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100"
        @click="goHome"
      >
        返回首页
      </button>
    </div>
  </div>
</template>
<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
const goHome = () => {
  router.push('/')
}
</script>
