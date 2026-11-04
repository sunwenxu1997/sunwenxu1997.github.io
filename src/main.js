import './assets/main.css'
import "tailwindcss/tailwind.css" // 引入 tailwindcss 样式
import './assets/markdown.css' // Markdown 正文样式（prose 基础上做站点化微调）
import 'vue-sonner/style.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import loading from './utils/loading'

// 首屏关键图片：Home 的磨砂滤镜（feImage）依赖它
const FIRST_SCREEN_IMAGES = ['/images/displacement/10.jpg']

async function bootstrap() {
  loading.start()

  const app = createApp(App)
  app.use(createPinia())
  // 先安装 router，初始导航才会开始，waitRoute 才能等到真实的就绪时机
  app.use(router)

  // 依次等待真实的加载阶段：路由 chunk + 守卫请求 → 字体 → 首屏图片
  // 注意：waitRoute 必须在 app.use(router) 之后调用，否则 isReady 会一直挂起
  await loading.waitRoute(router)
  await loading.waitFonts()

  // 只有首页才需要等这张图，其他页面直接放行
  const isHome = router.currentRoute.value.name === 'Home'
  await loading.waitImages(isHome ? FIRST_SCREEN_IMAGES : [])

  app.mount('#app')

  // 挂载完成即首帧渲染完成，补到 100% 并淡出遮罩
  await loading.finish()
}

bootstrap()
