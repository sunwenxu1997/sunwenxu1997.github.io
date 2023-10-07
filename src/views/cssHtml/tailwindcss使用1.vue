<script>
export default {
  hidden: true // 页面路由隐藏
}
</script>
<script setup>
import { ref, reactive, onMounted } from 'vue'
onMounted(() => {})
</script>
<template>
  <div class="text-xs p-3 text-zinc-400 grid grid-cols-1 gap-3">
    <h1 class="sm:text-indigo-500">@media (min-width: 640px)</h1>
    <h1 class="md:text-indigo-500">@media (min-width: 768px)</h1>
    <h1 class="lg:text-indigo-500">@media (min-width: 1024px)</h1>
    <h1 class="xl:text-indigo-500">@media (min-width: 1280px)</h1>
  </div>
</template>
<style scoped></style>
