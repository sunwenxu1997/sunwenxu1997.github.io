<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { fetchWorkDetail } from '@/api/works'
import { useWorksStore } from '@/stores/works'
import MarkdownBody from '@/components/markdown/MarkdownBody.vue'
import IconDate from '@/components/icons/date.vue'
import IconGithub from '@/components/icons/github.vue'
import IconLink from '@/components/icons/link.vue'
import IconCodepen from '@/components/icons/codepen.vue'
import IconSkip from '@/components/icons/IconSkip.vue'

const route = useRoute()
const router = useRouter()
const worksStore = useWorksStore()

const work = ref(null)
const loading = ref(true)
const toc = ref([])

/** '/work/anime/xxx' -> '/anime/xxx'（兼容中文被编码的情况） */
const slug = computed(() => {
  const raw = route.params.slug
  const path = Array.isArray(raw) ? raw.join('/') : raw || ''
  try {
    return `/${decodeURIComponent(path)}`
  } catch {
    return `/${path}`
  }
})

const contentPath = computed(() => {
  const item = work.value
  if (!item) return ''
  // 组件作品：打开对应 demo 页面；外部作品：打开 open_url
  if (item.slug && !item.slug.includes('/external')) return item.slug
  return item.open_url || item.code_url || ''
})

const currentIndex = computed(() =>
  worksStore.works.findIndex((item) => item.slug === slug.value)
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
    work.value = await fetchWorkDetail(slug.value)
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
const goWork = (item) => router.push('/work' + encodeURI(item.slug))
const previewCover = () => {
  if (work.value?.cover_url) window.open(work.value.cover_url, '_blank')
}

onMounted(async () => {
  if (!worksStore.works.length) await worksStore.init()
  await load()
})

watch(slug, load)
</script>

<template>
  <div class="detail-page">
    <div class="detail-shell">
      <div class="detail-topbar">
        <button type="button" class="detail-back" @click="goBack">
          <span class="detail-back__arrow">←</span> 作品列表
        </button>
        <button type="button" class="detail-copy" @click="copyLink">复制链接</button>
      </div>

      <div v-if="loading" class="detail-skeleton">
        <div class="detail-skeleton__cover"></div>
        <div class="detail-skeleton__line w-60"></div>
        <div class="detail-skeleton__line w-full"></div>
        <div class="detail-skeleton__line w-full"></div>
      </div>

      <article v-else-if="work" class="detail-article">
        <figure v-if="work.cover_url" class="detail-cover">
          <img
            :src="work.cover_url"
            :alt="work.name"
            loading="lazy"
            @click="previewCover"
          />
        </figure>

        <header class="detail-header">
          <h1 class="detail-title">{{ work.name }}</h1>

          <div class="detail-meta">
            <span v-if="work.date" class="detail-meta__item">
              <IconDate class="mr-1 relative -top-[1px]" />{{ work.date }}
            </span>
            <span v-for="tag in work.tags || []" :key="tag" class="detail-tag">{{ tag }}</span>
          </div>

          <div class="detail-links">
            <a v-if="work.link_url" :href="work.link_url" target="_blank" rel="noopener" title="推荐链接">
              <IconLink />
            </a>
            <a v-if="work.code_url" :href="work.code_url" target="_blank" rel="noopener" title="Github地址">
              <IconGithub />
            </a>
            <a
              v-if="work.codepen_url"
              :href="work.codepen_url"
              target="_blank"
              rel="noopener"
              title="在线代码"
            >
              <IconCodepen />
            </a>
            <button v-if="contentPath" type="button" title="打开内容" @click="openContent">
              <IconSkip />
            </button>
          </div>
        </header>

        <div class="detail-body">
          <MarkdownBody :content="work.info_md" @rendered="({ toc: list }) => (toc = list)" />

          <aside v-if="toc.length" class="detail-toc">
            <p class="detail-toc__title">目录</p>
            <a
              v-for="item in toc"
              :key="item.id"
              :class="['detail-toc__item', `lv-${item.level}`]"
              role="button"
              tabindex="0"
              @click="scrollTo(item.id)"
              @keydown.enter="scrollTo(item.id)"
            >
              {{ item.text }}
            </a>
          </aside>
        </div>

        <nav v-if="prevWork || nextWork" class="detail-nav">
          <button v-if="prevWork" type="button" class="detail-nav__item" @click="goWork(prevWork)">
            <span class="detail-nav__dir">← 上一个</span>
            <span class="detail-nav__name">{{ prevWork.name }}</span>
          </button>
          <span v-else class="detail-nav__placeholder"></span>
          <button
            v-if="nextWork"
            type="button"
            class="detail-nav__item detail-nav__item--right"
            @click="goWork(nextWork)"
          >
            <span class="detail-nav__dir">下一个 →</span>
            <span class="detail-nav__name">{{ nextWork.name }}</span>
          </button>
        </nav>
      </article>

      <div v-else class="detail-empty">
        <p>作品不存在或已下线</p>
        <button type="button" class="detail-copy" @click="goBack">返回作品列表</button>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.detail-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  padding: 3rem 1rem 4rem;
  background: #fff;
}
.detail-shell {
  max-width: 780px;
  margin: 0 auto;
}

/* ---------- 顶部操作条 ---------- */
.detail-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 28px;
}
.detail-back,
.detail-copy {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  border: 1px solid #e7e5e4;
  border-radius: 999px;
  background: #fff;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.12em;
  color: #78716c;
  cursor: pointer;
  transition: color 0.15s, border-color 0.15s;
}
.detail-back:hover,
.detail-copy:hover {
  color: #292524;
  border-color: #a8a29e;
}
.detail-back__arrow {
  font-size: 13px;
  line-height: 1;
}

/* ---------- 骨架 ---------- */
.detail-skeleton__cover {
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 12px;
  background: #f5f5f4;
  margin-bottom: 24px;
  animation: detail-pulse 1.6s ease-in-out infinite;
}
.detail-skeleton__line {
  height: 12px;
  border-radius: 6px;
  background: #f5f5f4;
  margin-bottom: 12px;
  animation: detail-pulse 1.6s ease-in-out infinite;
}
@keyframes detail-pulse {
  50% {
    opacity: 0.5;
  }
}

/* ---------- 封面 ---------- */
.detail-cover {
  margin: 0 0 32px;
  border-radius: 12px;
  overflow: hidden;
  background: #f5f5f4;
}
.detail-cover img {
  display: block;
  width: 100%;
  height: auto;
  cursor: zoom-in;
  transition: transform 0.4s ease;
}
.detail-cover:hover img {
  transform: scale(1.015);
}

/* ---------- 头部信息 ---------- */
.detail-title {
  font-size: 24px;
  font-weight: 800;
  line-height: 1.4;
  color: #292524;
  letter-spacing: 0.02em;
}
.detail-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  margin-top: 14px;
  font-size: 11px;
  color: #a8a29e;
  font-weight: 700;
  letter-spacing: 0.08em;
}
.detail-meta__item {
  display: inline-flex;
  align-items: center;
}
.detail-tag {
  padding: 2px 8px;
  border-radius: 4px;
  background: #f5f5f4;
  border: 1px solid #e7e5e4;
  color: #57534e;
  font-weight: 600;
}
.detail-links {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 14px;
  margin-top: 16px;
  padding-bottom: 24px;
  border-bottom: 1px solid #e7e5e4;
}
/* 与列表保持一致：整体降透明度，当前项恢复 */
.detail-links a,
.detail-links button {
  display: inline-flex;
  align-items: center;
  padding: 0;
  border: none;
  background: none;
  color: #292524;
  cursor: pointer;
  opacity: 1;
  transition: opacity 0.15s;
}
.detail-links:hover a,
.detail-links:hover button {
  opacity: 0.45;
}
.detail-links a:hover,
.detail-links button:hover {
  opacity: 1;
}

/* ---------- 正文 + 目录 ---------- */
.detail-body {
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 40px;
  padding-top: 28px;
}
.detail-toc {
  display: none;
}
.detail-toc__title {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.16em;
  color: #a8a29e;
  margin-bottom: 10px;
}
.detail-toc__item {
  display: block;
  width: 100%;
  padding: 0;
  border: none;
  background: none;
  text-align: left;
  font-family: inherit;
  font-size: 11px;
  line-height: 1.9;
  color: #a8a29e;
  transition: color 0.15s;
  cursor: pointer;
}
.detail-toc__item:hover {
  color: #292524;
}
.detail-toc__item.lv-3 {
  padding-left: 10px;
}

@media (min-width: 1024px) {
  .detail-body {
    grid-template-columns: minmax(0, 1fr) 160px;
  }
  .detail-toc {
    display: block;
    position: sticky;
    top: 2rem;
    align-self: start;
    max-height: calc(100vh - 10rem);
    overflow-y: auto;
    padding-left: 16px;
    border-left: 1px solid #f5f5f4;
  }
}

/* ---------- 上下篇 ---------- */
.detail-nav {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  margin-top: 64px;
  padding-top: 24px;
  border-top: 1px solid #e7e5e4;
}
.detail-nav__item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  max-width: 46%;
  padding: 0;
  border: none;
  background: none;
  text-align: left;
  cursor: pointer;
}
.detail-nav__item--right {
  margin-left: auto;
  text-align: right;
}
.detail-nav__dir {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.14em;
  color: #a8a29e;
}
.detail-nav__name {
  font-size: 12px;
  font-weight: 700;
  color: #57534e;
  transition: color 0.15s;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.detail-nav__item:hover .detail-nav__name {
  color: #292524;
}

/* ---------- 空态 ---------- */
.detail-empty {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 16px;
  padding: 40px 0;
  color: #a8a29e;
  font-size: 13px;
}

@media (max-width: 640px) {
  .detail-page {
    padding: 2.5rem 1rem 3rem;
  }
  .detail-title {
    font-size: 20px;
  }
}
</style>
