import { createRouter, createWebHashHistory } from 'vue-router'
import routes from './works'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('../views/Home.vue')
    },
    {
      path: '/works',
      name: 'Works',
      component: () => import('../views/Works.vue'),
      meta: { title: '作品', keepAlive: true }
    },
    {
      path: '/about',
      name: 'About',
      component: () => import('../views/About.vue'),
      meta: { title: '关于' }
    },
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/Login.vue'),
      meta: { title: '登录' }
    },
    {
      path: '/admin/works',
      name: 'AdminWorks',
      component: () => import('../views/admin/WorksAdmin.vue'),
      meta: { title: '作品管理', requiresAdmin: true }
    },
    ...routes,
    {
      path: '/:pathMatch(.*)*',
      name: '404',
      component: () => import('../views/404.vue'),
      meta: { title: '404' }
    }
  ]
})

// 路由守卫
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()
  await authStore.init()

  // 需要管理员权限
  if (to.meta.requiresAdmin) {
    if (!authStore.isAuthenticated) {
      return next('/login')
    }
    const isAdmin = await authStore.checkAdmin()
    if (!isAdmin) {
      window.alert('需要管理员权限')
      await authStore.signOut()
      return next('/login')
    }
  }

  next()
})

export default router
