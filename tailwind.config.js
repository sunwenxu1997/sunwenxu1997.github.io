/** @type {import('tailwindcss').Config} */
module.exports = {
//   禁用预加载，修复tailwind样式 与 naive-ui button等样式等冲突问题
    corePlugins: {
      preflight: false
    },
  //   content: ['./index.html', './src/**/*.{html,js,vue}'],

  // 暂时只针对部分用到的组件进行预加载，预防影响其它已经确定的组件样式
  content: ['./src/components/AppleWindow.vue','./src/views/cssHtml/tailwindcss使用.vue', './src/views/cssHtml/tailwindcss使用1.vue'],
  theme: {
    /**
     * 自定义屏幕断点, 用于响应式设计
     * sm:bg-red-500
     * https://tailwind.nodejs.cn/docs/screens
     * min-width < screen < max-width
     */
    screens: {
      sm: '640px',
      // => @media (min-width: 640px) { ... }

      md: '768px',
      // => @media (min-width: 768px) { ... }

      lg: '1024px',
      // => @media (min-width: 1024px) { ... }

      xl: '1280px',
      // => @media (min-width: 1280px) { ... }

      '2xl': '1536px'
      // => @media (min-width: 1536px) { ... }
    },
    extend: {}
  },
  plugins: []
}
