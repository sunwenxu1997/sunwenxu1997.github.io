<script setup>
import { ref, onMounted, computed, onUnmounted, onActivated, watch, onDeactivated } from 'vue'
import works from '@/router/works.js'
import IconGithub from '@/components/icons/github.vue'
import IconLink from '@/components/icons/link.vue'
import IconSkip from '@/components/icons/IconSkip.vue'
import IconImage from '@/components/icons/image.vue'
import IconDate from '@/components/icons/date.vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
import SearchButton from '@/components/SearchButton.vue'
import { onBus } from '@/utils/bus.js'
const bodyScrollTop = ref(0)
const textContentRef = ref(),
  titleRef = ref(),
  searchValue = ref(''),
  searchButtonRef = ref(null),
  searchIconShow = ref(true)
const workRoutes = computed(() => {
  // 过滤掉隐藏的路由,日期降序,sort降序
  return works
    .filter((item) => !item.meta.hidden && item.name.indexOf(searchValue.value) !== -1)
    .sort((a, b) => new Date(b.meta.date).getTime() - new Date(a.meta.date).getTime())
    .sort((a, b) => b.meta.sort - a.meta.sort)
})
// 通过监听works作品变化，重新执行动画 避免快速搜索时，部分元素未执行动画
watch(workRoutes, () => {
  elementScrollAnimation(titleRef.value)
  elementScrollAnimation(textContentRef.value, 0.2)
})
onActivated(() => {
  onBus('searchInput', searchInput)
  searchIconShow.value = true
  gsap.registerPlugin(ScrollTrigger)
  bodyScrollTrigger()
  elementScrollAnimation(titleRef.value)
  elementScrollAnimation(textContentRef.value, 0.2)
})
onDeactivated(() => {
  ScrollTrigger.killAll()
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
    onUpdate: () => {
      bodyScrollTop.value = window.pageYOffset
    }
  })
}
// 元素滚动动画
const elementScrollAnimation = (elements, delay = 0) => {
  // 清除指定目标元素的所有动画
  gsap.killTweensOf(elements)
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
          //   markers: true,
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
  <div
    id="works-page"
    class="px-4 pt-28 sm:px-60 sm:max-w-screen-sm sm:m-auto bg-white selection:bg-stone-700 selection:text-white"
  >
    <div
      cursor="search"
      class="pt-12 mb-12 w-full relative"
      v-for="(item, index) in workRoutes"
      :key="index"
    >
      <div
        v-if="item.meta.date"
        class="hidden text-xs font-bold -mb-4 leading-4 translate-x-28 items-center justify-end sticky top-4 text-black sm:flex"
      >
        <IconDate class="mr-1 relative -top-[1px]" />
        {{ item.meta.date }}
      </div>
      <div class="w-full aspect-video relative bg-stone-100">
        <div
          class="w-full h-full flex justify-center items-center absolute top-0 left-0 animate-pulse"
        >
          <IconImage />
        </div>
        <img
          class="w-full h-full block object-cover relative z-10"
          :src="item.meta.cover || `https://picsum.photos/1920/1080?random=${index}`"
          loading="lazy"
          alt=""
        />
      </div>
      <div class="px-8 sm:px-0">
        <div ref="titleRef" class="py-6 flex justify-between">
          <div class="uppercase text-stone-800 text-sm font-bold">{{ item.name }}</div>
          <div
            class="group grid grid-rows-1 grid-flow-col gap-4"
            @mouseenter="onMouseenterElement"
            @mouseleave="onMouseleaveElement"
          >
            <a v-if="item.meta.link" :href="item.meta.link" title="文章链接" target="_blank">
              <IconLink class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <a :href="item.meta.code" title="Github地址" target="_blank">
              <IconGithub class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <router-link title="打开内容" :to="item.path">
              <IconSkip class="group-hover:opacity-50 hover:!opacity-100" />
            </router-link>
          </div>
        </div>
        <div v-if="item.meta.date" class="text-stone-500 mb-2 flex items-center sm:hidden">
          <IconDate class="mr-1 relative -top-[1px]" />
          <span class="text-xs font-bold">{{ item.meta.date }}</span>
        </div>
        <div
          ref="textContentRef"
          class="m-0 text-xs text-stone-600 tracking-widest leading-7 info-ref"
        >
          <div
            v-html="
              item.meta.info
                ? item.meta.info
                : `<p>作者🐔很懒啥也没写。<br/>建议直接点击右上↗链接...</p>`
            "
            @mouseenter="onMouseenterElement"
            @mouseleave="onMouseleaveElement"
          ></div>
        </div>
      </div>
    </div>
    <SearchButton
      ref="searchButtonRef"
      class="cursor"
      :searchIconShow="searchIconShow"
      @input="searchInput"
    />
  </div>
  <div
    @mouseenter="onMouseenterElement"
    @mouseleave="onMouseleaveElement"
    @click="toTop()"
    class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-md fixed bottom-10 right-8 sm:right-20 cursor-pointer hover:shadow"
    :class="bodyScrollTop < 200 ? 'opacity-0 pointer-events-none' : 'opacity-100'"
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
<style lang="scss">
.info-ref {
  p {
    margin: 0 !important;
  }
  code {
    background: #000000;
    color: white;
    padding: 0 0.33rem;
    cursor: text;
    &::selection {
      background-color: #2ae3e6 !important;
    }
  }
}
</style>
<style lang="scss" scoped>
/* 鼠标放在按钮上 仿鼠标标签的样式变化 */
[cursor='search']:hover ~ .cursor {
  mix-blend-mode: difference;
}

/* 鼠标点击按钮  仿鼠标标签的样式变化 */
#works-page:active .cursor {
  transform: scale(1.25);
}
</style>
