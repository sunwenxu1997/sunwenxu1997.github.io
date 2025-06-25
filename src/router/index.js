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
      meta: { title: '作品', keepAlive: true }
    },
    {
      path: '/about',
      name: 'About',
      component: () => import('../views/About.vue'),
      meta: { title: '关于' }
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
router.beforeEach((to, from, next) => {
  // // 滚动条置顶
  // window.scrollTo(0, 0)
  next()
})

export default router
