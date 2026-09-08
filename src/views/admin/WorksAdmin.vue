<template>
  <div class="admin-works">
    <!-- ========== TOP NAV ========== -->
    <nav class="topnav">
      <button class="hamburger" aria-label="菜单" @click="toggleDrawer">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/>
        </svg>
      </button>
      <div class="topnav-tabs">
        <button class="topnav-tab" :class="{ active: activeTab === 'editor' }" @click="switchTab('editor')">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
            <path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z"/>
          </svg>
          编辑
        </button>
        <button class="topnav-tab" :class="{ active: activeTab === 'list' }" @click="switchTab('list')">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          列表
          <span class="topnav-badge">{{ listCount }}</span>
        </button>
      </div>
    </nav>

    <!-- ========== DRAWER BACKDROP ========== -->
    <div class="drawer-backdrop" :class="{ open: drawerOpen }" @click="toggleDrawer"></div>

    <!-- ========== SIDEBAR ========== -->
    <aside class="sidebar" :class="{ open: drawerOpen }">
      <div class="profile-card">
        <div class="profile-avatar">{{ avatarInitials }}</div>
        <div class="profile-name">{{ profile?.username || 'Admin' }}</div>
        <div class="profile-email">{{ authStore.user?.email || '' }}</div>
        <div class="profile-bio">前端工程师，关注 CSS 动画与交互体验</div>
      </div>

      <div class="sidebar-stats">
        <div class="stat-item"><div class="stat-val">{{ stats.total }}</div><div class="stat-lbl">作品总数</div></div>
        <div class="stat-item"><div class="stat-val">{{ stats.published }}</div><div class="stat-lbl">已发布</div></div>
        <div class="stat-item"><div class="stat-val">{{ stats.withCover }}</div><div class="stat-lbl">有封面</div></div>
        <div class="stat-item"><div class="stat-val">{{ stats.vueDemo }}</div><div class="stat-lbl">Vue Demo</div></div>
      </div>

      <div class="sidebar-footer">
        <button class="btn-logout" @click="logout">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
          退出登录
        </button>
      </div>
    </aside>

    <!-- ========== MAIN ========== -->
    <main class="main">
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
  await Promise.all([loadStats(), listRef.value?.loadData()])
  activeTab.value = 'list'
}

async function onTogglePublish(work) {
  const willPublish = !work.is_published
  try {
    await upsertWork({ ...work, is_published: willPublish })
    toast.success(willPublish ? '已发布' : '已取消发布')
    await Promise.all([loadStats(), listRef.value?.loadData()])
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
    await Promise.all([loadStats(), listRef.value?.loadData()])
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
.admin-works {
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: 56px 1fr;
  min-height: 100vh;
  background: #f5f5f4;
  color: #292524;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
}

/* ===== top nav ===== */
.topnav {
  grid-column: 1 / -1;
  background: #fff;
  border-bottom: 1px solid #e7e5e4;
  padding: 0 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  height: 56px;
}
.hamburger {
  position: absolute;
  left: 24px;
  display: inline-flex;
  width: 36px; height: 36px; border-radius: 8px;
  border: none; background: transparent; cursor: pointer;
  align-items: center; justify-content: center;
  flex-shrink: 0; transition: background 0.15s;
}
.hamburger:hover { background: #f5f5f4; }
.hamburger svg { width: 20px; height: 20px; color: #292524; }

.topnav-tabs {
  display: inline-flex; gap: 2px; justify-content: center;
  background: #f5f5f4; border-radius: 8px; padding: 3px;
  flex-shrink: 0;
}
.topnav-tab {
  padding: 5px 14px; border-radius: 6px; border: none;
  background: transparent; font-size: 13px; font-weight: 500;
  color: #78716c; cursor: pointer; transition: all 0.2s;
  display: flex; align-items: center; gap: 6px; white-space: nowrap;
}
.topnav-tab svg { width: 14px; height: 14px; }
.topnav-tab.active {
  background: #fff; color: #292524;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}
.topnav-tab:not(.active):hover { color: #292524; }
.topnav-badge {
  background: #e7e5e4; color: #57534e;
  font-size: 11px; font-weight: 600;
  padding: 1px 6px; border-radius: 4px;
}

/* ===== sidebar ===== */
.sidebar {
  position: fixed;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%) scale(0.95);
  padding: 24px 16px;
  background: #fff;
  border-radius: 16px;
  display: flex; flex-direction: column; gap: 20px;
  width: 300px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0,0,0,0.15);
  z-index: 50;
  visibility: hidden;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s ease, transform 0.2s ease, visibility 0.2s;
}
.sidebar.open {
  visibility: visible;
  opacity: 1;
  pointer-events: auto;
  transform: translate(-50%, -50%) scale(1);
}
.profile-card {
  display: flex; flex-direction: column;
  align-items: center; text-align: center;
  padding-bottom: 20px; border-bottom: 1px solid #e7e5e4;
}
.profile-avatar {
  width: 64px; height: 64px; border-radius: 50%;
  background: #292524;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-size: 18px; font-weight: 600;
  margin-bottom: 10px;
}
.profile-name { font-size: 14px; font-weight: 600; color: #292524; }
.profile-email { font-size: 12px; color: #a8a29e; margin-top: 2px; }
.profile-bio {
  font-size: 12px; color: #78716c; margin-top: 8px;
  line-height: 1.6; padding: 0 4px;
}
.sidebar-stats {
  display: grid; grid-template-columns: 1fr 1fr; gap: 6px;
}
.stat-item {
  background: #fafaf9; border: 1px solid #f5f5f4;
  border-radius: 10px; padding: 10px 8px; text-align: center;
}
.stat-val { font-size: 18px; font-weight: 700; color: #292524; }
.stat-lbl { font-size: 11px; color: #a8a29e; margin-top: 2px; }

.sidebar-footer {
  margin-top: auto; padding-top: 16px; border-top: 1px solid #e7e5e4;
}
.btn-logout {
  width: 100%; display: flex; align-items: center; justify-content: center; gap: 6px;
  padding: 9px; border-radius: 8px; border: 1px solid #e7e5e4;
  background: transparent; color: #78716c; font-size: 13px;
  cursor: pointer; transition: all 0.15s;
}
.btn-logout:hover { background: #fef2f2; color: #dc2626; border-color: #fecaca; }
.btn-logout svg { width: 14px; height: 14px; }

/* ===== main ===== */
.main {
  padding: 24px 32px; overflow-y: auto; background: #f5f5f4;
}

/* ===== drawer backdrop ===== */
.drawer-backdrop {
  position: fixed; inset: 0;
  background: rgba(28, 25, 23, 0.4);
  opacity: 0; pointer-events: none;
  transition: opacity 0.25s ease;
  z-index: 40;
  -webkit-backdrop-filter: blur(2px);
  backdrop-filter: blur(2px);
}
.drawer-backdrop.open { opacity: 1; pointer-events: auto; }

/* ===== mobile ===== */
@media (max-width: 767px) {
  .topnav { padding: 0 14px; }
  .hamburger { left: 14px; }
  .topnav-tab { padding: 5px 12px; font-size: 12px; }
  .topnav-tab svg { display: none; }
  .main { padding: 16px 14px; }
  .sidebar { width: min(300px, 88vw); }
}

/* ===== tablet ===== */
@media (min-width: 768px) and (max-width: 1023px) {
  .main { padding: 20px; }
}
</style>
