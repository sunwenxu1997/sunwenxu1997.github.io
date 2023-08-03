import { createRouter, createWebHashHistory } from 'vue-router'
import routes from './routes';
import { createRandomRoute } from "../utils/index";

// console.log(files);
// console.log(routes);
const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            redirect: createRandomRoute(routes).path
        },
        ...routes
    ]
})
// 路由守卫
router.beforeEach((to, from, next) => {
    next()
})

export default router
