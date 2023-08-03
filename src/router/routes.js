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
export default routes