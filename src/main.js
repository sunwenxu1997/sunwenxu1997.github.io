import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)

// 首次加载完后挂载，避免白屏和实现一个小动画
window.NProgress.close().then(() => {
  app.mount('#app')
})
