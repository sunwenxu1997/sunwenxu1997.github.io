export default {
  /**
   * userName 用户名
   * email 邮箱
   * github github地址
   * juejin 掘金地址
   * githubLink github个人主页地址
   * externalRoutes 外部引入文件
   *  path 打开地址
   *  name 标题
   *  meta 信息
   *   date 日期
   *   cover 封面图
   *   link 文章链接
   *   info 信息
   *   sort 排序
   *   hidden 是否隐藏
   *   codepen codepen在线代码地址
   *
   *
   * <code></code> 代码块
   * <b></b> 加粗
   * <a href="" target="_blank"></a> 超链接
   */
  userName: 'sunwenxu',
  email: '1291397693@qq.com',
  github: 'https://github.com/sunwenxu1997',
  juejin: 'https://juejin.cn/user/1291397693',
  githubLink: 'https://github.com/sunwenxu1997/sunwenxu1997.github.io',
  externalRoutes: [
    {
      name: 'animejs-鼠标跟随赞助爱心',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/azvNBVY',
        code: 'https://github.com/sunwenxu1997/sunwenxu1997.github.io/blob/main/src/views/works/anime/anime-%E8%B7%9F%E9%9A%8F%E5%B0%8F%E7%88%B1%E5%BF%83',
        date: '2025-07-22',
        cover: 'https://iili.io/FND8Vl2.gif',
        link: 'https://juejin.cn/post/7529834029219856399',
        info: `在animejs官网右上角赞助看到的效果，感觉很有意思就尝试复现了下，顺便巩固了下动画知识(๑•̀ㅂ•́)و✧`
      }
    },
    {
      name: 'Animejs-draggable导航拖拽切换',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/azzxeXo',
        code: 'https://github.com/sunwenxu1997/sunwenxu1997.github.io/blob/main/src/views/works/anime/anime-draggable%E6%A0%87%E7%AD%BE%E5%86%85%E5%AE%B9%E5%88%87%E6%8D%A2.vue',
        date: '2025-05-26',
        cover: 'https://iili.io/3bObz9j.gif',
        link: 'https://juejin.cn/post/7508556336540745728',
        info: `有段时间没更文了，起初动画库选的 GSAP，奈何后面发现英文文档实在难以下咽🤮，而且官方案例又很少，学习难度增大。
                20年刚入行开始学动画的时候也是选的 <a href="https://animejs.cn/documentation/" target="_blank">Animejs</a>，可能当时还没崛起。很多功能并没有GSAP那么全面，不过现在看起来。Animejs才是真正的神，这几年社区发展的很快，很多功能也都赶上了，更重要的是有 中文文档，案例也都很完善，建议大家少走弯路，直接选它👍！
                这里不做过多陈述，建议直接点击↗右上角📕文章链接查看
            `
      }
    },
    {
      name: 'css-视图切换(:has,:not选择器)',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/RNbYMOX',
        date: '2025-01-22',
        cover: 'https://iili.io/2iko07e.gif',
        link: 'https://juejin.cn/post/7462303598707310603',
        info: `🧨快过年了，后端的知识点看不进去，又来琢磨css了。本来想写其它效果的，歪打正着搞出来了这个，还是很奇妙的。主要是通过兄弟选择器 <code>+</code>  来达到点击时其他视图的变化效果。其中难点在于如何点击后者，控制之前的兄弟标签（基本上网上给的答案都是不能实现的），但是可以间接通过 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/:has" target="_blank">:has</a> 和 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/:not" target="_blank">:not</a> 选择器来配合实现。
                以下这段是点击第4张元素，控制第3张元素的css代码（🙄你也可以理解为在第3张元素事先满足这些条件下，会有这种效果）。
                <code>.x:nth-child(1):not(.y:checked)+*+.x:nth-child(3):not(.y:checked):has(+ .x .y:checked) .z</code> 
                1. 控制 /①元素（不是选中）+ ②元素（不是选中）+ ③元素（没有选中）但存在（+ ④元素被选中）/时满足以上条件的③元素样式；
                2. 即便我们不能直接控制之前的元素，但是我们可以事先要求之前的元素满足一定条件，来达到提前预判；
            `
      }
    },
    {
      name: 'gsap-3d圆环交错视图滚动',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/qEWKjge',
        date: '2025-01-16',
        cover: 'https://iili.io/2iHaHiu.gif',
        link: 'https://juejin.cn/post/7461829417750315062',
        info: `这是一个很有意思的效果，有时可以用于产品或者照片墙的展示。主要是结合 GSAP 中的 ScrollTrigger，加上css的3D旋转等实现。你也可以 <a href="https://tympanus.net/codrops/2024/10/16/staggered-3d-grid-animations-with-scroll-triggered-effects/" target="_blank">👉点击这里</a> ，参考原网站的作品效果。 
                1.通过grid布局创建2列标签块，定义好每个块的样式大小，以及设置好一些css 3D旋转属性。例如: <code>transform-style: preserve-3d;</code> <code>perspective</code>；
                2.方法 isLeftSide 用来判断2列块的左右，用于设置 <code>rotateZ，skewX，x</code> 左右的旋转/倾斜/偏移；
                3.为每个块创建一个带有ScrollTrigger的GSAP时间轴timeline动画，其中设置 <code>scrub: true</code>至关重要，这样才能把动画的执行和滚动操作绑定起来；
                4.<code>.from</code> 为每个块定义之前的效果（你不用担心中途样式该如何定义，因为创建块时就是它最初的状态， <b>.from< 初始状态 <.to</b>）
                5.<code>.to</code> 为每个块定义之后的效果（你可以理解为之前和之后时的效果是相反的，想要达到圆环的效果，是可以这么做的）
            `
      }
    },
    {
      name: 'css-文本溢出展开收起',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/emOGXqR',
        date: '2025-01-12',
        cover: 'https://iili.io/24xceTB.gif',
        link: 'https://juejin.cn/post/6963904955262435336',
        info: `起初打算用 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/shape-outside" target="_blank">shape-outside</a> 来让内容环绕按钮，但后面发现实现效果不如 浮动float 来的直接。而且网上也有现成的大佬踩坑实现，所以直接捡漏🎉。
                其中有2种实现方式，<code>input type="checkbox"</code> 但都是通过结合复选框的选中状态，控制展开收起操作。
                1.<code>-webkit-line-clamp</code> 内容限制为指定的行数；
                2.<code>max-height</code> 控制内容最大高度，超出隐藏。给按钮模拟添加...，达到省略效果（此方式有 transition 过渡效果）；
            `
      }
    },
    {
      name: 'radial-gradient按钮周围边框高亮',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/azoopBo',
        date: '2024-11-25',
        cover: 'https://iili.io/2aGRUHx.gif',
        link: 'https://juejin.cn/post/7358622889681551372',
        info: `今天网上看到有类似文章，发现自己之前也是实现过类似方法，但是回过头来却有点看不懂了😔。所以大家还是要多复习复习。
            <code>radial-gradient</code> 径向渐变 radial-gradient(100px at {x}px {y}px, rgba(186, 10, 244, 0.5), rgba(255, 255, 255, 0));
            <code>100px 渐变半径</code> 颜色从中心点开始按照设定的颜色节点进行过渡，在半径为 100px 的范围内完成整个渐变效果;
            <code>x,y</code> 圆心的中心点坐标位置;
            给每个按钮都设置一个径向渐变的背景，监听鼠标位置，因此在你移动时，所有的背景都在跟着移动和位置坐标变化，只是超出容器范围的背景不会展示而已。
            `
      }
    },
    {
      name: 'css-电梯导航栏',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/zYVgZeB',
        date: '2024-09-19',
        cover: 'https://iili.io/dP08thN.gif',
        link: 'https://juejin.cn/post/7396342567867301927',
        info: `想要达到这种效果一般还是用js比较常见，此处主要用到的是css得新特性 <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/timeline-scope#result" target="_blank">timeline-scope</a> 时间线范围。不过兼容性不是很好，大家谨慎使用，或许以后就支持了呢~
            不太懂得建议大家可以查看文章链接，文章中作者有更加详细的说明哦🙄。
            <code>href="#t1"</code> <code>id="t1"</code>：通过id匹配方式，在点击a标签导航栏时自动锚点到对应位置;
            <code>scroll-behavior: smooth</code> 页面的滚动会以平滑的动画效果进行过渡，而不是瞬间跳转到目标位置;
            通过关联 <code>view-timeline-name</code> <code>animation-timeline</code> ，监测到元素在可视区（content）中给a标签加上动画效果;
            `
      }
    },
    {
      name: 'css-鼠标经过卡片时波纹效果',
      meta: {
        codepen: 'https://codepen.io/HighFlyer/pen/GRLZYKw',
        date: '2024-09-13',
        cover: 'https://iili.io/dgS5isj.gif',
        link: '',
        info: `今天发现一个很有意思的效果，起初认为只有canvas或者webGL才能实现。后来发现原来css也可以达到这种效果，主要用的是css的新特性 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/:has" target="_blank">:has()</a> 伪类选择器。
            <code>.item + *</code>：.item 标签往下(之后)相邻的兄弟标签;
            <code>.item + * + *</code>：.item 标签往下(之后) +1 相邻的兄弟标签;
            <code>.item:hover + *</code>：当鼠标悬停在 .item 标签时，往下(之后)相邻的兄弟标签样式将会变化;
            <code>.item:has(+ *)</code>：.item 标签往上(之前)相邻的兄弟标签;
            <code>.item:has(+ :hover)</code>：当鼠标悬停在 .item 标签时，往上(之前)相邻的兄弟标签样式将会变化;
            `
      }
    },
    {
      name: 'svg-filter镂空文字',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/abMWxKm',
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
      name: 'svg-path路径过渡',
      meta: {
        codepen: 'https://codepen.io/codegridweb/pen/VwEzbqa',
        cover: 'https://iili.io/Ja4qjQs.gif'
      }
    },
    {
      name: 'gsap-stagger交错动画',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/eYXGYwr',
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
    },
    {
      name: 'mix-blend-mode混合模式-重复文字背景',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/vYPeeqa',
        date: '2024-01-25',
        cover: 'https://iili.io/Jc3Kant.png',
        link: 'https://juejin.cn/post/6844903477429141517',
        info: `想要实现这种效果的形式有很多：
            方式1：你需要有一张文字背景图片或svg，通过<code>background-image</code>引入，加上<code>background-clip: text;</code>背景文字裁切来实现。可搜索关键字<b>‘文字效果’</b>来查看。
            👍方式2：你可以通过<code>mix-blend-mode: screen;</code>滤色模式，具体做法是把两个颜色都反相，相乘，然后再反相。简单记忆为"让白更白，而黑不变"。当然弊端😔就是背景都需要是纯白色。
            `
      }
    },
    {
      name: 'radial-gradient圆角裁边入场券',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/bGPjMdK',
        date: '2024-08-29',
        cover: 'https://iili.io/djbneHP.png',
        link: 'https://codepen.io/cbolson/pen/JjVVPPP',
        info: `优惠券，入场券等，有时UI会设计这种圆角裁边的效果。大部分情况，我们会直接取背景色用⚪覆盖实现效果。
            而此处则可以达到镂空效果，可以达到真实的裁边效果，以下为重点实现代码。
            <code>radial-gradient(circle..top left)</code>：背景径向渐变，控制圆的大小以及初始位置。背景径向渐变有2个，一个是上左，一个是下右方；
            <code>background-size: 100% 51%;</code>：因为有2个径向渐变，为保证镂空处不被另一方给覆盖，所以会让y轴设置为51%，刚好达到交界结合效果；
            <code>background-repeat: no-repeat;</code>： 设置不允许重叠，避免默认重叠不能实现该效果。
            `
      }
    },
    {
      name: '卡片3D旋转跟随效果',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/PorXbzO',
        date: '2024-09-06',
        cover: 'https://iili.io/dvlGSqX.gif',
        link: 'https://github.com/chokcoco/iCSS/issues/179',
        info: `rotateX = -(鼠标 y 坐标 - 元素左上角 y 坐标 - 元素高度的一半)deg / multiple(幅度);
            rotateY =  (鼠标 x 坐标 - 元素左上角 x 坐标 - 元素宽度的一半)deg / multiple(幅度);
            <code>mousemove</code><code>mouseleave</code>：监听鼠标移动和移出,控制卡片的偏移;
            <code>transform-style: preserve-3d</code>：控制css的transform属性来实现标签的3D旋转;
            `
      }
    },
    {
      name: '3D模型鼠标跟随旋转效果',
      meta: {
        codepen: 'https://codepen.io/sunwenxu1997/pen/dyBaOEW',
        date: '2024-09-09',
        cover: 'https://iili.io/dSWocdJ.gif',
        link: '',
        info: `也是偶尔在 <a href="https://leetcode.cn/studyplan/top-interview-150/" target="_blank">[力扣]</a> 这个刷题平台上看到的效果，觉得挺有意思，就花了点时间研究下。主要还是用到Threejs来实现的，当然鼠标移动的旋转也可以参考上条内容，实现方式差不多😊。
            <code>THREE.OBJLoader</code>：外部.obj格式3D模型加载;
            <code>.rotation</code>：控制模型的旋转;
            `
      }
    }
  ]
}
