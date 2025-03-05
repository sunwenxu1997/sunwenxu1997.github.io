<script>
export default {
  hidden: true
}
</script>
<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { listenBroadcastChannel, closeBroadcastChannel } from '@/utils/index'
onMounted(() => {
  // 监听名为 "sunwenxu-login" 的通道
  listenBroadcastChannel('sunwenxu-login', (e) => {
    console.log('BroadcastChannel 多页面通信-B', e.data)
  })
})
onUnmounted(() => {
  // 关闭通道
  closeBroadcastChannel('sunwenxu-login')
})
</script>
<template>
</template>
<style lang="scss" scoped></style>
