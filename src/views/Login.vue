<template>
  <div class="min-h-screen flex items-center justify-center">
    <div class="w-full max-w-sm">
      <!-- WHO Logo -->
      <div class="text-center mb-8">
        <h1 class="text-2 font-bold text-black tracking-wider font-[Rajdhani]">WHO.</h1>
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
            class="w-full h-12 px-6 box-border border-4 border-black text-black rounded-none focus:outline-none transition-all duration-300 ease-in-out"
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
            class="w-full h-12 px-6 box-border border-4 border-black text-black rounded-none focus:outline-none transition-all duration-300 ease-in-out"
            required
            @keydown.prevent.enter="toLogin"
          />
        </div>

        <!-- Login Button -->
        <button
          @click="toLogin"
          type="submit"
          class="w-full h-12 bg-black text-white hover:bg-gray-800 transition-all duration-300 ease-in-out hover:shadow-md hover:shadow-black/20 active:scale-[0.99] font-bold cursor-pointer rounded-none mt-6"
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
