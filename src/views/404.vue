<template>
  <!-- <div class="min-h-screen bg-black flex items-center justify-center px-4">
    <div class="text-center space-y-8">
      <div class="space-y-4">
        <h1 class="text-8xl md:text-9xl font-bold text-white animate-pulse">404</h1>
        <div class="space-y-2">
          <h2 class="text-2xl md:text-3xl font-semibold text-white">页面未找到</h2>
          <p class="text-gray-400 text-lg max-w-md mx-auto">抱歉，您访问的页面不存在或已被移除</p>
        </div>
      </div>

      <div class="pt-4">
        <button 
          @click="goHome"
          class="px-6 py-3 bg-white text-black font-medium rounded-lg hover:bg-gray-100 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-black"
        >
          返回首页
        </button>
      </div>
    </div>
  </div> -->
  <div class="min-h-screen flex items-center justify-center">
    <div class="text-center">
      <h1 class="text-9xl font-bold text-gray-800 animate-pulse font-mono m-4 mt-0">404</h1>
      <p class="text-2xl font-medium text-gray-600">页面未找到</p>
      <p class="text-gray-500">抱歉，您访问的页面不存在或已被移除</p>
      <div class="pt-4">
        <button
          @click="goHome"
          class="px-6 py-3 bg-white text-black font-medium cursor-pointer hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
        >
          返回首页
        </button>
      </div>
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
