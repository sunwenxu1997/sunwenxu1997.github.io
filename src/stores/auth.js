import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const session = ref(null)
  const loading = ref(true)

  const isAuthenticated = computed(() => !!user.value)

  async function init() {
    loading.value = true
    const {
      data: { session: currentSession }
    } = await supabase.auth.getSession()
    session.value = currentSession
    user.value = currentSession?.user ?? null
    loading.value = false
  }

  function subscribeAuthChange() {
    return supabase.auth.onAuthStateChange((_event, nextSession) => {
      session.value = nextSession
      user.value = nextSession?.user ?? null
    })
  }

  async function signInWithOAuth({ provider = 'github', redirectTo } = {}) {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider,
      options: { redirectTo }
    })
    return { data, error }
  }

  async function signInWithPassword({ email, password }) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    return { data, error }
  }

  async function signUp({ email, password }) {
    const { data, error } = await supabase.auth.signUp({ email, password })
    return { data, error }
  }

  async function signOut() {
    const { error } = await supabase.auth.signOut()
    if (!error) {
      session.value = null
      user.value = null
    }
    return { error }
  }

  async function checkAdmin() {
    const { data, error } = await supabase.rpc('is_admin')
    if (error) {
      console.error('[auth] checkAdmin failed:', error)
      return false
    }
    return !!data
  }

  return {
    user,
    session,
    loading,
    isAuthenticated,
    init,
    subscribeAuthChange,
    signInWithOAuth,
    signInWithPassword,
    signUp,
    signOut,
    checkAdmin
  }
})
