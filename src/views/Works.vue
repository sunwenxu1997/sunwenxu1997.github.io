<script setup>
import { ref, computed, onActivated, watch, onDeactivated, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { useWorksStore } from '@/stores/works'
import IconGithub from '@/components/icons/github.vue'
import IconLink from '@/components/icons/link.vue'
import IconSkip from '@/components/icons/IconSkip.vue'
import IconImage from '@/components/icons/image.vue'
import IconDate from '@/components/icons/date.vue'
import IconCodepen from '@/components/icons/codepen.vue'
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
const worksStore = useWorksStore()
const workRoutes = computed(() => {
  // 数据由 store 合并 DB + glob 并排序，这里只做搜索过滤
  const keyword = searchValue.value.toLowerCase()
  return worksStore.works.filter(
    (item) =>
      !item.meta.hidden && item.name.toLowerCase().indexOf(keyword) !== -1
  )
})
// 通过监听works作品变化，重新执行动画 避免快速搜索时，部分元素未执行动画
watch(workRoutes, () => {
  // 搜索结果变化时，等待dom更新后执行动画
  nextTick(() => {
    elementScrollAnimation(titleRef.value)
    elementScrollAnimation(textContentRef.value, 0.2)
  })
})
onActivated(() => {
  onBus('searchInput', searchInput)
  searchIconShow.value = true
  worksStore.init()
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
  // gsap.killTweensOf(elements)
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
          // markers: true,
          trigger: el, // 触发滚动的元素
          start: 'top bottom' // 触发动画的滚动位置
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
// 加工处理html格式
const handleHtmlContent = (html) => {
  if (!html) return '' // 作者🐔很懒啥也没写。建议直接点击右上↗链接...
  // 换行加<br/>
  return html.replace(/\n/g, '<br/>')
}
const $router = useRouter()
const toPath = (path) => {
  // 判断是否为外部链接
  if (path.indexOf('http') !== -1) window.open(path, '_blank')
  else $router.push(path)
}
const openChatbot = () => {
  window.cozeWebSDK.showChatBot()
}
</script>
<template>
  <div
    id="works-page"
    class="px-4 pt-28 sm:px-60 sm:max-w-screen-sm sm:m-auto selection:bg-stone-700 selection:text-white"
  >
    <div
      cursor="search"
      class="pt-12 mb-12 w-full relative"
      v-for="(item, index) in workRoutes"
      :key="index"
    >
      <div
        v-if="item.meta.date"
        class="hidden text-xs font-bold -mb-4 leading-4 translate-x-28 items-center justify-end sticky top-16 text-black sm:flex"
      >
        <IconDate class="mr-1 relative -top-[1px]" />
        {{ item.meta.date }}
      </div>
      <div class="w-full aspect-video relative bg-stone-100">
        <div
          class="w-full h-full flex flex-col justify-center items-center absolute top-0 left-0 animate-pulse"
        >
          <IconImage />
          <p v-if="!item.meta.cover" class="text-xs">暂无上传</p>
        </div>
        <img
          v-if="item.meta.cover"
          class="w-full h-full block object-cover relative z-10"
          :src="item.meta.cover"
          loading="lazy"
          alt=""
        />
      </div>
      <div class="px-8 sm:px-0">
        <div ref="titleRef" class="py-6 flex justify-between title-ref">
          <div
            class="uppercase text-stone-800 text-sm font-bold"
            @mouseenter="onMouseenterElement"
            @mouseleave="onMouseleaveElement"
          >
            {{ item.name }}
          </div>
          <div
            class="group grid grid-rows-1 grid-flow-col gap-4"
            @mouseenter="onMouseenterElement"
            @mouseleave="onMouseleaveElement"
          >
            <a v-if="item.meta.link" :href="item.meta.link" title="推荐链接" target="_blank">
              <IconLink class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <a v-if="item.meta.code" :href="item.meta.code" title="Github地址" target="_blank">
              <IconGithub class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <a v-if="item.path || item.meta.open" title="打开内容" @click="toPath(item.path || item.meta.open)">
              <IconSkip class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
            <a v-if="item.meta.codepen" :href="item.meta.codepen" title="在线代码" target="_blank">
              <IconCodepen class="group-hover:opacity-50 hover:!opacity-100" />
            </a>
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
            style="word-break: break-all"
            v-html="handleHtmlContent(item.meta.info)"
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
  <div class="fixed z-10 bottom-10 right-4 sm:right-20">
    <div
      @mouseenter="onMouseenterElement"
      @mouseleave="onMouseleaveElement"
      @click="toTop()"
      class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-md cursor-pointer hover:shadow mb-4"
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
    <div
      @mouseenter="onMouseenterElement"
      @mouseleave="onMouseleaveElement"
      @click="openChatbot()"
      class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-md cursor-pointer hover:shadow"
    >
      <svg
        t="1739782650202"
        class="icon"
        viewBox="0 0 1024 1024"
        version="1.1"
        xmlns="http://www.w3.org/2000/svg"
        p-id="11460"
        width="200"
        height="200"
      >
        <path
          d="M896 128a42.666667 42.666667 0 0 1 42.666667 42.666667v597.333333a42.666667 42.666667 0 0 1-42.666667 42.666667H275.413333L85.333333 960V170.666667a42.666667 42.666667 0 0 1 42.666667-42.666667h768zM448.64 316.245333C372.394667 349.312 320 416.213333 320 490.88c0 42.453333 11.818667 68.650667 33.792 91.946667 13.824 14.72 35.712 25.173333 58.624 25.173333a74.666667 74.666667 0 0 0 74.666667-74.666667 75.093333 75.093333 0 0 0-68.864-74.453333 89.770667 89.770667 0 0 0-20.437334 0.426667v-3.925334c0.256-18.773333 4.266667-74.24 69.930667-109.781333l-19.072-29.354667z m213.333333 0c-76.245333 33.066667-128.64 99.968-128.64 174.634667 0 42.453333 11.818667 68.650667 33.792 91.946667 13.824 14.72 35.712 25.173333 58.624 25.173333a74.666667 74.666667 0 0 0 74.666667-74.666667 75.093333 75.093333 0 0 0-68.864-74.453333 89.770667 89.770667 0 0 0-20.437333 0.426667v-3.925334c0.256-18.773333 4.266667-74.24 69.930666-109.781333l-19.072-29.354667z"
          fill="#000000"
          p-id="11461"
        ></path>
      </svg>
    </div>
  </div>
</template>
<style lang="scss">
.title-ref {
  cursor: auto !important;
  a {
    cursor: pointer;
  }
}
.info-ref {
  cursor: text !important;
  p {
    margin: 0 !important;
  }
  code {
    background: #000000;
    color: white;
    padding: 0 0.33rem;
    margin: 0 0.2rem;
    &::selection {
      background-color: #2ae3e6 !important;
    }
  }
  a {
    color: rgb(87 83 78);
    font-weight: bold;
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
  transform-origin: center;
  transform: scale(1.25);
}
</style>