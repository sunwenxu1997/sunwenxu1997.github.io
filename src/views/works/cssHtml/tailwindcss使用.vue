<script>
export default {
  link: 'https://juejin.cn/post/7290740395914362921',
  cover: 'https://iili.io/Jq64QqJ.gif'
}
</script>

<script setup>
/**
 * https://tailwindcss.com/docs/installation
 * 安装
 * npm install -D tailwindcss
 * npx tailwindcss init
 *
 * 配置模板路径
 * 在 `tailwind.config.js` 文件中添加所有模板文件的路径
 *
 * VS Code 的 Tailwind CSS IntelliSense 扩展，编辑起来更快
 *
 */
import { ref, reactive, onMounted } from 'vue'
import AppleWindow from '@/components/AppleWindow.vue'
onMounted(() => {})
</script>
<template>
  <div class="grid h-screen place-content-center">
    <AppleWindow>
      <iframe class="w-full h-full" src="/#/" frameborder="0"></iframe>
    </AppleWindow>
  </div>
</template>
<style scoped></style>
