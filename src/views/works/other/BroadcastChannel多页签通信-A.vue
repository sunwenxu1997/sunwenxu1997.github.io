<script>
export default {
  hidden: true
}
</script>
<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { createBroadcastChannel } from '@/utils/index'
onMounted(() => {
  
})
onUnmounted(() => {
  // 关闭通道
  window.sunwenxuLogin.close()
})
const toLogin = (e) => {
  // 创建一个名为 "sunwenxu-login" 的通道
  // 发送消息到通道
  createBroadcastChannel('sunwenxu-login', {
    login: true
  })
}
</script>
<template>
  <button @click="toLogin">登录</button>
</template>
<style lang="scss" scoped></style>
