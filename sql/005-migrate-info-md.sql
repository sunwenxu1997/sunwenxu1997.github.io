-- ================================================================
-- 005：works_meta.info_html（历史 HTML）转写为 info_md（Markdown）
--
-- 前置：先执行 004-works-info-md.sql（新增 info_md 列）
-- 记录数：67 条
--
-- 说明：
--   1. 只写 info_md，info_html 原样保留，可随时回滚
--   2. 每条用 $info_md$ dollar-quoting，正文里的单引号/换行无需转义
--   3. 重复执行会覆盖 info_md，后台手动改过的正文会被重置
--
-- 转换规则：
--   <code>x</code>          -> `x`（行内代码）
--   <a href="u">t</a>       -> [t](u)
--   <b>x</b>                -> **x**
--   <br>                    -> 换行（markdown-it 已开 breaks: true）
--   &lt; &gt;               -> < >
--   行首空白一律去掉（避免 4 空格缩进被当成代码块）
-- ================================================================

begin;

update public.works_meta set info_md = $info_md$
近期网上看到的一个效果，实现起来也很简单。同时挖掘到了一个很牛的[Filip Zrnzevic😎大佬](https://codepen.io/filipz)，写的效果都很炫酷。
`animejs-text` 官方提供的文本 [分割插件](https://animejs.cn/documentation/text/split/split-parameters/class)，相比于GSAP是不额外收费的，不过animejs版本要在4.0以上；
`fractalNoise` background-image 引入本地定义好的噪点svg，通过重复动画随即修改 background-size 实现噪点波动效果
$info_md$ where slug = '/anime/anime-切割模糊文字';

update public.works_meta set info_md = $info_md$
闲逛掘金时发现的一个好玩效果🌊，作者是通过scss实现的动画效果，这里我尝试用 animejs 做了实现。
`.cloneNode:` 克隆复制dom节点，批量创建26（涉及到后面的裁切，这个数量基本能达到100%的裁切）个文字元素层；
`clip-path:` 第一块裁切比例 clip-path: polygon(-30% 0, -20% 0, 20% 100%, 0% 100%)，clip-path: polygon(-25% 0, -15% 0, 25% 100%, 5% 100%)，以此类推...
动画执行时间和旋转角度这些就不做过多陈述了，基本都是经过实践得到的最优效果👻
$info_md$ where slug = '/anime/anime-切割波浪文字';

update public.works_meta set info_md = $info_md$
近期将要做活动中奖相关需求，就想着能不能做一个这种效果。因为之前有见过类似🎉喷洒的动画，后来找又找不到了，其次看到网上的效果也不是很理想，所以就考虑打算自己手搓一个。
实际效果还可以，主要还是通过animejs动画控制，创建很多随机的彩带元素。点击绽放的效果不是特别流畅，后期可以根据animejs提供不同的 [缓动函数Easings](https://codepen.io/juliangarnier/pen/gbOqbVR) 来调整优化。
$info_md$ where slug = '/anime/anime-礼花彩带效果';

update public.works_meta set info_md = $info_md$
参考大佬 Chokcoco 的作品，用 Vue3.0 实现了一下，代码比较简单，就不多说了。
知识点：
1.通过伪元素制造多层表情标签，制造3D假象；
2.通过记录下落转向上升的那一帧开始，更换表情和背景；
3.学会如何通过 `conic-gradient` `linear-gradient` `radial-gradient` 实现多样化的背景效果；
$info_md$ where slug = '/cssHtml/3D弹跳表情';

update public.works_meta set info_md = $info_md$
之前尝试实现磨砂效果，都会想着用fliter滤镜加模糊实现。但是效果总是那么差点意思，后来css推出了 **backdrop-filter** 属性，值得一试。
知识点：
1. `backdrop-filter` 背景模块滤镜，类似于filter
2. `clip-path: inset(10px)` 相当于整体向内裁切10px
$info_md$ where slug = '/cssHtml/backdrop-filter-磨砂玻璃效果';

update public.works_meta set info_md = $info_md$
动画新属性 **animation-composition** 的学习，可能实际项目上用不到。
知识点：
1. `animation-composition` 动画合成
2. `steps` 按步执行动画
$info_md$ where slug = '/cssHtml/css-碰撞检测';

update public.works_meta set info_md = $info_md$
想要实现这种效果可以通过svg滤镜，也可以通过模糊和对比度来实现。因为效果展示原因，最终采用了后者。但是也有弊端，就是需要重复一套相同的文本，其中一个是专门用作背景效果使用。更多内容可以直接在代码里了解。
知识点：
1. `filter:blur() contrast()`filter滤镜模糊和对比度
2. `box-decoration-break`属性用来定义当元素跨多行、多列或多页时，元素的片段应如何呈现。
$info_md$ where slug = '/cssHtml/filter-文字背景溶解效果';

update public.works_meta set info_md = $info_md$
通过 CSS `mask` 配合 `linear-gradient` 实现网点网格遮罩效果，底层使用渐变色动画背景。
知识点：
1. `mask` 遮罩属性，通过渐变定义可见区域
2. `mask-size` 控制网格密度
3. `linear-gradient` + `background-size` 实现重复网格
$info_md$ where slug = '/cssHtml/mask-网点图';

update public.works_meta set info_md = $info_md$
参考 [iCSS](https://github.com/chokcoco/iCSS/issues/80) 的效果，利用 CSS `mask` 引入 SVG 图形作为遮罩，实现文字/图形镂空效果，底层使用背景图 + 模糊滤镜。
知识点：
1. `mask: url()` 引入 SVG 作为遮罩
2. `filter: blur() brightness()` 背景模糊和亮度调节
3. `background-size: cover` 背景自适应
$info_md$ where slug = '/cssHtml/mask-镂空文字';

update public.works_meta set info_md = $info_md$
项目集成 [TailwindCSS](https://tailwindcss.com/) 的简单示例，通过原子化 CSS 类快速构建页面布局，配合自定义 `AppleWindow` 组件展示效果。
知识点：
1. `npm install -D tailwindcss` 安装配置
2. `tailwind.config.js` 配置模板扫描路径
3. 常用工具类：`grid`、`place-content-center`、`h-screen`
$info_md$ where slug = '/cssHtml/tailwindcss使用';

update public.works_meta set info_md = $info_md$
可能使用价值不太高，娱乐学习一下~
知识点：
1. `clip-path` 路径裁切，实现⑥边形效果
2. `shape-outside` 说白了就是可以让文本围绕着你定义的样式环绕
$info_md$ where slug = '/cssHtml/循环六边形背景效果';

update public.works_meta set info_md = $info_md$
很早之前遇到的效果了，当时记得还在为自己搞得小程序登录背景发愁呢。突然发现了这个好看又简约的效果，所以便入手了。主要是根据一小块svg矢量图，然后通过背景重复实现的平铺，再加上背景尺寸和位置的改变，实现了动画效果。
如果你想改颜色，那建议你下载源地址svg，然后修改fill填充色，你也可以通过上传自己的图片实现效果。
$info_md$ where slug = '/cssHtml/循环滚动背景效果';

update public.works_meta set info_md = $info_md$
🌈属于文字效果，里面有各种样式类型的文本，当然不仅仅可以应用于文字上，你也可以应用在其他地方。首先你要先学会他，不是吗？
知识点：
1. `background-clip: text;` 背景文本裁切
2. `mask` 遮罩层
3. `svg，fliter`等效果应用
$info_md$ where slug = '/cssHtml/文字效果';

update public.works_meta set info_md = $info_md$
🌈属于文字效果，但更适合于纯黑色背景，有点局限性。更推荐用背景裁切 [background-clip: text;](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-clip)
知识点：
1. `mix-blend-mode` 混合模式
2. `clamp()` 函数的作用是把一个值限制在一个上限和下限之间，当这个值超过最小值和最大值的范围时，在最小值和最大值之间选择一个值使用。它接收三个参数：最小值、首选值、最大值。
$info_md$ where slug = '/cssHtml/文字极光动画';

update public.works_meta set info_md = $info_md$
今天又是忙碌的一天，今天周二还有生产发布，但是发现这个有意思得效果还是要学习下的！😄
知识点：
1. `-webkit-text-fill-color`设置文本的填充颜色，这里建议设置透明度低得，否则颜色过渡上会有冲突
2. `-webkit-background-clip: text`用于将背景应用到文本内容内部，创建文本填充效果
3. `background-size: 0% 100%;`文字进度完成度 x轴控制水平进度，y轴控制垂直进度
$info_md$ where slug = '/cssHtml/文字背景进度';

update public.works_meta set info_md = $info_md$
单纯的通过 css+html 实现的碎裂效果。
知识点：
1. `clip-path` 路径剪切；
2. `content: attr(data-text);`文本属性引用；
$info_md$ where slug = '/cssHtml/碎裂文字效果';

update public.works_meta set info_md = $info_md$
这个效果是在别的网站上看到的，感觉挺新奇的，尤其很适用于一些家具，灯具类分模块的的价格展示。但是局限性其实也很大，因为图片大小、页面定位都有特定的要求，所以有兴趣的也可以学习一下。主要是了解网格布局的使用。
知识点：
1. `grid` 网格布局；
2. `grid-area`网格分区域展示；
$info_md$ where slug = '/cssHtml/网格布局家具背景';

update public.works_meta set info_md = $info_md$
某一天感觉单纯的背景色有点单一，同时看到掘金有些文章背部有类似网格形状的东西，所以就好奇的尝试实现下。其实原理还是挺简单的，当然你也可以直接通过图片来实现（放大会模糊），但是当你真正掌握后，它不仅仅能实现网格，还有其他更多花样背景呢。
知识点：
1. `linear-gradient` 背景渐变；
2. `background-size` 背景尺寸；
3. `background-repeat` 背景重复；
$info_md$ where slug = '/cssHtml/网格背景效果';

update public.works_meta set info_md = $info_md$
也是偶尔在 [[力扣]](https://leetcode.cn/studyplan/top-interview-150/) 这个刷题平台上看到的效果，觉得挺有意思，就花了点时间研究下。主要还是用到Threejs来实现的，当然鼠标移动的旋转也可以参考上条内容，实现方式差不多😊。
`THREE.OBJLoader`：外部.obj格式3D模型加载;
`.rotation`：控制模型的旋转;
$info_md$ where slug = '/external/3D模型鼠标跟随旋转效果';

update public.works_meta set info_md = $info_md$
有段时间没更文了，起初动画库选的 GSAP，奈何后面发现英文文档实在难以下咽🤮，而且官方案例又很少，学习难度增大。
20年刚入行开始学动画的时候也是选的 [Animejs](https://animejs.cn/documentation/)，可能当时还没崛起。很多功能并没有GSAP那么全面，不过现在看起来。Animejs才是真正的神，这几年社区发展的很快，很多功能也都赶上了，更重要的是有 中文文档，案例也都很完善，建议大家少走弯路，直接选它👍！
这里不做过多陈述，建议直接点击↗右上角📕文章链接查看
$info_md$ where slug = '/external/Animejs-draggable导航拖拽切换';

update public.works_meta set info_md = $info_md$
在animejs官网右上角赞助看到的效果，感觉很有意思就尝试复现了下，顺便巩固了下动画知识(๑•̀ㅂ•́)و✧
$info_md$ where slug = '/external/animejs-鼠标跟随赞助爱心';

update public.works_meta set info_md = $info_md$
起初打算用 [shape-outside](https://developer.mozilla.org/zh-CN/docs/Web/CSS/shape-outside) 来让内容环绕按钮，但后面发现实现效果不如 浮动float 来的直接。而且网上也有现成的大佬踩坑实现，所以直接捡漏🎉。
其中有2种实现方式，`input type="checkbox"` 但都是通过结合复选框的选中状态，控制展开收起操作。
1.`-webkit-line-clamp` 内容限制为指定的行数；
2.`max-height` 控制内容最大高度，超出隐藏。给按钮模拟添加...，达到省略效果（此方式有 transition 过渡效果）；
$info_md$ where slug = '/external/css-文本溢出展开收起';

update public.works_meta set info_md = $info_md$
想要达到这种效果一般还是用js比较常见，此处主要用到的是css得新特性 [timeline-scope](https://developer.mozilla.org/en-US/docs/Web/CSS/timeline-scope#result) 时间线范围。不过兼容性不是很好，大家谨慎使用，或许以后就支持了呢~
不太懂得建议大家可以查看文章链接，文章中作者有更加详细的说明哦🙄。
`href="#t1"` `id="t1"`：通过id匹配方式，在点击a标签导航栏时自动锚点到对应位置;
`scroll-behavior: smooth` 页面的滚动会以平滑的动画效果进行过渡，而不是瞬间跳转到目标位置;
通过关联 `view-timeline-name` `animation-timeline` ，监测到元素在可视区（content）中给a标签加上动画效果;
$info_md$ where slug = '/external/css-电梯导航栏';

update public.works_meta set info_md = $info_md$
🧨快过年了，后端的知识点看不进去，又来琢磨css了。本来想写其它效果的，歪打正着搞出来了这个，还是很奇妙的。主要是通过兄弟选择器 `+`  来达到点击时其他视图的变化效果。其中难点在于如何点击后者，控制之前的兄弟标签（基本上网上给的答案都是不能实现的），但是可以间接通过 [:has](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:has) 和 [:not](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:not) 选择器来配合实现。
以下这段是点击第4张元素，控制第3张元素的css代码（🙄你也可以理解为在第3张元素事先满足这些条件下，会有这种效果）。
`.x:nth-child(1):not(.y:checked)+*+.x:nth-child(3):not(.y:checked):has(+ .x .y:checked) .z`
1. 控制 /①元素（不是选中）+ ②元素（不是选中）+ ③元素（没有选中）但存在（+ ④元素被选中）/时满足以上条件的③元素样式；
2. 即便我们不能直接控制之前的元素，但是我们可以事先要求之前的元素满足一定条件，来达到提前预判；
$info_md$ where slug = '/external/css-视图切换';

update public.works_meta set info_md = $info_md$
今天发现一个很有意思的效果，起初认为只有canvas或者webGL才能实现。后来发现原来css也可以达到这种效果，主要用的是css的新特性 [:has()](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:has) 伪类选择器。
`.item + *`：.item 标签往下(之后)相邻的兄弟标签;
`.item + * + *`：.item 标签往下(之后) +1 相邻的兄弟标签;
`.item:hover + *`：当鼠标悬停在 .item 标签时，往下(之后)相邻的兄弟标签样式将会变化;
`.item:has(+ *)`：.item 标签往上(之前)相邻的兄弟标签;
`.item:has(+ :hover)`：当鼠标悬停在 .item 标签时，往上(之前)相邻的兄弟标签样式将会变化;
$info_md$ where slug = '/external/css-鼠标经过卡片时波纹效果';

update public.works_meta set info_md = $info_md$
这是一个很有意思的效果，有时可以用于产品或者照片墙的展示。主要是结合 GSAP 中的 ScrollTrigger，加上css的3D旋转等实现。你也可以 [👉点击这里](https://tympanus.net/codrops/2024/10/16/staggered-3d-grid-animations-with-scroll-triggered-effects/) ，参考原网站的作品效果。
1.通过grid布局创建2列标签块，定义好每个块的样式大小，以及设置好一些css 3D旋转属性。例如: `transform-style: preserve-3d;` `perspective`；
2.方法 isLeftSide 用来判断2列块的左右，用于设置 `rotateZ，skewX，x` 左右的旋转/倾斜/偏移；
3.为每个块创建一个带有ScrollTrigger的GSAP时间轴timeline动画，其中设置 `scrub: true`至关重要，这样才能把动画的执行和滚动操作绑定起来；
4.`.from` 为每个块定义之前的效果（你不用担心中途样式该如何定义，因为创建块时就是它最初的状态， **.from< 初始状态 <.to**）
5.`.to` 为每个块定义之后的效果（你可以理解为之前和之后时的效果是相反的，想要达到圆环的效果，是可以这么做的）
$info_md$ where slug = '/external/gsap-3d圆环交错视图滚动';

update public.works_meta set info_md = $info_md$
当你有100个标签，想要每个交错或者递增执行某一个动画，在CSS中你可能会想到使用 **animation-delay** 来实现。但是 **GSAP-stagger** 更加便捷，而且有更多的属性（axis）来支持你从头、从左、从上、从中间等来执行交错动画。
`stagger: {...}`：这是一个变量，它用于创建一个错开的动画。在这个例子中，每个path元素的动画将会错开开始。
`repeat: -1`：指定了动画的重复次数。-1表示动画将无限重复。
`amount: 1`：指定的是所有动画之间的总延迟时间，而不是每个动画的持续时间。
例如，如果你有10个path元素，amount属性的值是1秒，那么每个动画之间的延迟时间将会是0.1秒（1秒除以10）。这样，第一个动画将立即开始，第二个动画将在0.1秒后开始，第三个动画将在0.2秒后开始，以此类推，直到最后一个动画在0.9秒后开始。
`yoyo: true`：指定了动画是否应该在每次重复时反向播放。true表示动画将在每次重复时反向播放。
`from: "end"`：指定了动画的开始位置。"end"表示动画将从path元素的末尾开始。
`each: 0.5`：用于指定每个动画之间的延迟时间。这个值是固定的，不会因为目标元素的数量而改变。
例如，如果你有10个path元素，each属性的值是0.5秒，那么每个动画之间的延迟时间将会是0.5秒。这样，第一个动画将立即开始，第二个动画将在0.5秒后开始，第三个动画将在1秒后开始，以此类推，直到最后一个动画在4.5秒后开始。
$info_md$ where slug = '/external/gsap-stagger交错动画';

update public.works_meta set info_md = $info_md$
想要实现这种效果的形式有很多：
方式1：你需要有一张文字背景图片或svg，通过`background-image`引入，加上`background-clip: text;`背景文字裁切来实现。可搜索关键字**'文字效果'**来查看。
👍方式2：你可以通过`mix-blend-mode: screen;`滤色模式，具体做法是把两个颜色都反相，相乘，然后再反相。简单记忆为"让白更白，而黑不变"。当然弊端😔就是背景都需要是纯白色。
$info_md$ where slug = '/external/mix-blend-mode混合模式-重复文字背景';

update public.works_meta set info_md = $info_md$
优惠券，入场券等，有时UI会设计这种圆角裁边的效果。大部分情况，我们会直接取背景色用⚪覆盖实现效果。
而此处则可以达到镂空效果，可以达到真实的裁边效果，以下为重点实现代码。
`radial-gradient(circle..top left)`：背景径向渐变，控制圆的大小以及初始位置。背景径向渐变有2个，一个是上左，一个是下右方；
`background-size: 100% 51%;`：因为有2个径向渐变，为保证镂空处不被另一方给覆盖，所以会让y轴设置为51%，刚好达到交界结合效果；
`background-repeat: no-repeat;`： 设置不允许重叠，避免默认重叠不能实现该效果。
$info_md$ where slug = '/external/radial-gradient圆角裁边入场券';

update public.works_meta set info_md = $info_md$
今天网上看到有类似文章，发现自己之前也是实现过类似方法，但是回过头来却有点看不懂了😔。所以大家还是要多复习复习。
`radial-gradient` 径向渐变 radial-gradient(100px at {x}px {y}px, rgba(186, 10, 244, 0.5), rgba(255, 255, 255, 0));
`100px 渐变半径` 颜色从中心点开始按照设定的颜色节点进行过渡，在半径为 100px 的范围内完成整个渐变效果;
`x,y` 圆心的中心点坐标位置;
给每个按钮都设置一个径向渐变的背景，监听鼠标位置，因此在你移动时，所有的背景都在跟着移动和位置坐标变化，只是超出容器范围的背景不会展示而已。
$info_md$ where slug = '/external/radial-gradient按钮周围边框高亮';

update public.works_meta set info_md = $info_md$
**remove black pixels from element (filter)**/从元素(滤镜)中移除黑色像素
如上所属，默认文字颜色是黑色，通过标签滤镜filter来过滤掉黑色像素，从而实现镂空文字的效果。
当然如果你想实现镂空效果，也可以搜索关键字 **'探照灯'**（通过svg-clipPath-text）、**'镂空文字'**（mask遮罩层）来看其他实现方案。
`feColorMatrix`是SVG的一个滤镜原语，它可以对图形的颜色进行复杂的操作。它通过将每个像素的颜色值（RGBA）与一个矩阵进行相乘来改变颜色;
`feColorMatrix`该滤镜用来侵蚀或扩张输入的图像;
`feComposite`该滤镜执行两个输入图像的智能像素组合;
$info_md$ where slug = '/external/svg-filter镂空文字';

update public.works_meta set info_md = $info_md$
公司项目中需要实现一个页面装修的功能，结合原有的项目思路 + ai（Trae），重新搭建了一个优化后的页面装修demo。
目前包括以下功能🥳：
1.`拖拽排序`: 支持组件预览区域拖拽排序
2.`添加删除`：支持组件选择添加，预览区右上角删除
3.`页面发布`：发布支持json格式数据输出
4.`预览功能`：支持实时预览，预览区右上角切换预览模式
5.`组件选择`：轮播图、新闻列表、锚点导航...
6.`尺寸编辑`：支持组件尺寸编辑
7.`素材库选择`：支持从素材库选择图片，跨页签实时同步选择数据
🐱‍🏍更多内容尽情期待，可以多关注 [github](https://github.com/sunwenxu1997/decoration-demo) 更新~
$info_md$ where slug = '/external/vue-组件页面装修demo';

update public.works_meta set info_md = $info_md$
rotateX = -(鼠标 y 坐标 - 元素左上角 y 坐标 - 元素高度的一半)deg / multiple(幅度);
rotateY =  (鼠标 x 坐标 - 元素左上角 x 坐标 - 元素宽度的一半)deg / multiple(幅度);
`mousemove``mouseleave`：监听鼠标移动和移出,控制卡片的偏移;
`transform-style: preserve-3d`：控制css的transform属性来实现标签的3D旋转;
$info_md$ where slug = '/external/卡片3D旋转跟随效果';

update public.works_meta set info_md = $info_md$
很早的时候有了解过陀螺仪的知识点，当初想着用js在网页端实现，奈何很多兼容性问题导致后面不了了之了。
近期在做小程序的一些需求时，有发现官方提供的[👉wx.onGyroscopeChange](https://developers.weixin.qq.com/miniprogram/dev/api/device/gyroscope/wx.onGyroscopeChange.html) ，调研之后发现是可以达到我的预期效果的😁。(虽然后面产品没采纳😑，但是学到了，以后贺卡，产品展示等也都可以用到~)
1.`wx.onGyroscopeChange` 微信官方提供的陀螺仪监听api，返回`x，y，z`分别为不同轴转动方向的角速度；
2.`角速度（rad/s）× 时间（s）= 旋转角度（rad）` 关键是如何拿到时间差，通过每次监听数据变化时的本次时间和上次时间戳获取；
3.`旋转角度 × 转换系数 = 位移偏移量` 拿到了角度，再根据自定义的转换系数，就得到了位移偏移量了🎉;
$info_md$ where slug = '/external/微信小程序实现陀螺仪卡片景深效果';

update public.works_meta set info_md = $info_md$
基于 GSAP `Draggable` 插件实现的图片细节放大镜效果，小窗口和大图视图双向同步联动。
知识点：
1. `Draggable.create()` 创建可拖拽实例，设置 `bounds` 限制范围
2. `gsap.quickSetter()` 高性能属性设置器
3. 通过 `imageScale` 比例换算实现大小视图位置同步
$info_md$ where slug = '/gsap/draggable-细节放大镜';

update public.works_meta set info_md = $info_md$
基于 `ScrollTrigger` 监听滚动速率，动态控制元素的 `skewY` 倾斜角度，实现滚动时的倾斜特效。
知识点：
1. `self.getVelocity()` 获取实时滚动速率
2. `gsap.quickSetter()` 批量设置 skewY 变换
3. `gsap.utils.clamp()` 限制倾斜角度范围（-20° ~ 20°）
4. 只在倾斜更严重时才干预，避免减速时的跳变
$info_md$ where slug = '/gsap/scrollTrigger-倾斜滚动特效';

update public.works_meta set info_md = $info_md$
基于 `ScrollTrigger` 将纵向滚动转化为横向滚动效果，常用于产品展示、画廊等场景。
知识点：
1. `pin: true` 钉住容器，`scrub: true` 动画进度与滚动同步
2. `xPercent: -100 * (n-1)` 横向位移总距离
3. `snap: 1/(n-1)` 滚动吸附到每个面板
4. `end: '+=5000'` 控制总滚动距离
$info_md$ where slug = '/gsap/scrollTrigger-横屏滚动';

update public.works_meta set info_md = $info_md$
结合 `ScrollTrigger` 和 `Three.js` 烟雾粒子效果，通过滚动进度控制烟雾的消散动画。
知识点：
1. `ScrollTrigger` 的 `pin: true` + `onUpdate` 获取滚动进度
2. `smoke.progress` 将滚动进度映射到 Three.js 烟雾动画
3. `self.getVelocity()` 获取滚动速度用于增强效果
$info_md$ where slug = '/gsap/scrollTrigger-烟雾消散效果';

update public.works_meta set info_md = $info_md$
使用 `Three.js` 渲染烟雾/云层粒子效果，配合时间段动态切换天空渐变色背景。
知识点：
1. Three.js 烟雾粒子 Canvas 渲染
2. `mix-blend-mode: screen` 混合模式让烟雾与背景融合
3. 根据当前时间（`getHours()`）切换不同天空渐变色
4. `contain: strict` 性能优化
$info_md$ where slug = '/gsap/scrollTrigger-烟雾飘过效果';

update public.works_meta set info_md = $info_md$
基于 `ScrollTrigger` 将滚动进度映射到视频播放进度，实现视频帧跟随滚动的效果。
知识点：
1. `ScrollTrigger` 的 `pin: true` + `onUpdate` 获取进度
2. `video.currentTime = progress * duration` 控制视频帧
3. `self.progress.toFixed(3)` 精确到三位小数
4. 使用 `webm` 格式视频兼容性更好
$info_md$ where slug = '/gsap/scrollTrigger-视频帧跟随滚动';

update public.works_meta set info_md = $info_md$
基于 `ScrollTrigger` 实现元素进入/离开视口时的滑入滑出过渡动画，支持左右交替方向。
知识点：
1. `onEnter` / `onEnterBack` / `onLeave` 回调控制动画触发
2. `gsap.fromTo()` 从偏移位置过渡到原位
3. `autoAlpha` 同时控制透明度和可见性
4. 通过 class 区分从左/从右进入方向
$info_md$ where slug = '/gsap/scrollTrigger-简单过渡效果';

update public.works_meta set info_md = $info_md$
通过多层文字叠加 + `perspective` 3D 透视 + 鼠标跟踪，实现光影随鼠标偏移的文字特效。
知识点：
1. `perspective: 2000px` + `translateZ` 构建 3D 层级
2. `background-clip: text` 将径向渐变裁剪到文字
3. `gsap.to()` 控制 `rotationX/Y` 实现 3D 旋转跟随
4. `radial-gradient` 动态计算光源位置
$info_md$ where slug = '/gsap/光影文字特效';

update public.works_meta set info_md = $info_md$
通过多张图片的方式模拟视频动画，通过滚动条平滑过渡，控制图片播放。相比于直接控制视频进度动画可能会好一点。
实现原理：
主要是通过 `gsap + scrollTrigger` 来实现的，通过控制 playhead 对象参数的 frame(图片index) 从0到最后一张图片的过程来实现图片的播放动画。
$info_md$ where slug = '/gsap/多张图片伪视频动画';

update public.works_meta set info_md = $info_md$
使用 GSAP 实现数字从 0 动态递增的加载效果，支持整数、小数和金额格式化三种模式。
知识点：
1. `gsap.to(proxy)` 通过代理对象实现数值动画
2. `Math.ceil()` 向上取整控制显示精度
3. 直接操作 `innerHTML` 的替代方案
4. 金额千位分隔符正则：`/(\d)(?=(?:\d{3})+$)/g`
$info_md$ where slug = '/gsap/数字加载效果';

update public.works_meta set info_md = $info_md$
通过 SVG `clipPath` 将文字作为裁剪路径，多个彩色圆灯跟随鼠标移动，形成探照灯透过文字的效果。
知识点：
1. SVG `<clipPath>` + `<text>` 定义文字裁剪区域
2. `gsap.to()` + `back` 缓动让圆灯平滑跟随鼠标
3. 多个不同大小的彩色圆 + `opacity` 叠加形成光影效果
$info_md$ where slug = '/gsap/文字探照灯效果';

update public.works_meta set info_md = $info_md$
结合 GSAP 弹性动画 + SVG `goo` 滤镜，实现水滴融合效果的按钮 hover 交互。
知识点：
1. SVG `feGaussianBlur` + `feColorMatrix` 实现 goo 粘性滤镜
2. `gsap.to()` + `elastic` 缓动函数模拟弹性运动
3. 多个球体不同方向和速度形成水滴散开/聚合效果
4. `filter: url('#shadowed-goo')` 应用 SVG 滤镜
$info_md$ where slug = '/gsap/水滴按钮效果';

update public.works_meta set info_md = $info_md$
通过多层 SVG 叠加 + 鼠标跟踪位移，实现 2.5D 深度视差效果。不同层级按不同系数偏移，营造空间感。
知识点：
1. 多层 SVG 绝对定位叠加，`filter: drop-shadow()` 增加层次
2. `gsap.to(layer, { x, y })` 根据鼠标位置偏移各层
3. 偏移系数 `x * i * 0.02` 随层级递增
4. `perspective` 和 `scale(1.1)` 避免边缘露出
$info_md$ where slug = '/gsap/深度视觉差效果';

update public.works_meta set info_md = $info_md$
监听鼠标移动，动态计算鼠标相对于每个按钮的位置，通过 `radial-gradient` 实现跟随高亮效果。
知识点：
1. `mousemove` + `offsetLeft/offsetTop` 计算相对坐标
2. `radial-gradient(100px at x y, ...)` 动态径向渐变
3. `gsap.to()` + `back` 缓动平滑过渡
4. `backgroundImage` 作为动画属性
$info_md$ where slug = '/gsap/鼠标跟随高亮按钮效果';

update public.works_meta set info_md = $info_md$
使用 Canvas 2D API 绘制多层波浪动画，通过贝塞尔曲线和不同周期实现自然起伏效果。
知识点：
1. `quadraticCurveTo()` 绘制二次贝塞尔曲线
2. 多层 Canvas 叠加，不同颜色和周期（`setTimeout` 间隔）
3. `offset` 偏移量实现波浪水平运动
4. `scaleY(-1)` 翻转 Canvas 让波浪朝上
$info_md$ where slug = '/other/canvas-波浪背景';

update public.works_meta set info_md = $info_md$
通过 Canvas 读取 SVG/图片像素数据，将每个像素转化为粒子，支持鼠标靠近时冲散和自动聚合效果。
知识点：
1. `drawImage()` 绘制图片 + `getImageData()` 获取像素数据
2. `Particle` 类封装粒子属性（位置/速度/半径/方向）
3. `requestAnimationFrame` 驱动动画循环
4. 鼠标距离检测实现冲散效果，`drag` 参数控制聚合速度
$info_md$ where slug = '/other/canvas-粒子svg浮层';

update public.works_meta set info_md = $info_md$
使用 [Slidev](https://sli.dev/) 搭建的 Markdown 驱动演示文稿，通过 iframe 嵌入展示。
知识点：
1. Slidev 基于 Vite + Vue + Markdown
2. 支持代码高亮、动画、LaTeX 等
3. `npx slidev` 启动开发服务器
$info_md$ where slug = '/other/slidev简单使用';

update public.works_meta set info_md = $info_md$
集成 [WangEditor v5](https://www.wangeditor.com/v5/for-frame.html#vue3) 富文本编辑器，支持 Vue 3 `v-model` 双向绑定。
知识点：
1. `@wangeditor/editor` + `@wangeditor/editor-for-vue` 安装
2. 自定义工具栏和图片上传配置
3. `v-model` 绑定编辑器 HTML 内容
$info_md$ where slug = '/other/富文本编辑器-wangeditor';

update public.works_meta set info_md = $info_md$
经典九宫格抽奖效果，通过定时器控制高亮位置循环移动，先加速后减速停在目标位置。
知识点：
1. `setTimeout` 递归调用实现变速循环
2. `speed` 动态调整：加速阶段 `speed -= 10`，减速阶段 `speed += 20`
3. `cycle` 控制最少转动次数后再确定中奖位置
4. 支持指定结果和随机两种模式
$info_md$ where slug = '/other/抽奖-九宫格';

update public.works_meta set info_md = $info_md$
大转盘抽奖效果，CSS `@keyframes` 动画驱动旋转，支持动态奖品数量和 CSS 变量控制。
知识点：
1. CSS `var(--nums)` 动态计算旋转角度
2. `skew` 变换实现扇形背景
3. `animation-fill-mode: both` 保持动画终态
4. `classList.remove/add` 技巧实现动画重播
$info_md$ where slug = '/other/抽奖-大转盘';

update public.works_meta set info_md = $info_md$
3D 老虎机抽奖效果，使用 CSS `rotateX` + `translateZ` 构建 3D 圆柱滚动动画。
知识点：
1. `transform-style: preserve-3d` + `perspective` 构建 3D 场景
2. `rotateX` + `translateZ` 排列奖品到圆柱面
3. 三个轮盘不同 `animation-delay` 依次停止
4. CSS 变量 `var(--nums)` 动态适配奖品数量
$info_md$ where slug = '/other/抽奖-老虎机';

update public.works_meta set info_md = $info_md$
鼠标水平滑动控制左右两个面板的分割位置，实现明暗对比的动态分割背景效果。
知识点：
1. 两个绝对定位面板叠加，左侧 `z-index` 更高
2. `mousemove` 监听 + `clientX/innerWidth` 计算百分比
3. 动态修改 `width` 实现分割线跟随
4. 纯 CSS + 极简 JS 实现
$info_md$ where slug = '/other/滑动分割背景';

update public.works_meta set info_md = $info_md$
封装的自定义拖拽滑块组件 `SliderPlan`，支持 `v-model` 双向绑定和自定义渐变色。
知识点：
1. Vue 组件 `v-model:planNum` 自定义 prop 绑定
2. 渐变色 `:color` prop 支持单色/双色渐变
3. 拖拽交互 + 数值实时反馈
$info_md$ where slug = '/other/自定义拖拽滑块';

update public.works_meta set info_md = $info_md$
多用于导航栏文字效果，让人感觉有种吸附的效果，主要用的就是监听鼠标得移入移出。
知识点：
1. `addEventListener`监听进入按钮时得 mousemove mouseleave
2. `rotate3d(x, y, z, angle)`
x：表示绕着X轴旋转的角度。
y：表示绕着Y轴旋转的角度。
z：表示绕着Z轴旋转的角度。
angle：表示旋转的角度，单位为度（deg）
$info_md$ where slug = '/other/鼠标吸附按钮效果';

update public.works_meta set info_md = $info_md$
鼠标移入按钮时播放音效，利用 HTML5 `<audio>` 元素实现简单的交互音效。
知识点：
1. `mouseenter` 事件触发音频播放
2. `audio.load()` + `audio.play()` 控制播放
3. 浏览器安全策略：需要用户首次点击授权后才能播放音频
$info_md$ where slug = '/other/鼠标经过发出声音';

update public.works_meta set info_md = $info_md$
SVG 兔子剪影 + `textPath` 文字环绕动画的新年贺卡效果，路径片段随机淡入淡出。
知识点：
1. SVG `<path>` 拼接兔子剪影
2. `<textPath>` + `<animate>` 实现文字沿路径滚动
3. SCSS `@for` 循环 + `random()` 为每个路径片段生成随机动画延迟
$info_md$ where slug = '/svg/2023兔年大吉';

update public.works_meta set info_md = $info_md$
起初对玻璃滤镜这种概念并没有。一直以为只能用图片实现，直到后来发现有些网站上通过 **WebGl** 可以实现，因此就比较痴迷于它了。但是往往代码比较复杂，对于我这种菜鸡来说还没到那一层，于是就想到了如何通过svg滤镜来实现。终于功夫不负有心人，被我搞出来了。但是也有一些不足，就是对玻璃纹路尺寸大小有要求，太小的纹理图片无法重复平铺，且无法占满。so，搞得时候搞大点。这里简单给到效果给大家。
知识点：
1. `svg filter`svg滤镜
2. `feImage`滤镜从外部来源取得图像数据，并提供像素数据作为输出（意味着如果外部来源是一个 SVG 图像，这个图像将被栅格化。） 。
3. `feDisplacementMap`映射置换滤镜，该滤镜用来自图像中从in2 (en-US)到空间的像素值置换图像从in到空间的像素值。
$info_md$ where slug = '/svg/svg-多种玻璃图案';

update public.works_meta set info_md = $info_md$
SVG `textPath` 文字沿路径环绕动画 + `clip-path` 路径裁剪填充文字内容。
知识点：
1. `<textPath xlink:href>` 让文字沿 SVG 路径排列
2. `<animate startOffset>` 驱动文字滚动动画
3. `clip-path: url('#clip-path')` 用同一路径裁剪文本区域
$info_md$ where slug = '/svg/svg-文字环绕效果';

update public.works_meta set info_md = $info_md$
通过 SVG `stroke` 属性和 `dash-array` 动画，实现多种文字描边/边框效果。
知识点：
1. `stroke` + `stroke-width` 文字描边
2. `stroke-dasharray` + `stroke-dashoffset` 虚线动画
3. `stroke-linejoin: round` 圆角描边
4. `<symbol>` + `<use>` 复用 SVG 元素 + 多层不同颜色动画
$info_md$ where slug = '/svg/svg-文字边框效果';

update public.works_meta set info_md = $info_md$
使用 SVG `feTurbulence` 噪声滤镜 + `feDisplacementMap` 置换映射，实现水面波纹效果。
知识点：
1. `feTurbulence type='fractalNoise'` 生成分形噪声
2. `feDisplacementMap` 根据噪声偏移像素实现波纹
3. `feColorMatrix hueRotate` + `<animate>` 动态色相旋转
4. `scale` 属性控制波纹强度
$info_md$ where slug = '/svg/svg-波纹效果';

update public.works_meta set info_md = $info_md$
使用 SVG `goo` 滤镜实现小球的粘性聚合/分离动画效果，点击切换状态。
知识点：
1. `feGaussianBlur` + `feColorMatrix` 组合实现 goo 粘性效果
2. `feColorMatrix` 矩阵值 `0 0 0 18 -7` 提高对比度让模糊后的元素重新锐化
3. CSS `transition` 控制小球位置过渡
4. `filter: url('#shadowed-goo')` 应用滤镜
$info_md$ where slug = '/svg/svg滤镜粘性小球';

update public.works_meta set info_md = $info_md$
知识点：
`feGaussianBlur`高斯模糊。
`in`: in属性标识给定过滤器原语的输入。
`stdDeviation`👍: 它定义了平滑模糊操作的标准偏差，默认值为0。2个参数时为(水平，垂直)模糊方向
`edgeMode`: 它表示输入层边的多余像素。
$info_md$ where slug = '/svg/svg滤镜运动模糊';

update public.works_meta set info_md = $info_md$
基于 `Three.js` + `displacement map` 置换贴图实现图片间的玻璃扭曲过渡切换效果。
知识点：
1. Three.js `hoverEffect` 库封装了 WebGL 图片过渡
2. `displacementImage` 置换贴图控制像素偏移方向
3. `intensity` / `speedIn` / `speedOut` 控制过渡参数
4. 16 种不同置换贴图实现不同扭曲风格
$info_md$ where slug = '/three/webGL-玻璃效果切换';
commit;

-- 校验：预期 0 条（有 info_html 但没有 info_md 的记录）
-- select count(*) from public.works_meta where info_html is not null and info_md is null;

-- 抽样对比
-- select slug, left(info_md, 120) from public.works_meta where info_md is not null order by slug limit 5;
