import { useAppStore } from '../stores/index'
import { createRouter, createWebHashHistory } from 'vue-router'
import routes from './works'

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
      meta: { title: '作品' }
    },
    {
      path: '/about',
      name: 'About',
      component: () => import('../views/About.vue'),
      meta: { title: '关于' }
    },
    ...routes
  ]
})
// 路由守卫
router.beforeEach((to, from, next) => {
  next()
})

export default router
