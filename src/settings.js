export default {
    userName:'sunwenxu',
    email:'1291397693@qq.com',
    github:'https://github.com/sunwenxu1997',
    // 掘金
    juejin:'https://juejin.cn/user/1291397693',
    // github个人主页地址
    githubLink: 'https://github.com/sunwenxu1997/sunwenxu1997.github.io',
    // 外部引入文件
    externalRoutes: [
        {
            path: 'https://codepen.io/sunwenxu1997/pen/zYVgZeB',
            name: 'css-电梯导航栏',
            meta: {
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
            path: 'https://codepen.io/HighFlyer/pen/GRLZYKw',
            name: 'css-鼠标经过卡片时波纹效果',
            meta: {
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
        },
        {
            path: 'https://codepen.io/sunwenxu1997/pen/vYPeeqa',
            name: 'mix-blend-mode混合模式-重复文字背景',
            meta: {
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
            path: 'https://codepen.io/sunwenxu1997/pen/bGPjMdK',
            name: 'radial-gradient圆角裁边入场券',
            meta: {
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
            path: 'https://codepen.io/sunwenxu1997/pen/PorXbzO',
            name: '卡片3D旋转跟随效果',
            meta: {
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
            path: 'https://codepen.io/sunwenxu1997/pen/dyBaOEW',
            name: '3D模型鼠标跟随旋转效果',
            meta: {
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
