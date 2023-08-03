
// 根据路由文件生成一个随机的路由地址
export function createRandomRoute(routes) {
    return routes[~~(Math.random() * routes.length)]
}