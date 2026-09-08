<template>
  <div class="login-page">
    <div class="login-card">
      <!-- avatar -->
      <div class="avatar-wrap">
        <div class="avatar">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <h1 class="title">欢迎回来</h1>
        <p class="subtitle">sunwenxu1997.github.io</p>
      </div>

      <!-- form -->
      <form @submit.prevent="handleLogin">
        <div class="field">
          <label class="field-label">邮箱</label>
          <div class="input-wrap">
            <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
              <rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
            </svg>
            <input
              v-model="email"
              type="email"
              class="input"
              placeholder="请输入邮箱"
              required
              :disabled="loading"
            />
          </div>
        </div>

        <div class="field">
          <label class="field-label">密码</label>
          <div class="input-wrap">
            <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
              <rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <input
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              class="input has-right-icon"
              placeholder="••••••••"
              required
              :disabled="loading"
            />
            <svg
              class="input-icon right cursor-pointer"
              :class="{ active: showPassword }"
              @click="showPassword = !showPassword"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </div>
        </div>

        <label class="remember-row">
          <input v-model="rememberMe" type="checkbox" class="remember-checkbox" />
          <span class="remember-label">记住账号</span>
        </label>

        <button type="submit" class="btn-login" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>

      <div class="divider">
        <span></span>
        <span class="or">或</span>
        <span></span>
      </div>

      <a class="btn-oauth" href="https://supabase.com/" target="_blank" rel="noopener">
        <svg class="oauth-icon" viewBox="0 0 109 113" fill="none">
          <path d="M63.7618 0.272827L1.57543 69.6792C-1.47943 73.158 -0.0805584 78.6248 4.39305 80.1128L52.4019 95.9792C55.6402 97.0576 59.0598 95.2472 60.1383 91.8276L72.695 51.8252C73.1736 50.3072 74.7485 49.434 76.2665 49.9128L85.0811 52.6908C86.5992 53.1696 87.4724 54.744 86.9936 56.262L76.1531 90.868C73.0668 100.748 63.1748 106.068 53.6708 103.892L5.662 88.0256C-5.22199 84.448 -8.64059 72.236 -2.05903 64.7436L60.1273 -4.66277C62.8025 -7.71764 67.7468 -5.6944 67.3931 -1.5916L63.7618 0.272827Z" fill="currentColor"/>
          <path d="M95.9031 40.7628L75.1671 28.0356C73.692 27.1296 73.1256 25.2 73.9608 23.646L78.9608 14.37C79.796 12.816 81.7256 12.2496 83.2008 13.1556L103.937 25.8828C105.412 26.7888 105.978 28.7184 105.143 30.2724L100.143 39.5484C99.3078 41.1024 97.3782 41.6688 95.9031 40.7628Z" fill="currentColor"/>
        </svg>
        Supabase
      </a>

      <p class="footer">管理后台 · 仅限管理员访问</p>
    </div>
  </div>
</template>

<script setup>
defineOptions({ name: 'AdminLogin' })

import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { useAuthStore } from '@/stores/auth'

const REMEMBER_KEY = 'login_remember_email'

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const loading = ref(false)
const rememberMe = ref(false)

const router = useRouter()
const authStore = useAuthStore()

onMounted(() => {
  const saved = localStorage.getItem(REMEMBER_KEY)
  if (saved) {
    email.value = saved
    rememberMe.value = true
  }
})

async function handleLogin() {
  if (!email.value || !password.value) return
  loading.value = true
  if (rememberMe.value) {
    localStorage.setItem(REMEMBER_KEY, email.value)
  } else {
    localStorage.removeItem(REMEMBER_KEY)
  }
  try {
    const { error } = await authStore.signInWithPassword({
      email: email.value,
      password: password.value
    })
    if (error) throw error
    toast.success('登录成功')
    router.push('/admin/works')
  } catch (e) {
    toast.error(e.message || '登录失败')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f4;
  padding: 16px;
}
.login-card {
  width: 100%;
  max-width: 400px;
  background: #fff;
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}
.avatar-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 32px;
}
.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #292524, #78716c);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}
.avatar svg {
  width: 32px;
  height: 32px;
  color: #fff;
}
.title {
  font-size: 20px;
  font-weight: 600;
  color: #292524;
}
.subtitle {
  font-size: 14px;
  color: #a8a29e;
  margin-top: 4px;
}
.field {
  margin-bottom: 20px;
}
.field-label {
  display: block;
  font-size: 12px;
  color: #78716c;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 8px;
}
.input-wrap {
  position: relative;
}
.input {
  width: 100%;
  padding: 14px 16px 14px 48px;
  background: #fafaf9;
  border: 1px solid #e7e5e4;
  border-radius: 14px;
  font-size: 14px;
  color: #292524;
  outline: none;
  transition: border-color 0.2s;
  box-sizing: border-box;
}
.input.has-right-icon {
  padding-right: 48px;
}
.input:focus {
  border-color: #44403c;
}
.input:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
.input-icon {
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  color: #a8a29e;
}
.input-icon.right {
  left: auto;
  right: 16px;
  cursor: pointer;
}
.input-icon.right.active {
  color: #57534e;
}
.remember-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  cursor: pointer;
}
.remember-checkbox {
  width: 16px;
  height: 16px;
  accent-color: #292524;
  cursor: pointer;
}
.remember-label {
  font-size: 13px;
  color: #78716c;
  user-select: none;
}
.btn-login {
  width: 100%;
  padding: 14px;
  background: #292524;
  color: #fff;
  border: none;
  border-radius: 14px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.03em;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-login:hover:not(:disabled) {
  background: #1c1917;
}
.btn-login:active:not(:disabled) {
  transform: scale(0.98);
}
.btn-login:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
.divider {
  display: flex;
  align-items: center;
  gap: 16px;
  margin: 24px 0;
}
.divider span:first-child,
.divider span:last-child {
  flex: 1;
  height: 1px;
  background: #e7e5e4;
}
.or {
  font-size: 12px;
  color: #a8a29e;
}
.btn-oauth {
  width: 100%;
  padding: 14px;
  background: #f5f5f4;
  color: #292524;
  border: none;
  border-radius: 14px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.btn-oauth:hover:not(:disabled) {
  background: #e7e5e4;
}
.btn-oauth:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
.oauth-icon {
  width: 16px;
  height: 16px;
}
.footer {
  text-align: center;
  font-size: 12px;
  color: #a8a29e;
  margin-top: 24px;
}
</style>
