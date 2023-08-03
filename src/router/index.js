import { useAppStore } from "../stores/index";
import { createRouter, createWebHashHistory } from 'vue-router'
import routes from './routes';


const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: routes
})
// 路由守卫
router.beforeEach((to, from, next) => {
    const { createRandomRoute } = useAppStore()
    if (to.path == '/') {
        next({ path: createRandomRoute(routes).path })
    } else {
        next()
    }

})

export default router
