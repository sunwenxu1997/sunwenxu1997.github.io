import { createRouter, createWebHashHistory } from 'vue-router'

// 检索文件目录 import.meta.globEager
const files = import.meta.globEager('../views/**/*.vue')
const routes = [];
for (const key in files) {
    const { __name, __hmrId, name } = files[key].default
    const path = key.replace(/.vue*$/g, '').split('../views')[1]
    const element = {
        path: encodeURI(path), //处理中文路径乱码问题
        name: __name || name || __hmrId, //对应vue文件内的name属性
        component: files[key].default //采用静态路由，根据文件目录获取所有vue文件
    }
    routes.push(element)
}

// 每次首次进入生成一个随机的路由地址
function randomRoute(routes) {
    return routes[~~(Math.random() * routes.length)]
}
// console.log(files);
// console.log(routes);
const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            redirect: randomRoute(routes).path
        },
        ...routes
    ]
})
// 路由守卫
router.beforeEach((to, from, next) => {
    next()
})

export default router
