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
  },
  {
    path: 'https://codepen.io/sunwenxu1997/pen/eYXGYwr',
    name: 'gsap-stagger交错动画',
    meta: {
      date: '2024-01-24',
      cover: 'https://iili.io/JampcRR.gif',
      link: 'https://gsap.com/resources/getting-started/Staggers',
      info: `当你有100个标签，想要每个交错或者递增执行某一个动画，在CSS中你可能会想到使用 <b>animation-delay</b> 来实现。但是 <b>GSAP-stagger</b> 更加便捷，而且有更多的属性（axis）来支持你从头、从左、从上、从中间等来执行交错动画。
      <code>stagger: {...}</code>：这是一个变量，它用于创建一个错开的动画。在这个例子中，每个path元素的动画将会错开开始。
      <code>repeat: -1</code>：指定了动画的重复次数。-1表示动画将无限重复。
      <code>amount: 1</code>：指定的是所有动画之间的总延迟时间，而不是每个动画的持续时间。
      例如，如果你有10个path元素，amount属性的值是1秒，那么每个动画之间的延迟时间将会是0.1秒（1秒除以10）。这样，第一个动画将立即开始，第二个动画将在0.1秒后开始，第三个动画将在0.2秒后开始，以此类推，直到最后一个动画在0.9秒后开始。
      <code>yoyo: true</code>：指定了动画是否应该在每次重复时反向播放。true表示动画将在每次重复时反向播放。
      <code>from: "end"</code>：指定了动画的开始位置。"end"表示动画将从path元素的末尾开始。
      <code>each: 0.5</code>：用于指定每个动画之间的延迟时间。这个值是固定的，不会因为目标元素的数量而改变。
      例如，如果你有10个path元素，each属性的值是0.5秒，那么每个动画之间的延迟时间将会是0.5秒。这样，第一个动画将立即开始，第二个动画将在0.5秒后开始，第三个动画将在1秒后开始，以此类推，直到最后一个动画在4.5秒后开始。
      `
    }
  }
]
