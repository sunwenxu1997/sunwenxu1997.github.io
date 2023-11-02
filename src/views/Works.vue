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
import { onBus } from '@/utils/bus.js'
const bodyScrollProgress = ref(0)
const textContentRef = ref(),
    titleRef = ref(),
    searchValue = ref(''),
    searchButtonRef = ref(null),
    searchIconShow = ref(true)
const workRoutes = computed(() => {
    return works.filter((item) => !item.meta.hidden && item.name.indexOf(searchValue.value) !== -1)
})
onMounted(() => {
    onBus('searchInput', searchInput)
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
// 部分选项操作不需要展示悬浮的搜索，需要展示默认鼠标样式
const onMouseenterElement = () => {
    // toggle() 方法：切换元素的类，如果类已存在，则移除该类；如果类不存在，则添加该类。
    // searchButtonRef.value.$el.classList.toggle('sm:flex')
    searchIconShow.value = false
}
const onMouseleaveElement = () => {
    searchIconShow.value = true
}
</script>
<template>
    <div id="works-page"
        class="px-4 pt-28 sm:px-60 sm:max-w-screen-sm sm:m-auto bg-white selection:bg-stone-700 selection:text-white">
        <div cursor="search" class="py-12 w-full" v-for="(item, index) in workRoutes" :key="index">
            <div class="w-full aspect-video relative bg-stone-100">
                <div class="w-full h-full flex justify-center items-center absolute top-0 left-0 animate-pulse">
                    <IconImage />
                </div>
                <el-image class="h-full" :src="item.meta.cover || `https://picsum.photos/1920/1080?random=${index}`" lazy>
                </el-image>
            </div>
            <div class="px-8 sm:px-0">
                <div ref="titleRef" class="py-6 flex justify-between">
                    <div class="uppercase text-stone-800 text-sm font-bold">{{ item.name }}</div>
                    <div class="group grid grid-rows-1 grid-flow-col gap-4" @mouseenter="onMouseenterElement"
                        @mouseleave="onMouseleaveElement">
                        <a v-if="item.meta.articleLink" :href="item.meta.articleLink" title="文章链接" target="_blank">
                            <IconLink class="group-hover:opacity-50 hover:!opacity-100" />
                        </a>
                        <a :href="item.meta.githubCode" title="Github地址" target="_blank">
                            <IconGithub class="group-hover:opacity-50 hover:!opacity-100" />
                        </a>
                        <router-link title="打开内容" :to="item.path">
                            <IconSkip class="group-hover:opacity-50 hover:!opacity-100" />
                        </router-link>
                    </div>
                </div>
                <p ref="textContentRef" class="m-0 text-xs text-stone-600 tracking-widest leading-7">
                    AI-OCRやNLP(自然言語処理技術)等の先進的なAI技術を強みとし、転記業務を⾼速・⾃動化するプロダクト・サービスを開発する「株式会社インフォディオ」のWebサイトをリニューアルいたしました。「AIを駆使した先進的なプロダクト開発を行う自社の正しい姿を伝えられおらず、求人者とのミスマッチが起きてしまっている。」という問題を抱えられていたことから、リニューアル後のデザインではプロダクトを中心としたイメージを提案し、インフォディオらしい堅牢かつ先進的なデジタル感を強く押し出したビジュアルで構成いたしました。ビジュアルと共にサイト全体のコンテンツを整理することで、インフォディオの正しい姿をより魅力的に伝えることのできるWebサイトとなりました。
                </p>
            </div>
        </div>
        <SearchButton ref="searchButtonRef" class="cursor" :searchIconShow="searchIconShow" @input="searchInput" />
    </div>
    <div @mouseenter="onMouseenterElement" @mouseleave="onMouseleaveElement" @click="toTop()"
        class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-md fixed bottom-10 right-8 sm:right-20 cursor-pointer hover:shadow"
        :class="bodyScrollProgress < 3 ? 'opacity-0 pointer-events-none' : 'opacity-100'">
        <svg class="icon -top-[0.5px] relative" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg"
            data-v-ea893728="">
            <path fill="currentColor" d="M512 320 192 704h639.936z"></path>
        </svg>
    </div>
</template>
<style lang="scss" scoped>
/* 鼠标放在按钮上 仿鼠标标签的样式变化 */
[cursor='search']:hover~.cursor {
    mix-blend-mode: difference;
}

/* 鼠标点击按钮  仿鼠标标签的样式变化 */
#works-page:active .cursor {
    transform: scale(1.25);
}
</style>
