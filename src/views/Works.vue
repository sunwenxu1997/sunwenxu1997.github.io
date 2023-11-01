<script setup>
import { ref, onMounted, computed } from 'vue'
import works from '@/router/works.js'
import IconGithub from '@/components/icons/IconGithub.vue'
import IconLink from '@/components/icons/IconLink.vue'
import IconSkip from '@/components/icons/IconSkip.vue'
import IconImage from '@/components/icons/IconImage.vue'
import 'element-plus/es/components/image/style/css'
import { ElImage } from 'element-plus'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
import SearchButton from '@/components/SearchButton.vue'
const bodyScrollProgress = ref(0)
const textContentRef = ref(),
  titleRef = ref(),
  searchValue = ref('')
const workRoutes = computed(() => {
  return works.filter((item) => !item.meta.hidden && item.name.indexOf(searchValue.value) !== -1)
})
onMounted(() => {
  gsap.registerPlugin(ScrollTrigger)
  bodyScrollTrigger()
  elementScrollAnimation(titleRef.value)
  elementScrollAnimation(textContentRef.value, 0.2)
})
const toTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
// 监听滚动事件
const bodyScrollTrigger = () => {
  ScrollTrigger.create({
    trigger: document.body,
    onUpdate: (self) => {
      bodyScrollProgress.value = Math.ceil(self.progress * 10000) / 100
    }
  })
}
// 元素滚动动画
const elementScrollAnimation = (elements, delay = 0) => {
  elements.forEach((el) => {
    gsap.fromTo(
      el,
      { opacity: 0, y: 20 },
      {
        duration: 1,
        opacity: 1,
        delay: delay,
        y: 0,
        ease: 'power4.out',
        scrollTrigger: {
          trigger: el, // 触发滚动的元素
          start: 'top 100%' // 触发动画的滚动位置
        }
      }
    )
  })
}
const searchInput = (val) => {
  searchValue.value = val
}
</script>
<template>
  <div
    class="px-4 sm:px-60 sm:max-w-screen-sm sm:m-auto selection:bg-stone-700 selection:text-white"
  >
    <div class="pt-28 text-stone-800 text-xs tracking-widest">
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
          href="https://juejin.cn/user/1011206430666551"
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
    </div>
    <div cursor="link" class="py-12 w-full" v-for="(item, index) in workRoutes" :key="index">
      <div class="w-full aspect-video relative">
        <div
          class="w-full h-full flex justify-center items-center absolute top-0 left-0 animate-pulse"
        >
          <IconImage />
        </div>
        <el-image :src="item.meta.cover || `https://picsum.photos/1920/1080?random=${index}`" lazy>
        </el-image>
      </div>
      <div class="px-8 sm:px-0">
        <div ref="titleRef" class="py-6 flex justify-between">
          <div class="uppercase text-stone-800 text-sm font-bold">{{ item.name }}</div>
          <div class="group grid grid-rows-1 grid-flow-col gap-4">
            <a
              v-if="item.meta.articleLink"
              :href="item.meta.articleLink"
              title="文章链接"
              target="_blank"
            >
              <IconLink class="cursor-pointer group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <a :href="item.meta.githubCode" title="Github地址" target="_blank">
              <IconGithub class="cursor-pointer group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <router-link title="打开内容" :to="item.path">
              <IconSkip class="cursor-pointer group-hover:opacity-50 hover:!opacity-100" />
            </router-link>
          </div>
        </div>
        <p ref="textContentRef" class="m-0 text-xs text-stone-600 tracking-widest leading-7">
          AI-OCRやNLP(自然言語処理技術)等の先進的なAI技術を強みとし、転記業務を⾼速・⾃動化するプロダクト・サービスを開発する「株式会社インフォディオ」のWebサイトをリニューアルいたしました。「AIを駆使した先進的なプロダクト開発を行う自社の正しい姿を伝えられおらず、求人者とのミスマッチが起きてしまっている。」という問題を抱えられていたことから、リニューアル後のデザインではプロダクトを中心としたイメージを提案し、インフォディオらしい堅牢かつ先進的なデジタル感を強く押し出したビジュアルで構成いたしました。ビジュアルと共にサイト全体のコンテンツを整理することで、インフォディオの正しい姿をより魅力的に伝えることのできるWebサイトとなりました。
        </p>
      </div>
    </div>
    <SearchButton class="cursor" @input="searchInput" />
  </div>
  <div
    @click="toTop()"
    class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-sm fixed bottom-12 right-2 sm:right-20 cursor-pointer hover:shadow"
    :class="bodyScrollProgress < 3 ? 'opacity-0 pointer-events-none' : 'opacity-100'"
  >
    <svg
      class="icon -top-[0.5px] relative"
      viewBox="0 0 1024 1024"
      xmlns="http://www.w3.org/2000/svg"
      data-v-ea893728=""
    >
      <path fill="currentColor" d="M512 320 192 704h639.936z"></path>
    </svg>
  </div>
</template>
<style lang="scss" scoped>
/* 鼠标放在按钮上 仿鼠标标签的样式变化 */
[cursor='link']:hover ~ .cursor {
  mix-blend-mode: difference;
}
/* 鼠标点击按钮  仿鼠标标签的样式变化 */
[cursor='link']:active ~ .cursor {
  transform: scale(1.25);
}
</style>
