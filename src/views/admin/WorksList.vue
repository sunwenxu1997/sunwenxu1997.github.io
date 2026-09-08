<template>
  <div class="panel">
    <div class="panel-header">
      <div>
        <h1 class="panel-title">全部作品</h1>
        <p class="panel-desc">点击编辑跳转至编辑页</p>
      </div>
      <button class="btn-primary" @click="$emit('create')">+ 新建</button>
    </div>

    <div class="card">
      <!-- filter -->
      <div class="filter-bar">
        <div class="filter-bar-search">
          <Search class="search-icon" :size="13" />
          <input v-model="searchInput" class="input" placeholder="搜索列表..." />
        </div>
      </div>
      <div class="filter-tags-row">
        <button class="filter-btn" :class="{ active: activeTags.length === 0 }" @click="activeTags = []">All</button>
        <button
          v-for="tag in allTags"
          :key="tag"
          class="filter-btn"
          :class="{ active: activeTags.includes(tag) }"
          @click="toggleTag(tag)"
        >{{ tag }}</button>
      </div>

      <!-- list -->
      <div v-if="loading" class="empty-state">加载中...</div>
      <div v-else-if="works.length === 0" class="empty-state">暂无数据</div>
      <div v-else class="works-list">
        <div
          v-for="work in works"
          :key="work.id"
          class="work-row"
          :class="{
            dragging: draggedId === work.id,
            'drop-before': dropTargetId === work.id && dropPosition === 'before',
            'drop-after': dropTargetId === work.id && dropPosition === 'after',
            'sort-disabled': !canSort
          }"
          :draggable="canSort && draggedId === work.id"
          @dragstart="onDragStart($event, work.id)"
          @dragover.prevent="onDragOver($event, work.id)"
          @drop="onDrop($event, work.id)"
          @dragend="onDragEnd"
        >
          <button class="drag-handle" aria-label="拖拽排序" @mousedown="onDragHandleMouseDown">
            <GripVertical :size="14" />
          </button>
          <img class="thumb" :src="work.cover_url || placeholderCover" alt="" />
          <div class="row-content">
            <div class="row-title">{{ work.name }}</div>
            <div class="row-meta">
              <span>{{ work.slug }}</span>
              <span>{{ work.date }}</span>
            </div>
            <div v-if="work.tags && work.tags.length" class="row-tags">
              <span v-for="tag in work.tags" :key="tag" class="tag">{{ tag }}</span>
            </div>
          </div>
          <div class="row-right">
            <div class="toggle-track" :class="{ on: work.is_published }" @click="$emit('toggle-publish', work)">
              <div class="toggle-dot"></div>
            </div>
            <button class="icon-btn" title="编辑" @click="$emit('edit', work)">
              <Pencil :size="15" />
            </button>
            <button class="icon-btn danger" title="删除" @click="$emit('remove', work)">
              <Trash2 :size="15" />
            </button>
            <button class="icon-btn" title="打开" @click="openWork(work)">
              <ExternalLink :size="15" />
            </button>
          </div>
        </div>
      </div>

      <!-- pagination -->
      <div class="pagination">
        <div class="page-size-select">
          <span class="page-info">每页</span>
          <select class="page-size-dropdown" :value="pageSize" @change="onPageSizeChange($event.target.value)">
            <option :value="10">10</option>
            <option :value="20">20</option>
            <option :value="50">50</option>
          </select>
          <span class="page-info">条</span>
        </div>
        <div class="page-nav">
          <button class="btn-ghost" :disabled="currentPage === 1" @click="currentPage--">上一页</button>
          <span class="page-info">第 {{ currentPage }} / {{ totalPages }} 页（共 {{ total }} 条）</span>
          <button class="btn-ghost" :disabled="currentPage === totalPages" @click="currentPage++">下一页</button>
        </div>
      </div>

      <div v-if="!canSort && works.length" class="sort-hint">
        搜索或筛选状态下暂不支持拖拽排序
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import { Search, GripVertical, Pencil, Trash2, ExternalLink } from 'lucide-vue-next'
import { fetchWorksPage, bulkUpdateSortWeights } from '@/api/works'

const emit = defineEmits(['edit', 'create', 'toggle-publish', 'remove', 'count-change'])

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
async function loadData() {
  loading.value = true
  try {
    const res = await fetchWorksPage({
      page: currentPage.value,
      pageSize: pageSize.value,
      search: search.value.trim(),
      tags: activeTags.value
    })
    works.value = res.data
    total.value = res.total

    // 自动回退到有效页码（删除最后一页唯一条目时）
    const maxPage = Math.ceil(res.total / pageSize.value) || 1
    if (currentPage.value > maxPage) {
      currentPage.value = maxPage
      // 重新请求正确页码的数据
      const retry = await fetchWorksPage({
        page: currentPage.value,
        pageSize: pageSize.value,
        search: search.value.trim(),
        tags: activeTags.value
      })
      works.value = retry.data
      total.value = retry.total
    }
  } catch (e) {
    console.error(e)
    toast.error('加载失败: ' + (e.message || e))
  } finally {
    loading.value = false
  }
}

function onPageSizeChange(val) {
  pageSize.value = Number(val)
  currentPage.value = 1
  loadData()
}

function openWork(work) {
  const url = work.open_url || work.slug
  if (!url) return
  window.open(url.startsWith('http') ? url : window.location.origin + '/#' + url, '_blank')
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

defineExpose({ loadData })
</script>

<style scoped>
.panel-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px;
}
.panel-title { font-size: 20px; font-weight: 600; color: #292524; }
.panel-desc { font-size: 13px; color: #a8a29e; margin-top: 4px; }

.card { background: #fff; border-radius: 12px; border: 1px solid #e7e5e4; overflow: hidden; }
.input {
  width: 100%; padding: 10px 14px;
  background: #fafaf9; border: 1px solid #e7e5e4; border-radius: 8px;
  font-size: 14px; color: #292524; outline: none; transition: border 0.2s;
  box-sizing: border-box;
}
.input:focus { border-color: #44403c; }
.input::placeholder { color: #a8a29e; }
.btn-primary {
  background: #292524; color: #fff; border: none;
  padding: 9px 22px; border-radius: 8px;
  font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.2s;
}
.btn-primary:hover:not(:disabled) { background: #1c1917; }
.btn-ghost {
  background: transparent; color: #78716c; border: 1px solid #e7e5e4;
  padding: 8px 16px; border-radius: 8px; font-size: 13px;
  cursor: pointer; transition: all 0.15s;
}
.btn-ghost:hover { background: #f5f5f4; color: #292524; }

.toggle-track {
  width: 34px; height: 18px; border-radius: 9px;
  background: #d6d3d1; position: relative; cursor: pointer; transition: background 0.2s;
  flex-shrink: 0;
}
.toggle-track.on { background: #292524; }
.toggle-dot {
  width: 14px; height: 14px; border-radius: 50%; background: #fff;
  position: absolute; top: 2px; left: 2px; transition: transform 0.2s;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}
.toggle-track.on .toggle-dot { transform: translateX(16px); }

.tag {
  font-size: 11px; padding: 2px 8px; border-radius: 4px;
  background: #f5f5f4; color: #57534e; border: 1px solid #e7e5e4;
  white-space: nowrap; cursor: pointer;
}

.empty-state {
  padding: 40px; text-align: center; color: #a8a29e; font-size: 14px;
}
.filter-bar {
  padding: 12px 20px; border-bottom: 1px solid #f5f5f4;
  display: flex; align-items: center; gap: 10px;
}
.filter-bar-search {
  position: relative; flex: 0 0 180px;
}
.filter-bar-search .search-icon {
  position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
  width: 13px; height: 13px; color: #a8a29e;
}
.filter-bar-search .input { padding: 6px 10px 6px 30px; font-size: 13px; }
.filter-tags-row {
  display: flex; gap: 4px; padding: 8px 20px;
  border-bottom: 1px solid #e7e5e4; flex-wrap: wrap;
}
.row-tags {
  display: flex; gap: 4px; margin-top: 6px;
  overflow-x: auto; white-space: nowrap;
  scrollbar-width: thin; scrollbar-color: #d6d3d1 transparent;
}
.row-tags::-webkit-scrollbar { height: 3px; }
.row-tags::-webkit-scrollbar-thumb { background: #d6d3d1; border-radius: 2px; }
.row-tags::-webkit-scrollbar-track { background: transparent; }
.row-tags .tag { cursor: default; flex-shrink: 0; }
.filter-btn {
  padding: 5px 12px; border-radius: 6px; border: 1px solid #e7e5e4;
  background: #fff; font-size: 12px; color: #78716c;
  cursor: pointer; transition: all 0.15s; white-space: nowrap;
}
.filter-btn:hover { background: #f5f5f4; }
.filter-btn.active { background: #292524; color: #fff; border-color: #292524; }

.work-row {
  display: grid;
  grid-template-columns: 28px 48px 1fr auto;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  border-bottom: 1px solid #f5f5f4;
  transition: background 0.15s;
}
.work-row:last-child { border-bottom: none; }
.work-row:hover { background: #fafaf9; }
.drag-handle {
  display: inline-flex; align-items: center; justify-content: center;
  width: 28px; height: 28px;
  border-radius: 6px; border: none; background: transparent;
  cursor: grab; flex-shrink: 0;
  color: #a8a29e; transition: all 0.15s;
}
.drag-handle:hover { background: #f5f5f4; color: #292524; }
.drag-handle:active { cursor: grabbing; }
.drag-handle .lucide { width: 14px; height: 14px; }
.thumb {
  width: 48px; height: 32px; border-radius: 6px;
  object-fit: cover; border: 1px solid #e7e5e4; flex-shrink: 0;
}
.row-content { min-width: 0; }
.row-title {
  font-size: 14px; font-weight: 500; color: #292524;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.row-meta {
  display: flex; align-items: center; gap: 10px;
  font-size: 12px; color: #a8a29e; margin-top: 4px;
}
.row-right {
  display: flex; align-items: center; gap: 8px;
  flex-shrink: 0;
}
.icon-btn {
  width: 32px; height: 32px; border-radius: 6px;
  display: inline-flex; align-items: center; justify-content: center;
  cursor: pointer; transition: all 0.15s; border: none; background: transparent;
}
.icon-btn:hover { background: #f5f5f4; }
.icon-btn.danger:hover { background: #fef2f2; }
.icon-btn .lucide { width: 15px; height: 15px; color: #a8a29e; transition: color 0.15s; }
.icon-btn:hover .lucide { color: #292524; }
.icon-btn.danger:hover .lucide { color: #dc2626; }

.pagination {
  display: flex; align-items: center; justify-content: space-between; gap: 12px;
  padding: 16px 20px; border-top: 1px solid #f5f5f4;
}
.page-size-select { display: flex; align-items: center; gap: 6px; }
.page-size-dropdown {
  padding: 4px 8px; font-size: 13px; color: #57534e;
  background: #fafaf9; border: 1px solid #e7e5e4; border-radius: 6px;
  outline: none; cursor: pointer;
}
.page-nav { display: flex; align-items: center; gap: 12px; }
.page-info { font-size: 13px; color: #78716c; }
.sort-hint {
  padding: 10px 20px; font-size: 12px; color: #a8a29e;
  text-align: center; border-top: 1px solid #f5f5f4;
}

.work-row.dragging { opacity: 0.5; background: #fafaf9; }
.work-row.sort-disabled .drag-handle { opacity: 0.4; cursor: not-allowed; }
.work-row.drop-before,
.work-row.drop-after { position: relative; }
.work-row.drop-before::before,
.work-row.drop-after::after {
  content: ''; position: absolute; left: 0; right: 0; height: 2px;
  background: #292524; z-index: 2;
}
.work-row.drop-before::before { top: -1px; }
.work-row.drop-after::after { bottom: -1px; }

@media (max-width: 767px) {
  .panel-header { flex-direction: column; align-items: flex-start !important; gap: 10px; }
  .drag-handle { display: none; }
  .work-row {
    grid-template-columns: 48px 1fr;
    gap: 12px;
    padding: 12px 14px;
  }
  .row-right {
    grid-column: 1 / -1;
    justify-content: flex-end;
    padding-top: 8px;
    border-top: 1px dashed #f5f5f4;
    gap: 6px;
  }
  .row-meta { gap: 6px; flex-wrap: wrap; }
  .row-title { font-size: 13px; }
  .filter-bar { padding: 10px 14px; }
  .filter-bar-search { flex: 1 1 100%; }
  .filter-tags-row { padding: 6px 14px; }
  .filter-btn { padding: 4px 10px; font-size: 11px; }
}
</style>
