<script setup>
import { ref, reactive, onMounted } from 'vue'
import IconGithub from '@/components/icons/github.vue'
import IconEmail from '@/components/icons/email.vue'
import defaultSet from '../settings'
onMounted(() => {})
</script>
<template>
  <div
    class="pt-28 px-12 sm:px-60 text-xs tracking-widest sm:max-w-screen-sm sm:m-auto selection:bg-stone-700 selection:text-white"
  >
    <p>关于作者是个菜鸡🐔。</p>
    <br />
    <p>
      日常划水积累的小项目，包含
      <span class="font-bold underline text-sm">css</span>、
      <span class="font-bold underline text-sm">html</span>、
      <span class="font-bold underline text-sm">js</span>、
      <span class="font-bold underline text-sm">vue</span>、
      <span class="font-bold underline text-sm">gsap</span>、
      <span class="font-bold underline text-sm">threejs</span>、
      <span class="font-bold underline text-sm">tailwindcss</span>等。
    </p>
    <p>大多是以动画效果形式展示，方便有效理解和提起我的兴趣。偶尔我自己也会翻着看🤣</p>
    <p>
      自己也有写相关的文章，主要在平台
      <a
        class="text-sm text-stone-800 font-bold"
        href="https://juejin.cn/user/1011206430666551/posts?sort=popular"
        target="_blank"
        >掘金</a
      >、
      <a
        class="text-sm text-stone-800 font-bold"
        href="https://www.jianshu.com/u/5294c349f0f1"
        target="_blank"
        >简书(弃用)</a
      >都有记录，你也可以通过
      <a
        class="text-sm text-stone-800 font-bold"
        href="https://github.com/sunwenxu1997"
        target="_blank"
        >Github</a
      >找到我， 欢迎交流👾。
    </p>
    <br /><br /><br />
    <p class="mb-2 flex items-center select-none">
      <IconEmail class="mr-2" />
      <a
        :href="'mailto:' + defaultSet.email"
        class="text-stone-800 text-sm font-bold hover:opacity-50 hover:no-underline"
        rel="email"
        >{{ defaultSet.email }}</a
      >
    </p>
    <p class="mb-2 flex items-center select-none">
      <IconGithub class="mr-2" />
      <a
        :href="defaultSet.github"
        class="text-stone-800 text-sm font-bold hover:opacity-50 hover:no-underline"
        target="_blank"
        >Github.com</a
      >
    </p>
  </div>
</template>
<style lang="scss" scoped></style>
