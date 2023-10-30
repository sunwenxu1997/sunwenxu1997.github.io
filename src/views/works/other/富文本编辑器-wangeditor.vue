<script>
export default {
  articleLink: 'https://www.wangeditor.com/v5/for-frame.html#vue3'
}
</script>
<script setup>
import WangEditor from '@/components/wangeditor/index.vue'
import { onMounted, ref } from 'vue'
const content = ref('<p>😁我是一个好用的富文本编辑器~</p>')
const disable = ref(false)
onMounted(() => {})
</script>
<template>
  <WangEditor v-model="content" :disable="disable" />
</template>
<style scoped></style>
