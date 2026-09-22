import { defineStore } from 'pinia'
import { ref } from 'vue'
import { fetchPublishedWorks } from '@/api/works'

export const useWorksStore = defineStore('works', () => {
  const works = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function init() {
    loading.value = true
    error.value = null
    try {
      works.value = await fetchPublishedWorks()
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
