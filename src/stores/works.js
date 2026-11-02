import { defineStore } from 'pinia'
import { ref } from 'vue'
import { fetchPublishedWorks } from '@/api/works'
import { fetchLocalWorks } from '@/api/works.local'
import defaultSet from '@/settings'

export const useWorksStore = defineStore('works', () => {
  const works = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function init() {
    loading.value = true
    error.value = null
    try {
      // settings.useLocalWorks 打开时直接读静态数据，关闭时走 Supabase
      works.value = defaultSet.useLocalWorks ? fetchLocalWorks() : await fetchPublishedWorks()
    } catch (e) {
      console.error('[works] 加载失败:', e)
      error.value = e.message
      works.value = []
    } finally {
      loading.value = false
    }
  }

  return { works, loading, error, init }
})
