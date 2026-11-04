<template>
  <div class="admin-works grid min-h-screen grid-cols-1 grid-rows-[56px_1fr] bg-stone-100 font-sans text-stone-800 antialiased">
    <!-- ========== TOP NAV ========== -->
    <nav class="relative col-span-full flex h-14 items-center justify-center border-b border-stone-200 bg-white px-6 max-md:px-3.5">
      <button
        class="absolute left-6 inline-flex h-9 w-9 shrink-0 cursor-pointer items-center justify-center rounded-lg border-0 bg-transparent transition-colors hover:bg-stone-100 max-md:left-3.5"
        aria-label="菜单"
        @click="toggleDrawer"
      >
        <svg class="h-5 w-5 text-stone-800" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <line x1="3" y1="12" x2="21" y2="12" /><line x1="3" y1="6" x2="21" y2="6" /><line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      </button>
      <div class="inline-flex shrink-0 justify-center gap-0.5 rounded-lg bg-stone-100 p-[3px]">
        <button
          class="flex cursor-pointer items-center gap-1.5 whitespace-nowrap rounded-md border-0 px-3.5 py-[5px] text-[13px] font-medium transition-colors max-md:px-3 max-md:text-xs"
          :class="activeTab === 'editor' ? 'bg-white text-stone-800 shadow-[0_1px_3px_rgba(0,0,0,0.06)]' : 'bg-transparent text-stone-600 hover:text-stone-800'"
          @click="switchTab('editor')"
        >
          <svg class="h-3.5 w-3.5 max-md:hidden" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
            <path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z" />
          </svg>
          编辑
        </button>
        <button
          class="flex cursor-pointer items-center gap-1.5 whitespace-nowrap rounded-md border-0 px-3.5 py-[5px] text-[13px] font-medium transition-colors max-md:px-3 max-md:text-xs"
          :class="activeTab === 'list' ? 'bg-white text-stone-800 shadow-[0_1px_3px_rgba(0,0,0,0.06)]' : 'bg-transparent text-stone-600 hover:text-stone-800'"
          @click="switchTab('list')"
        >
          <svg class="h-3.5 w-3.5 max-md:hidden" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" /><line x1="16" y1="2" x2="16" y2="6" /><line x1="8" y1="2" x2="8" y2="6" /><line x1="3" y1="10" x2="21" y2="10" />
          </svg>
          列表
          <span class="rounded bg-stone-200 px-1.5 py-px text-[11px] font-semibold text-stone-700">{{ listCount }}</span>
        </button>
      </div>
    </nav>

    <!-- ========== DRAWER BACKDROP ========== -->
    <div
      class="fixed inset-0 z-40 bg-[rgba(28,25,23,0.4)] backdrop-blur-[2px] transition-opacity duration-[250ms]"
      :class="drawerOpen ? 'pointer-events-auto opacity-100' : 'pointer-events-none opacity-0'"
      @click="toggleDrawer"
    ></div>

    <!-- ========== SIDEBAR ========== -->
    <aside
      class="fixed left-1/2 top-1/2 z-50 flex max-h-[80vh] w-[300px] -translate-x-1/2 -translate-y-1/2 flex-col gap-5 overflow-y-auto rounded-2xl bg-white px-4 py-6 shadow-[0_20px_60px_rgba(0,0,0,0.15)] transition-[opacity,transform,visibility] duration-200 max-md:w-[min(300px,88vw)]"
      :class="drawerOpen ? 'visible scale-100 opacity-100' : 'invisible scale-95 opacity-0'"
    >
      <div class="flex flex-col items-center border-b border-stone-200 pb-5 text-center">
        <div class="mb-2.5 flex h-16 w-16 items-center justify-center rounded-full bg-stone-800 text-lg font-semibold text-white">{{ avatarInitials }}</div>
        <div class="text-sm font-semibold text-stone-800">{{ profile?.username || 'Admin' }}</div>
        <div class="mt-0.5 text-xs text-stone-400">{{ authStore.user?.email || '' }}</div>
        <div class="mt-2 px-1 text-xs leading-relaxed text-stone-600">前端工程师，关注 CSS 动画与交互体验</div>
      </div>

      <div class="grid grid-cols-2 gap-1.5">
        <div class="rounded-[10px] border border-stone-100 bg-stone-50 px-2 py-2.5 text-center">
          <div class="text-lg font-bold text-stone-800">{{ stats.total }}</div>
          <div class="mt-0.5 text-[11px] text-stone-400">作品总数</div>
        </div>
        <div class="rounded-[10px] border border-stone-100 bg-stone-50 px-2 py-2.5 text-center">
          <div class="text-lg font-bold text-stone-800">{{ stats.published }}</div>
          <div class="mt-0.5 text-[11px] text-stone-400">已发布</div>
        </div>
        <div class="rounded-[10px] border border-stone-100 bg-stone-50 px-2 py-2.5 text-center">
          <div class="text-lg font-bold text-stone-800">{{ stats.withCover }}</div>
          <div class="mt-0.5 text-[11px] text-stone-400">有封面</div>
        </div>
        <div class="rounded-[10px] border border-stone-100 bg-stone-50 px-2 py-2.5 text-center">
          <div class="text-lg font-bold text-stone-800">{{ stats.vueDemo }}</div>
          <div class="mt-0.5 text-[11px] text-stone-400">Vue Demo</div>
        </div>
      </div>

      <div class="mt-auto border-t border-stone-200 pt-4">
        <button
          class="flex w-full cursor-pointer items-center justify-center gap-1.5 rounded-lg border border-stone-200 bg-transparent p-[9px] text-[13px] text-stone-600 transition-colors hover:border-red-200 hover:bg-red-50 hover:text-red-600"
          @click="logout"
        >
          <svg class="h-3.5 w-3.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" /><polyline points="16 17 21 12 16 7" /><line x1="21" y1="12" x2="9" y2="12" />
          </svg>
          退出登录
        </button>
      </div>
    </aside>

    <!-- ========== MAIN ========== -->
    <main class="overflow-y-auto bg-stone-100">
      <WorksEditor
        v-show="activeTab === 'editor'"
        ref="editorRef"
        :saving="saving"
        @save-start="saving = true"
        @save-end="saving = false"
        @saved="onSaved"
      />

      <WorksList
        v-show="activeTab === 'list'"
        ref="listRef"
        @edit="onEditWork"
        @create="onCreateNew"
        @toggle-publish="onTogglePublish"
        @remove="onRemoveWork"
        @count-change="listCount = $event"
      />
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/stores/auth'
import { upsertWork, deleteWork, fetchWorksStats } from '@/api/works'
import WorksEditor from './WorksEditor.vue'
import WorksList from './WorksList.vue'

const router = useRouter()
const authStore = useAuthStore()

const activeTab = ref('editor')
const drawerOpen = ref(false)
const saving = ref(false)
const profile = ref(null)
const stats = ref({ total: 0, published: 0, withCover: 0, vueDemo: 0 })
const listCount = ref(0)
const editorRef = ref(null)
const listRef = ref(null)

const avatarInitials = computed(() => {
  const name = profile.value?.username || authStore.user?.email || 'A'
  return name.slice(0, 2).toUpperCase()
})

function switchTab(tab) {
  activeTab.value = tab
}

function toggleDrawer() {
  drawerOpen.value = !drawerOpen.value
}

async function loadStats() {
  try {
    stats.value = await fetchWorksStats()
  } catch (e) {
    console.error('[stats]', e)
  }
}

async function loadProfile() {
  if (!authStore.user?.id) return
  const { data } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', authStore.user.id)
    .single()
  profile.value = data
}

async function logout() {
  await authStore.signOut()
  router.push('/login')
}

function onCreateNew() {
  editorRef.value?.resetForm()
  activeTab.value = 'editor'
}

function onEditWork(work) {
  editorRef.value?.editWork(work)
  activeTab.value = 'editor'
}

async function onSaved() {
  // 静默刷新：已有列表数据时不显示"加载中"，避免切回列表时整页重置
  await Promise.all([loadStats(), listRef.value?.loadData({ silent: true })])
  activeTab.value = 'list'
}

async function onTogglePublish(work) {
  const willPublish = !work.is_published
  try {
    await upsertWork({ ...work, is_published: willPublish })
    toast.success(willPublish ? '已发布' : '已取消发布')
    // 只翻转该行开关状态，不重拉整页：保留页码、筛选与滚动位置
    listRef.value?.applyPublished(work.id, willPublish)
    await loadStats()
  } catch (e) {
    console.error(e)
    toast.error('更新失败: ' + (e.message || e))
  }
}

async function onRemoveWork(work) {
  if (!window.confirm(`确定删除「${work.name}」吗？`)) return
  try {
    await deleteWork(work.id)
    toast.success('删除成功')
    // 只移除该行，不重拉整页：保留页码、筛选与滚动位置；删空当前页时内部回上一页
    listRef.value?.removeRow(work.id)
    await loadStats()
  } catch (e) {
    console.error(e)
    toast.error('删除失败: ' + (e.message || e))
  }
}

onMounted(async () => {
  await Promise.all([loadStats(), loadProfile()])
})
</script>

<style scoped>
/*
 * tailwind.config.js 关闭了 preflight，缺少 border 重置，
 * 导致 border / border-b 等工具类只有宽度没有线型而不可见。
 * 这里只在后台根节点内补齐等价的两条声明，不影响前台页面。
 */
.admin-works :deep(*),
.admin-works :deep(*::before),
.admin-works :deep(*::after) {
  border-width: 0;
  border-style: solid;
}
</style>
