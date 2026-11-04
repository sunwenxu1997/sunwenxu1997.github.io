<template>
  <div class="min-h-full bg-white">
    <div class="w-full overflow-hidden">
      <!-- 搜索 + 新建（同一行，按钮贴右） -->
      <div class="flex items-center gap-2.5 px-8 py-3 max-md:px-3.5 max-md:py-2.5">
        <div class="relative min-w-0 max-w-[280px] flex-1 max-md:max-w-none">
          <Search class="absolute left-2.5 top-1/2 h-[13px] w-[13px] -translate-y-1/2 text-stone-400" :size="13" />
          <input
            v-model="searchInput"
            class="box-border w-full rounded-lg border border-stone-200 bg-stone-50 py-1.5 pl-[30px] pr-2.5 text-[13px] text-stone-800 outline-none transition-colors placeholder:text-stone-400 focus:border-stone-700"
            placeholder="搜索列表..."
          />
        </div>
        <button
          class="ml-auto shrink-0 cursor-pointer rounded-lg bg-stone-800 px-4 py-[7px] text-[13px] font-medium text-white transition-colors hover:bg-stone-900 max-md:px-3 max-md:py-1.5 max-md:text-xs"
          @click="$emit('create')"
        >
          + 新建
        </button>
      </div>
      <div class="flex flex-wrap gap-1 px-8 py-2 max-md:px-3.5 max-md:py-1.5">
        <button
          class="cursor-pointer whitespace-nowrap rounded-md border px-3 py-[5px] text-xs transition-colors max-md:px-2.5 max-md:py-1 max-md:text-[11px]"
          :class="activeTags.length === 0 ? 'border-stone-800 bg-stone-800 text-white' : 'border-stone-200 bg-white text-stone-600 hover:bg-stone-100'"
          @click="activeTags = []"
        >
          All
        </button>
        <button
          v-for="tag in allTags"
          :key="tag"
          class="cursor-pointer whitespace-nowrap rounded-md border px-3 py-[5px] text-xs transition-colors max-md:px-2.5 max-md:py-1 max-md:text-[11px]"
          :class="activeTags.includes(tag) ? 'border-stone-800 bg-stone-800 text-white' : 'border-stone-200 bg-white text-stone-600 hover:bg-stone-100'"
          @click="toggleTag(tag)"
        >
          {{ tag }}
        </button>
      </div>

      <!-- list -->
      <div v-if="loading" class="py-10 text-center text-sm text-stone-400">加载中...</div>
      <div v-else-if="works.length === 0" class="py-10 text-center text-sm text-stone-400">暂无数据</div>
      <div v-else>
        <div
          v-for="work in works"
          :key="work.id"
          class="work-row relative grid grid-cols-[28px_96px_1fr_auto] items-stretch gap-3 px-8 py-3 transition-colors hover:bg-stone-50 max-md:grid-cols-[64px_1fr] max-md:px-3.5 max-md:py-3"
          :class="{
            'bg-stone-50 opacity-50': draggedId === work.id,
            'drop-before': dropTargetId === work.id && dropPosition === 'before',
            'drop-after': dropTargetId === work.id && dropPosition === 'after'
          }"
          :draggable="canSort && draggedId === work.id"
          @dragstart="onDragStart($event, work.id)"
          @dragover.prevent="onDragOver($event, work.id)"
          @drop="onDrop($event, work.id)"
          @dragend="onDragEnd"
        >
          <button
            class="inline-flex h-7 w-7 shrink-0 items-center justify-center self-center rounded-md border-0 bg-transparent text-stone-400 transition-colors hover:bg-stone-100 hover:text-stone-800 active:cursor-grabbing max-md:hidden"
            :class="canSort ? 'cursor-grab' : 'cursor-not-allowed opacity-40'"
            aria-label="拖拽排序"
            @mousedown="onDragHandleMouseDown"
          >
            <GripVertical :size="14" />
          </button>
          <!-- 封面：高度跟随行内信息，绝对定位的 img 不会反向撑高行 -->
          <div class="relative h-full w-full overflow-hidden rounded-md border border-stone-200 bg-stone-50 max-md:h-10 max-md:self-center">
            <img class="absolute inset-0 h-full w-full object-cover" :src="work.cover_url || placeholderCover" alt="" />
          </div>
          <div class="min-w-0 self-center">
            <div class="truncate text-sm font-medium text-stone-800 max-md:text-[13px]">{{ work.name }}</div>
            <div class="mt-1 flex items-center gap-2.5 text-xs text-stone-400 max-md:flex-wrap max-md:gap-1.5">
              <span>{{ work.slug }}</span>
              <span>{{ work.date }}</span>
            </div>
            <div v-if="work.tags && work.tags.length" class="row-tags mt-1.5 flex gap-1 overflow-x-auto whitespace-nowrap">
              <span
                v-for="tag in work.tags"
                :key="tag"
                class="shrink-0 whitespace-nowrap rounded bg-stone-100 px-2 py-px text-[11px] text-stone-700"
              >{{ tag }}</span>
            </div>
          </div>
          <div class="flex shrink-0 items-center gap-2 self-center max-md:col-span-full max-md:justify-end max-md:gap-1.5 max-md:border-t max-md:border-dashed max-md:border-stone-100 max-md:pt-2">
            <div
              class="relative h-[18px] w-[34px] shrink-0 cursor-pointer rounded-full transition-colors"
              :class="work.is_published ? 'bg-stone-800' : 'bg-stone-300'"
              @click="$emit('toggle-publish', work)"
            >
              <div
                class="absolute left-0.5 top-0.5 h-3.5 w-3.5 rounded-full bg-white shadow-[0_1px_2px_rgba(0,0,0,0.1)] transition-transform"
                :class="work.is_published ? 'translate-x-4' : ''"
              ></div>
            </div>
            <button
              class="group inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-md border-0 bg-transparent transition-colors hover:bg-stone-100"
              title="编辑"
              @click="$emit('edit', work)"
            >
              <Pencil :size="15" class="text-stone-400 transition-colors group-hover:text-stone-800" />
            </button>
            <button
              class="group inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-md border-0 bg-transparent transition-colors hover:bg-red-50"
              title="删除"
              @click="$emit('remove', work)"
            >
              <Trash2 :size="15" class="text-stone-400 transition-colors group-hover:text-red-600" />
            </button>
            <button
              class="group inline-flex h-8 w-8 cursor-pointer items-center justify-center rounded-md border-0 bg-transparent transition-colors hover:bg-stone-100"
              title="打开详情"
              @click="openWorkLink(work)"
            >
              <ExternalLink :size="15" class="text-stone-400 transition-colors group-hover:text-stone-800" />
            </button>
          </div>
        </div>
      </div>

      <!-- pagination -->
      <div class="flex items-center justify-between gap-3 px-8 py-3 max-md:flex-col max-md:items-stretch max-md:gap-2 max-md:px-3.5">
        <div class="flex items-center gap-1.5 max-md:justify-center">
          <span class="text-[13px] text-stone-600">每页</span>
          <select
            class="cursor-pointer rounded-md border border-stone-200 bg-stone-50 px-2 py-1 text-[13px] text-stone-700 outline-none"
            :value="pageSize"
            @change="onPageSizeChange($event.target.value)"
          >
            <option :value="10">10</option>
            <option :value="20">20</option>
            <option :value="50">50</option>
          </select>
          <span class="text-[13px] text-stone-600">条</span>
        </div>
        <div class="flex items-center gap-3 max-md:justify-between max-md:gap-2">
          <button
            class="cursor-pointer whitespace-nowrap rounded-lg border border-stone-200 bg-transparent px-4 py-2 text-[13px] text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800 disabled:cursor-not-allowed disabled:opacity-50 max-md:flex-1 max-md:px-2 max-md:text-xs"
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            上一页
          </button>
          <span class="whitespace-nowrap text-center text-[13px] text-stone-600 max-md:text-xs">
            第 {{ currentPage }} / {{ totalPages }} 页<span class="max-md:hidden">（共 {{ total }} 条）</span>
          </span>
          <button
            class="cursor-pointer whitespace-nowrap rounded-lg border border-stone-200 bg-transparent px-4 py-2 text-[13px] text-stone-600 transition-colors hover:bg-stone-100 hover:text-stone-800 disabled:cursor-not-allowed disabled:opacity-50 max-md:flex-1 max-md:px-2 max-md:text-xs"
            :disabled="currentPage === totalPages"
            @click="currentPage++"
          >
            下一页
          </button>
        </div>
      </div>

      <div v-if="!canSort && works.length" class="px-8 py-2.5 text-center text-xs text-stone-400 max-md:px-3.5">
        搜索或筛选状态下暂不支持拖拽排序
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { Search, GripVertical, Pencil, Trash2, ExternalLink } from 'lucide-vue-next'
import { fetchWorksPage, bulkUpdateSortWeights } from '@/api/works'

const emit = defineEmits(['edit', 'create', 'toggle-publish', 'remove', 'count-change'])

const router = useRouter()

const placeholderCover = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'

// ====== 分页 & 筛选状态 ======
const works = ref([])
const total = ref(0)
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)

const searchInput = ref('')  // 输入框绑定（带防抖）
const search = ref('')        // 实际查询使用的关键词
const activeTags = ref([])

const draggedId = ref(null)
const dropTargetId = ref(null)
const dropPosition = ref('after')

let searchTimer = null

// 搜索防抖 300ms，避免每次按键都请求接口
watch(searchInput, (val) => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    search.value = val
  }, 300)
})

const totalPages = computed(() => Math.ceil(total.value / pageSize.value) || 1)

const canSort = computed(() => activeTags.value.length === 0 && !search.value.trim())

// 从当前页数据中收集标签
const allTags = computed(() => {
  const set = new Set()
  works.value.forEach((w) => (w.tags || []).forEach((t) => set.add(t)))
  return Array.from(set).sort()
})

// 搜索词或标签变化 → 重置到第1页
watch([search, activeTags], () => {
  currentPage.value = 1
}, { deep: true })

// 页码 / 搜索 / 标签任一变化 → 重新请求
watch([currentPage, search, activeTags], () => {
  loadData()
}, { deep: true })

function toggleTag(tag) {
  const idx = activeTags.value.indexOf(tag)
  if (idx === -1) {
    activeTags.value.push(tag)
  } else {
    activeTags.value.splice(idx, 1)
  }
}

// 通知父组件当前总数
watch(total, (val) => {
  emit('count-change', val)
}, { immediate: true })

// ====== 数据请求 ======
// 请求序号：连续点翻页会并发多个请求，旧响应后到会覆盖新页数据（表现为相邻两页内容重复）
let loadSeq = 0

/**
 * @param {Object} [options]
 * @param {boolean} [options.silent] - 静默刷新：已有数据时不显示"加载中"，避免列表高度塌陷、滚动位置丢失
 */
async function loadData({ silent = false } = {}) {
  const seq = ++loadSeq
  if (!silent || !works.value.length) loading.value = true
  try {
    const res = await fetchWorksPage({
      page: currentPage.value,
      pageSize: pageSize.value,
      search: search.value.trim(),
      tags: activeTags.value
    })
    // 已有更新的请求发出，丢弃这次结果
    if (seq !== loadSeq) return

    // 当前页已超出有效范围（如删掉最后一页唯一一条）：回退页码，交给 watch 重新请求
    const maxPage = Math.ceil(res.total / pageSize.value) || 1
    if (currentPage.value > maxPage) {
      currentPage.value = maxPage
      return
    }

    works.value = res.data
    total.value = res.total
  } catch (e) {
    if (seq !== loadSeq) return
    console.error(e)
    toast.error('加载失败: ' + (e.message || e))
  } finally {
    if (seq === loadSeq) loading.value = false
  }
}

function onPageSizeChange(val) {
  pageSize.value = Number(val)
  currentPage.value = 1
  loadData()
}

/**
 * 局部更新某行的发布状态（列表开关用），不重载整页
 * @param {string} id - works_meta.id
 * @param {boolean} isPublished - 新的发布状态
 */
function applyPublished(id, isPublished) {
  const row = works.value.find((w) => w.id === id)
  if (row) row.is_published = isPublished
}

/**
 * 局部移除某行，不重载整页
 * 当前页被删空且下面还有数据时回上一页（currentPage 变化会触发 watch 自动重拉）
 * @param {string} id - works_meta.id
 */
function removeRow(id) {
  const idx = works.value.findIndex((w) => w.id === id)
  if (idx === -1) return
  works.value.splice(idx, 1)
  total.value = Math.max(0, total.value - 1)
  if (!works.value.length && total.value > 0 && currentPage.value > 1) {
    currentPage.value -= 1
  }
}

/** 打开作品详情页（新标签页），用 router 解析以兼容 base 路径 */
function openWorkLink(work) {
  if (!work.id) return
  const { href } = router.resolve({ path: `/work/${work.id}` })
  window.open(href, '_blank', 'noopener,noreferrer')
}

// ====== Drag & Drop ======
function onDragHandleMouseDown(evt) {
  if (!canSort.value) return
  const row = evt.currentTarget.closest('.work-row')
  if (row) row.setAttribute('draggable', 'true')
}

function onDragStart(evt, id) {
  draggedId.value = id
  if (evt.dataTransfer) {
    evt.dataTransfer.effectAllowed = 'move'
    evt.dataTransfer.setData('text/plain', String(id))
  }
}

function onDragOver(evt, targetId) {
  if (!draggedId.value || draggedId.value === targetId) {
    dropTargetId.value = null
    return
  }
  const rect = evt.currentTarget.getBoundingClientRect()
  const mid = rect.top + rect.height / 2
  dropTargetId.value = targetId
  dropPosition.value = evt.clientY < mid ? 'before' : 'after'
}

async function onDrop(evt, targetId) {
  evt.preventDefault()
  if (!draggedId.value || draggedId.value === targetId) {
    resetDragState()
    return
  }
  const sourceId = draggedId.value
  const list = [...works.value]
  const fromIndex = list.findIndex((w) => w.id === sourceId)
  const targetIndex = list.findIndex((w) => w.id === targetId)
  if (fromIndex === -1 || targetIndex === -1) {
    resetDragState()
    return
  }

  const [moved] = list.splice(fromIndex, 1)
  let insertIndex = targetIndex
  if (fromIndex < targetIndex) insertIndex = targetIndex - 1
  if (dropPosition.value === 'after') insertIndex += 1
  list.splice(insertIndex, 0, moved)

  try {
    await persistOrder(list, insertIndex)
    await loadData()
  } catch (e) {
    console.error(e)
    toast.error('排序保存失败: ' + (e.message || e))
  } finally {
    resetDragState()
  }
}

function onDragEnd() {
  resetDragState()
}

function resetDragState() {
  draggedId.value = null
  dropTargetId.value = null
  dropPosition.value = 'after'
}

async function persistOrder(orderedList, movedIndex) {
  const prev = orderedList[movedIndex - 1]
  const next = orderedList[movedIndex + 1]
  const moved = orderedList[movedIndex]

  let newWeight
  if (prev && next) {
    newWeight = (prev.sort_weight + next.sort_weight) / 2
  } else if (prev) {
    newWeight = prev.sort_weight - 1
  } else if (next) {
    newWeight = next.sort_weight + 1
  } else {
    newWeight = 0
  }

  // 精度过低时重新分配整数权重，避免浮点溢出
  if (prev && next && Math.abs(prev.sort_weight - next.sort_weight) < 0.001) {
    const base = orderedList.length * 10
    for (let i = 0; i < orderedList.length; i++) {
      const w = orderedList[i]
      await bulkUpdateSortWeights([{ id: w.id, sort_weight: base - i }])
    }
    return
  }

  await bulkUpdateSortWeights([{ id: moved.id, sort_weight: newWeight }])
}

onMounted(() => {
  loadData()
})

defineExpose({ loadData, applyPublished, removeRow })
</script>

<style scoped>
/* tailwind 无法表达的伪元素：横向滚动条美化 + 拖拽插入指示线 */
.row-tags {
  scrollbar-width: thin;
  scrollbar-color: #d6d3d1 transparent;
}
.row-tags::-webkit-scrollbar { height: 3px; }
.row-tags::-webkit-scrollbar-thumb { background: #d6d3d1; border-radius: 2px; }
.row-tags::-webkit-scrollbar-track { background: transparent; }

.work-row.drop-before::before,
.work-row.drop-after::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  height: 2px;
  background: #292524;
  z-index: 2;
}
.work-row.drop-before::before { top: -1px; }
.work-row.drop-after::after { bottom: -1px; }
</style>
