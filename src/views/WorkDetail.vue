<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { animate, stagger } from 'animejs'
import { fetchWorkDetail } from '@/api/works'
import { useWorksStore } from '@/stores/works'
import MarkdownBody from '@/components/markdown/MarkdownBody.vue'
import IconDate from '@/components/icons/date.vue'
import IconGithub from '@/components/icons/github.vue'
import IconLink from '@/components/icons/link.vue'
import IconCodepen from '@/components/icons/codepen.vue'
import IconSkip from '@/components/icons/IconSkip.vue'
import IconBack from '@/components/icons/back.vue'
import IconCopy from '@/components/icons/copy.vue'

const route = useRoute()
const router = useRouter()
const worksStore = useWorksStore()

const work = ref(null)
const loading = ref(true)
const toc = ref([])
const actionsRef = ref(null)

/** 悬浮操作条入场：自上而下依次淡入下落 */
function playActionsEnter() {
  const els = actionsRef.value?.children
  if (!els || !els.length) return
  animate(els, {
    opacity: [0, 1],
    translateY: [-16, 0],
    duration: 600,
    delay: stagger(120),
    ease: 'out(3)'
  })
}

/** 路由参数：作品 id；多段路径视为旧版 slug 链接（补前导斜杠），单段视为 id */
const workKey = computed(() => {
  const raw = route.params.id
  const path = Array.isArray(raw) ? raw.join('/') : raw || ''
  let key = path
  try {
    key = decodeURIComponent(path)
  } catch {
    /* 解码失败保留原串 */
  }
  return key.includes('/') ? `/${key}` : key
})

const contentPath = computed(() => {
  const item = work.value
  if (!item) return ''
  // 组件作品：打开对应 demo 页面；外部作品：打开 open_url
  if (item.slug && !item.slug.includes('/external')) return item.slug
  return item.open_url || item.code_url || ''
})

const currentIndex = computed(() =>
  worksStore.works.findIndex((item) => item.id === work.value?.id)
)
const prevWork = computed(() =>
  currentIndex.value > 0 ? worksStore.works[currentIndex.value - 1] : null
)
const nextWork = computed(() => {
  const list = worksStore.works
  if (currentIndex.value < 0 || currentIndex.value >= list.length - 1) return null
  return list[currentIndex.value + 1]
})

async function load() {
  loading.value = true
  toc.value = []
  try {
    work.value = await fetchWorkDetail(workKey.value)
  } catch (err) {
    console.error('[work-detail] 加载失败:', err)
    work.value = null
  } finally {
    loading.value = false
  }

  if (work.value) {
    document.title = `${work.value.name} - 誰在花里胡哨`
    const desc = document.querySelector('meta[name="description"]')
    if (desc) desc.setAttribute('content', work.value.name)
  }

  // 外链按钮随 work 渲染，等 DOM 更新后再播入场动画
  await nextTick()
  playActionsEnter()
}

function scrollTo(id) {
  const el = document.getElementById(id)
  if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

function openContent() {
  const path = contentPath.value
  if (!path) return
  if (path.startsWith('http')) window.open(path, '_blank')
  else router.push(encodeURI(path))
}

async function copyLink() {
  try {
    await navigator.clipboard.writeText(window.location.href)
    toast.success('链接已复制，可以直接分享')
  } catch {
    toast.error('复制失败，请手动复制地址栏链接')
  }
}

const goBack = () => router.push('/works')
const goWork = (item) => router.push('/work/' + encodeURI(item.id))
const previewCover = () => {
  if (work.value?.cover_url) window.open(work.value.cover_url, '_blank')
}

onMounted(async () => {
  if (!worksStore.works.length) await worksStore.init()
  await load()
})

watch(workKey, load)
</script>

<template>
  <div class="flex min-h-screen flex-col bg-white px-4 pb-24 pt-12 max-sm:pb-20 max-sm:pt-10">
    <!-- 目录：独立于内容列，固定在左侧空白区，不挤占正文宽度；<1240 隐藏 -->
    <aside
      v-if="toc.length"
      class="fixed left-[max(24px,calc(50vw_-_610px))] top-24 hidden max-h-[calc(100vh_-_12rem)] w-[180px] overflow-y-auto border-r border-stone-100 pr-4 min-[1240px]:block"
    >
      <p class="mb-2.5 text-[11px] font-bold tracking-[0.16em] text-stone-400">目录</p>
      <a
        v-for="item in toc"
        :key="item.id"
        :class="[
          'block w-full cursor-pointer text-left text-[11px] leading-[1.9] text-stone-400 transition-colors hover:text-stone-800',
          item.level === 3 ? 'pl-2.5' : ''
        ]"
        role="button"
        tabindex="0"
        @click="scrollTo(item.id)"
        @keydown.enter="scrollTo(item.id)"
      >
        {{ item.text }}
      </a>
    </aside>

    <!-- 右侧悬浮操作条：返回 / 复制 / 外链，图标 + hover 提示文本；移动端贴右下角 -->
    <div
      ref="actionsRef"
      class="fixed bottom-4 right-4 z-30 flex flex-col gap-2 min-[1240px]:bottom-10 min-[1240px]:right-[max(24px,calc(50vw_-_610px))] min-[1240px]:gap-2.5"
    >
      <button
        type="button"
        class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
        @click="goBack"
      >
        <IconBack />
        <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">作品列表</span>
      </button>
      <button
        type="button"
        class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
        @click="copyLink"
      >
        <IconCopy />
        <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">复制链接</span>
      </button>
      <template v-if="work">
        <a
          v-if="work.link_url"
          :href="work.link_url"
          target="_blank"
          rel="noopener"
          class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
        >
          <IconLink />
          <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">推荐链接</span>
        </a>
        <a
          v-if="work.code_url"
          :href="work.code_url"
          target="_blank"
          rel="noopener"
          class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
        >
          <IconGithub />
          <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">Github地址</span>
        </a>
        <a
          v-if="work.codepen_url"
          :href="work.codepen_url"
          target="_blank"
          rel="noopener"
          class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
        >
          <IconCodepen />
          <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">在线代码</span>
        </a>
        <button
          v-if="contentPath"
          type="button"
          class="group relative inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-full border-0 bg-white p-0 text-stone-600 opacity-0 shadow-[0_2px_8px_rgba(0,0,0,0.06)] transition-colors hover:bg-stone-100 hover:text-stone-800 [&>svg]:h-4 [&>svg]:w-4"
          @click="openContent"
        >
          <IconSkip />
          <span class="pointer-events-none absolute right-full top-1/2 mr-2.5 -translate-y-1/2 whitespace-nowrap rounded-md bg-stone-800 px-2 py-1 text-[11px] font-normal tracking-normal text-white opacity-0 transition-opacity group-hover:opacity-100">打开内容</span>
        </button>
      </template>
    </div>

    <div class="mx-auto w-full max-w-[780px]">
      <!-- 骨架 -->
      <div v-if="loading">
        <div class="mb-6 aspect-video w-full animate-pulse rounded-xl bg-stone-100"></div>
        <div class="mb-3 h-3 w-60 animate-pulse rounded-md bg-stone-100"></div>
        <div class="mb-3 h-3 w-full animate-pulse rounded-md bg-stone-100"></div>
        <div class="mb-3 h-3 w-full animate-pulse rounded-md bg-stone-100"></div>
      </div>

      <article v-else-if="work">
        <figure v-if="work.cover_url" class="group mx-auto mb-8 w-fit overflow-hidden rounded-xl bg-stone-100">
          <img
            :src="work.cover_url"
            :alt="work.name"
            loading="lazy"
            class="block max-h-[380px] w-auto max-w-full cursor-zoom-in transition-transform duration-[400ms] ease-out group-hover:scale-[1.015]"
            @click="previewCover"
          />
        </figure>

        <header class="border-b border-stone-200 pb-6">
          <h1 class="text-2xl font-extrabold leading-[1.4] tracking-[0.02em] text-stone-800 max-sm:text-xl">
            {{ work.name }}
          </h1>
          <div class="mt-3.5 flex flex-wrap items-center gap-2.5 text-[11px] text-stone-400">
            <span v-if="work.date" class="inline-flex items-center">
              <IconDate class="mr-1 relative -top-[1px]" />{{ work.date }}
            </span>
            <span
              v-for="tag in work.tags || []"
              :key="tag"
              class="rounded bg-stone-100 px-2 py-px text-[11px] text-stone-700"
            >{{ tag }}</span>
          </div>
        </header>

        <div class="pt-7">
          <MarkdownBody :content="work.info_md" @rendered="({ toc: list }) => (toc = list)" />
        </div>

        <nav v-if="prevWork || nextWork" class="mt-16 flex justify-between gap-4 border-t border-stone-200 pt-6">
          <button
            v-if="prevWork"
            type="button"
            class="group flex max-w-[46%] cursor-pointer flex-col gap-1 border-0 bg-transparent p-0 text-left"
            @click="goWork(prevWork)"
          >
            <span class="text-[10px] font-bold tracking-[0.14em] text-stone-400">← 上一个</span>
            <span class="truncate text-xs font-bold text-stone-600 transition-colors group-hover:text-stone-800">{{ prevWork.name }}</span>
          </button>
          <span v-else></span>
          <button
            v-if="nextWork"
            type="button"
            class="group ml-auto flex max-w-[46%] cursor-pointer flex-col gap-1 border-0 bg-transparent p-0 text-right"
            @click="goWork(nextWork)"
          >
            <span class="text-[10px] font-bold tracking-[0.14em] text-stone-400">下一个 →</span>
            <span class="truncate text-xs font-bold text-stone-600 transition-colors group-hover:text-stone-800">{{ nextWork.name }}</span>
          </button>
        </nav>
      </article>

      <div v-else class="flex flex-col items-start gap-4 py-10 text-[13px] text-stone-400">
        <p>作品不存在或已下线</p>
        <button
          type="button"
          class="inline-flex cursor-pointer items-center gap-1 rounded-full border border-stone-200 bg-white px-3 py-1.5 text-[11px] font-bold tracking-[0.12em] text-stone-500 transition-colors hover:border-stone-400 hover:text-stone-800"
          @click="goBack"
        >
          返回作品列表
        </button>
      </div>
    </div>
  </div>
</template>
