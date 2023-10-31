import defaultSet from '../settings'
// 异步获取检索文件目录 import.meta.glob ，构建时同步获取用 import.meta.globEager
const routeFiles = import.meta.glob('../views/works/**/*.vue')
const routes = []
for (const path in routeFiles) {
  if (Object.hasOwnProperty.call(routeFiles, path)) {
    const routeModule = await routeFiles[path]()
    const routeConfig = routeModule.default
    const routerPath = path.replace(/.vue*$/g, '').split('../views/works')[1]
    const routerName = routerPath.split('/').reverse()[0]
    const { articleLink, hidden, githubCode, cover } = routeConfig
    const element = {
      path: encodeURI(routerPath), //处理中文路径乱码问题
      name: routerName,
      component: routeFiles[path],
      /**
       * githubCode github代码地址
       * articleLink 掘金文章地址
       * hidden 是否在随机时隐藏
       * cover 封面图
       */
      meta: {
        githubCode:
          githubCode || `${defaultSet.githubLink}/tree/main/src/views/works/${routerPath}.vue`,
        articleLink: articleLink,
        hidden: hidden || false,
        cover: cover || ''
      }
    }
    routes.push(element)
  }
}
export default routes
