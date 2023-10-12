import defaultSettings from '../settings'
// 检索文件目录 import.meta.globEager
const files = import.meta.globEager('../views/**/*.vue')
const routes = []
for (const key in files) {
  const { articleLink, hidden, githubCode } = files[key].default
  const path = key.replace(/.vue*$/g, '').split('../views')[1]
  const name = key
    .replace(/.vue*$/g, '')
    .split('../views')[1]
    .split('/')
    .reverse()[0]
  const element = {
    path: encodeURI(path), //处理中文路径乱码问题
    name: name, //对应vue文件内的name属性
    component: files[key].default, //采用静态路由，根据文件目录获取所有vue文件
    meta: {
      githubCode:githubCode || `${defaultSettings.githubLink}/tree/main/src/views${path}.vue`,
      articleLink: articleLink,
      hidden: hidden || false
    }
  }
  routes.push(element)
}
export default routes
