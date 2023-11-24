<script>
export default {
  hidden: true
}
</script>
<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
const msg = ref('')
let channel = null
onMounted(() => {
  // 创建一个名为 "myChannel" 的通道
  channel = new BroadcastChannel('myChannel')
  // 监听通道的消息
  channel.onmessage = (e) => {
    console.log(e.data)
    msg.value = e.data
  }
})
onUnmounted(() => {
  // 关闭通道
  channel.close()
})
const changeInput = (e) => {
  msg.value = e.target.value
  // 发送消息到通道
  channel.postMessage(e.target.value)
}
</script>
<template>
  <input type="text" v-model="msg" @input="changeInput" />
</template>
<style lang="scss" scoped></style>
