<template>
  <!-- 背景有who字样充满整个屏幕 -->
  <div
    style="-webkit-text-stroke: 0.02rem #c3c3c3"
    class="absolute top-0 left-0 z-0 overflow-hidden w-full h-full flex items-center justify-center"
  >
    <span class="text-[45vmax] text-transparent bg-clip-text font-bold rotate-90 sm:rotate-12 relative left-6 sm:left-0"
      >WHO</span
    >
  </div>
  <div class="h-dvh flex items-center justify-center relative z-10 mix-blend-overlay">
    <div class="w-3/4 sm:w-full max-w-sm">
      <!-- WHO Logo -->
      <div class="text-center mb-8">
        <h1 class="text-lg font-bold text-black tracking-wider font-[Rajdhani] mt-0">WHO.</h1>
      </div>

      <!-- Login Form -->
      <div class="space-y-6">
        <!-- Email Input -->
        <div class="relative">
          <input
            id="account"
            v-model="accountValue"
            type="text"
            placeholder="账号"
            class="w-full h-12 px-6 bg-transparent box-border border-2 border-black text-black rounded-none focus:outline-none transition-all duration-300 ease-in-out"
            required
            @keydown.prevent.enter="toLogin"
          />
        </div>

        <!-- Password Input -->
        <div class="relative">
          <input
            id="password"
            v-model="passwordValue"
            type="password"
            placeholder="密码"
            class="w-full h-12 px-6 bg-transparent box-border border-2 border-black text-black rounded-none focus:outline-none transition-all duration-300 ease-in-out"
            required
            @keydown.prevent.enter="toLogin"
          />
        </div>

        <!-- Login Button -->
        <button
          @click="toLogin"
          type="submit"
          class="w-full h-12 border-none bg-black text-white hover:bg-gray-800 transition-all duration-300 ease-in-out hover:shadow-md hover:shadow-black/20 active:scale-[0.99] font-bold cursor-pointer rounded-none mt-6"
        >
          登 录
        </button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { login } from '@/api/index'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
const accountValue = ref('')
const passwordValue = ref('')
const router = useRouter()
const toLogin = () => {
  if (!accountValue.value || !passwordValue.value) {
    return
  }
  login({ username: accountValue.value, password: passwordValue.value }).then((res) => {
    router.push('/')
  })
}
</script>
