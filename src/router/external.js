// 外部引入文件
export default [
  {
    path: 'https://codepen.io/MarkBoots/pen/abMWxKm',
    name: 'svg-filter镂空文字',
    meta: {
      date: '2024-01-23',
      cover: 'https://iili.io/Ja4B6HN.png',
      link: 'https://developer.mozilla.org/zh-CN/docs/Web/SVG/Element/feColorMatrix',
      info: `<b>remove black pixels from element (filter)</b>/从元素(滤镜)中移除黑色像素
      如上所属，默认文字颜色是黑色，通过标签滤镜filter来过滤掉黑色像素，从而实现镂空文字的效果。
      当然如果你想实现镂空效果，也可以搜索关键字 <b>‘探照灯’</b>（通过svg-clipPath-text）、<b>‘镂空文字’</b>（mask遮罩层）来看其他实现方案。
      <code>feColorMatrix</code>是SVG的一个滤镜原语，它可以对图形的颜色进行复杂的操作。它通过将每个像素的颜色值（RGBA）与一个矩阵进行相乘来改变颜色;
      <code>feColorMatrix</code>该滤镜用来侵蚀或扩张输入的图像;
      <code>feComposite</code>该滤镜执行两个输入图像的智能像素组合;
      `
    }
  },
  {
    path: 'https://codepen.io/codegridweb/pen/VwEzbqa',
    name: 'svg-path路径过渡',
    meta: { cover: 'https://iili.io/Ja4qjQs.gif' }
  }
]
