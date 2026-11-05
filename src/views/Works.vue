<script setup>
import { ref, computed, onActivated, watch, onDeactivated, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useWorksStore } from '@/stores/works'
import IconGithub from '@/components/icons/github.vue'
import IconLink from '@/components/icons/link.vue'
import IconSkip from '@/components/icons/IconSkip.vue'
import IconImage from '@/components/icons/image.vue'
import IconDate from '@/components/icons/date.vue'
import IconCodepen from '@/components/icons/codepen.vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
import { List, LayoutGrid } from 'lucide-vue-next'
import SearchButton from '@/components/SearchButton.vue'
import { onBus } from '@/utils/bus.js'
const bodyScrollTop = ref(0)
// 视图模式：list 竖列（默认）/ grid 平铺卡片，localStorage 记住选择
const viewMode = ref(localStorage.getItem('works-view-mode') === 'grid' ? 'grid' : 'list')
// 移动端（<640px）固定竖列：不展示切换按钮，也不套用平铺样式
const desktopQuery = window.matchMedia('(min-width: 640px)')
const isDesktop = ref(desktopQuery.matches)
const syncIsDesktop = (e) => {
  isDesktop.value = e.matches
}
const currentView = computed(() => (isDesktop.value ? viewMode.value : 'list'))
const workItemRef = ref(),
  searchValue = ref(''),
  searchButtonRef = ref(null),
  searchIconShow = ref(true)
const worksStore = useWorksStore()
const workRoutes = computed(() => {
  // DB 已过滤 is_published=true，这里只做搜索过滤
  const keyword = searchValue.value.toLowerCase()
  return worksStore.works.filter((item) => item.name.toLowerCase().indexOf(keyword) !== -1)
})
// 通过监听works作品变化，重新执行动画
watch(workRoutes, () => {
  nextTick(() => {
    initWorkAnimations()
  })
})
// 记录列表滚动位置：keep-alive 只缓存组件状态，窗口滚动值需要自己存取
let savedScrollY = 0
// 上次离开列表后落在哪个路由：用于判断返回时能不能直接复用缓存数据
let leftToPath = ''
const route = useRoute()
onActivated(async () => {
  desktopQuery.addEventListener('change', syncIsDesktop)
  onBus('searchInput', searchInput)
  searchIconShow.value = true
  gsap.registerPlugin(ScrollTrigger)
  // 从作品详情返回时复用缓存，不再重复请求；列表为空或从其它页面（如后台改过数据）返回时照常刷新
  const fromDetail = leftToPath.startsWith('/work')
  if (!worksStore.works.length || !fromDetail) await worksStore.init()
  // 先回滚位置、再建滚动动画：恢复到的视口内元素才会被判定为已进入，入场动画不丢
  await nextTick()
  if (savedScrollY > 0) {
    window.scrollTo(0, savedScrollY)
    bodyScrollTop.value = savedScrollY
  }
  bodyScrollTrigger()
  initWorkAnimations()
})
onDeactivated(() => {
  // 组件 DOM 卸下后 window.scrollY 可能已被夹到 0，优先用滚动监听记录的值
  savedScrollY = bodyScrollTop.value || window.scrollY
  leftToPath = route.path
  desktopQuery.removeEventListener('change', syncIsDesktop)
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
// 每个作品进入视口时，内部元素依次淡入
const initWorkAnimations = () => {
  const items = workItemRef.value
  if (!items) return
  items.forEach((el) => {
    const cover = el.querySelector('.work-cover')
    const title = el.querySelector('.title-ref')
    const tags = el.querySelectorAll('.works-tag')
    const children = []
    if (cover) children.push(cover)
    if (title) children.push(title)
    children.push(...tags)
    gsap.set(children, { opacity: 0, y: 20 })
    ScrollTrigger.create({
      trigger: el,
      start: 'top 85%',
      once: true,
      onEnter: () => {
        gsap.to(children, {
          opacity: 1,
          y: 0,
          duration: 0.6,
          stagger: 0.08,
          ease: 'power3.out'
        })
      }
    })
  })
}
const searchInput = (val) => {
  searchValue.value = val
}
// 切换视图：DOM 更新后重建滚动动画（killAll 会连 body 滚动监听一起清掉，需一并重建）
const setViewMode = (mode) => {
  if (viewMode.value === mode) return
  viewMode.value = mode
  localStorage.setItem('works-view-mode', mode)
  nextTick(() => {
    ScrollTrigger.killAll()
    bodyScrollTrigger()
    initWorkAnimations()
  })
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
const $router = useRouter()
const toPath = (path) => {
  // 判断是否为外部链接
  if (path.indexOf('http') !== -1) window.open(path, '_blank')
  else $router.push(encodeURI(path))
}
// 返回作品详情页（可分享的独立地址）
const goDetail = (item) => {
  if (!item.id) return
  $router.push('/work/' + encodeURI(item.id))
}
const openChatbot = () => {
  window.cozeWebSDK.showChatBot()
}
</script>
<template>
  <!-- 平铺模式左右边距与导航栏容器同轨（HeaderNav 为 sm:px-24），并取消居中限宽，
       避免视口变宽时居中偏移导致与「WHO.」起始线错位 -->
  <div
    id="works-page"
    class="px-4 pt-28 selection:bg-stone-700 selection:text-white sm:m-auto"
    :class="currentView === 'grid' ? 'sm:px-24' : 'sm:max-w-screen-sm sm:px-60'"
  >
    <!-- 列表容器：平铺模式下变栅格（移动端单列 / sm 两列 / lg 三列 / 2xl 四列），竖列模式保持原单列流式布局 -->
    <div
      :class="
        currentView === 'grid'
          ? 'grid gap-x-6 gap-y-12 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4'
          : ''
      "
    >
      <div
        cursor="search"
        ref="workItemRef"
        class="w-full relative"
        :class="currentView === 'grid' ? 'mb-0 mt-0' : 'mt-12'"
        v-for="(item, index) in workRoutes"
        :key="index"
      >
        <div
          v-if="item.date && currentView === 'list'"
          class="hidden text-xs font-bold -mb-4 leading-4 translate-x-28 items-center justify-end sticky top-16 text-black sm:flex"
        >
          <IconDate class="mr-1 relative -top-[1px]" />
          {{ item.date }}
        </div>
        <div
          class="work-cover w-full aspect-video relative bg-stone-100 cursor-pointer"
          :class="
            currentView === 'grid' &&
            'overflow-hidden rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-shadow hover:shadow-[0_6px_20px_rgba(0,0,0,0.12)]'
          "
          title="查看详情"
          @click="goDetail(item)"
          @mouseenter="onMouseenterElement"
          @mouseleave="onMouseleaveElement"
        >
          <div
            class="w-full h-full flex flex-col justify-center items-center absolute top-0 left-0 animate-pulse"
          >
            <IconImage />
            <p v-if="!item.cover_url" class="text-xs">暂无上传</p>
          </div>
          <img
            v-if="item.cover_url"
            class="w-full h-full block object-cover relative z-10"
            :src="item.cover_url"
            loading="lazy"
            alt=""
          />
        </div>
        <!-- 文本区：移动端不再额外缩进，让标题/标签/日期与封面左缘对齐 -->
        <div :class="currentView === 'grid' ? 'pt-3' : 'sm:px-0'">
          <div
            class="flex justify-between title-ref"
            :class="currentView === 'grid' ? 'pb-2' : 'pt-6 pb-2'"
          >
            <div
              class="work-title uppercase text-stone-800 text-sm font-bold"
              :class="currentView === 'grid' && 'truncate'"
              title="查看详情"
              @click="goDetail(item)"
              @mouseenter="onMouseenterElement"
              @mouseleave="onMouseleaveElement"
            >
              {{ item.name }}
            </div>
            <div
              v-if="currentView === 'list'"
              class="group grid grid-rows-1 grid-flow-col gap-4"
              @mouseenter="onMouseenterElement"
              @mouseleave="onMouseleaveElement"
            >
              <a v-if="item.link_url" :href="item.link_url" title="推荐链接" target="_blank">
                <IconLink class="group-hover:opacity-50 hover:!opacity-100" />
              </a>
              <a v-if="item.code_url" :href="item.code_url" title="Github地址" target="_blank">
                <IconGithub class="group-hover:opacity-50 hover:!opacity-100" />
              </a>
              <a
                v-if="item.open_url"
                title="打开内容"
                @click="toPath(item.open_url)"
              >
                <IconSkip class="group-hover:opacity-50 hover:!opacity-100" />
              </a>
              <a v-if="item.codepen_url" :href="item.codepen_url" title="在线代码" target="_blank">
                <IconCodepen class="group-hover:opacity-50 hover:!opacity-100" />
              </a>
            </div>
          </div>
          <div v-if="item.tags && item.tags.length" class="works-tags">
            <span v-for="tag in item.tags" :key="tag" class="works-tag">{{ tag }}</span>
          </div>
          <div
            v-if="item.date"
            class="text-black flex items-center"
            :class="currentView === 'grid' ? 'mt-2 mb-0' : 'mb-2 sm:hidden'"
          >
            <IconDate class="mr-1 relative -top-[1px]" />
            <span class="text-xs font-bold">{{ item.date }}</span>
          </div>
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
      class="w-8 h-8 flex justify-center items-center rounded-full transition-opacity bg-white shadow-md cursor-pointer hover:shadow mb-4"
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
    <!-- 视图切换：单按钮在竖列 / 平铺之间切换，图标展示即将切换到的视图；移动端固定竖列，不展示 -->
    <div
      class="hidden sm:block"
      @mouseenter="onMouseenterElement"
      @mouseleave="onMouseleaveElement"
    >
      <button
        type="button"
        :title="currentView === 'list' ? '切换为平铺卡片' : '切换为竖列'"
        class="w-8 h-8 flex justify-center items-center rounded-full border-0 bg-white text-stone-600 shadow-md cursor-pointer transition-colors hover:text-stone-800 hover:shadow"
        @click="setViewMode(currentView === 'list' ? 'grid' : 'list')"
      >
        <LayoutGrid v-if="currentView === 'list'" :size="16" />
        <List v-else :size="16" />
      </button>
    </div>
  </div>
</template>
<style lang="scss">
.title-ref {
  cursor: auto !important;
  a {
    cursor: pointer;
  }
  .work-title {
    cursor: pointer !important;
    transition: opacity 0.2s;
    &:hover {
      opacity: 0.6;
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
  transform-origin: center;
  transform: scale(1.25);
}
.works-tags {
  display: flex;
  gap: 6px;
  margin-bottom: 8px;
  margin-top: 4px;
  overflow-x: auto;
  white-space: nowrap;
  scrollbar-width: thin;
  scrollbar-color: #d6d3d1 transparent;
}
.works-tags::-webkit-scrollbar {
  height: 3px;
}
.works-tags::-webkit-scrollbar-thumb {
  background: #d6d3d1;
  border-radius: 2px;
}
.works-tags::-webkit-scrollbar-track {
  background: transparent;
}
/* 移动端标签换行展示，避免横向溢出只能滑动；同时加大标签与日期的间距 */
@media (max-width: 639.98px) {
  .works-tags {
    flex-wrap: wrap;
    overflow-x: visible;
    white-space: normal;
    margin-bottom: 14px;
  }
}
.works-tag {
  font-size: 11px;
  padding: 1px 8px;
  border-radius: 4px;
  background: #f5f5f4;
  color: #44403c;
  white-space: nowrap;
  flex-shrink: 0;
}
</style>
