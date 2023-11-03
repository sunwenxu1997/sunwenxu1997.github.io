import defaultSet from '../settings'
// 异步获取检索文件目录 import.meta.glob ，构建时同步获取用 import.meta.globEager
const routeFiles = import.meta.globEager('../views/works/**/*.vue')
const routes = []
for (const path in routeFiles) {
  if (Object.hasOwnProperty.call(routeFiles, path)) {
    const routeConfig = routeFiles[path].default
    const routerPath = path.replace(/.vue*$/g, '').split('../views/works')[1]
    const routerName = routerPath.split('/').reverse()[0]
    const { link, hidden, code, cover, info, sort, date } = routeConfig
    const element = {
      path: encodeURI(routerPath), //处理中文路径乱码问题
      name: routerName,
      component: routeConfig,
      /**
       * code github代码地址
       * link 掘金文章地址
       * hidden 是否在随机时隐藏
       * cover 封面图
       * info 内容信息描述
       * sort 排序数值越大越靠前
       * date 日期
       */
      meta: {
        code: code || `${defaultSet.githubLink}/tree/main/src/views/works/${routerPath}.vue`,
        link: link,
        hidden: hidden || false,
        cover: cover || '',
        info: info || '',
        sort: sort || 0,
        date: date || 0
      }
    }
    routes.push(element)
  }
}
export default routes
