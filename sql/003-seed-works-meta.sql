-- ================================================================
-- works_meta 初始数据导入（从本地 .vue 元数据提取）
-- 共 53 条记录
-- 执行方式：Supabase Dashboard → SQL Editor → Run
-- ================================================================

-- 防止重复导入：先按 slug 清理已有记录
DELETE FROM works_meta WHERE slug = '/anime/anime-切割模糊文字';
DELETE FROM works_meta WHERE slug = '/anime/anime-切割波浪文字';
DELETE FROM works_meta WHERE slug = '/anime/anime-礼花彩带效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/3D弹跳表情';
DELETE FROM works_meta WHERE slug = '/cssHtml/backdrop-filter-磨砂玻璃效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/css-碰撞检测';
DELETE FROM works_meta WHERE slug = '/cssHtml/filter-文字背景溶解效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/mask-网点图';
DELETE FROM works_meta WHERE slug = '/cssHtml/mask-镂空文字';
DELETE FROM works_meta WHERE slug = '/cssHtml/tailwindcss使用';
DELETE FROM works_meta WHERE slug = '/cssHtml/循环六边形背景效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/循环滚动背景效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/文字效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/文字极光动画';
DELETE FROM works_meta WHERE slug = '/cssHtml/文字背景进度';
DELETE FROM works_meta WHERE slug = '/cssHtml/碎裂文字效果';
DELETE FROM works_meta WHERE slug = '/cssHtml/网格布局家具背景';
DELETE FROM works_meta WHERE slug = '/cssHtml/网格背景效果';
DELETE FROM works_meta WHERE slug = '/gsap/draggable-细节放大镜';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-倾斜滚动特效';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-头部导航栏收缩';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-横屏滚动';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-烟雾消散效果';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-烟雾飘过效果';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-简单过渡效果';
DELETE FROM works_meta WHERE slug = '/gsap/scrollTrigger-视频帧跟随滚动';
DELETE FROM works_meta WHERE slug = '/gsap/光影文字特效';
DELETE FROM works_meta WHERE slug = '/gsap/多张图片伪视频动画';
DELETE FROM works_meta WHERE slug = '/gsap/数字加载效果';
DELETE FROM works_meta WHERE slug = '/gsap/文字探照灯效果';
DELETE FROM works_meta WHERE slug = '/gsap/水滴按钮效果';
DELETE FROM works_meta WHERE slug = '/gsap/深度视觉差效果';
DELETE FROM works_meta WHERE slug = '/gsap/鼠标跟随高亮按钮效果';
DELETE FROM works_meta WHERE slug = '/other/canvas-波浪背景';
DELETE FROM works_meta WHERE slug = '/other/canvas-粒子svg浮层';
DELETE FROM works_meta WHERE slug = '/other/slidev简单使用';
DELETE FROM works_meta WHERE slug = '/other/富文本编辑器-wangeditor';
DELETE FROM works_meta WHERE slug = '/other/抽奖-九宫格';
DELETE FROM works_meta WHERE slug = '/other/抽奖-大转盘';
DELETE FROM works_meta WHERE slug = '/other/抽奖-老虎机';
DELETE FROM works_meta WHERE slug = '/other/滑动分割背景';
DELETE FROM works_meta WHERE slug = '/other/自定义拖拽滑块';
DELETE FROM works_meta WHERE slug = '/other/鼠标吸附按钮效果';
DELETE FROM works_meta WHERE slug = '/other/鼠标经过发出声音';
DELETE FROM works_meta WHERE slug = '/svg/2023兔年大吉';
DELETE FROM works_meta WHERE slug = '/svg/svg-多种玻璃图案';
DELETE FROM works_meta WHERE slug = '/svg/svg-文字环绕效果';
DELETE FROM works_meta WHERE slug = '/svg/svg-文字边框效果';
DELETE FROM works_meta WHERE slug = '/svg/svg-波纹效果';
DELETE FROM works_meta WHERE slug = '/svg/svg-褶皱纸张';
DELETE FROM works_meta WHERE slug = '/svg/svg滤镜粘性小球';
DELETE FROM works_meta WHERE slug = '/svg/svg滤镜运动模糊';
DELETE FROM works_meta WHERE slug = '/three/webGL-玻璃效果切换';

-- 批量插入
INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/anime/anime-切割模糊文字', 'anime-切割模糊文字', 'https://iili.io/K99P0Cv.gif', '近期网上看到的一个效果，实现起来也很简单。同时挖掘到了一个很牛的[Filip Zrnzevic😎大佬](https://codepen.io/filipz)，写的效果都很炫酷。
           `animejs-text` 官方提供的文本 [分割插件](https://animejs.cn/documentation/text/split/split-parameters/class)，相比于GSAP是不额外收费的，不过animejs版本要在4.0以上；
           `fractalNoise` background-image 引入本地定义好的噪点svg，通过重复动画随即修改 background-size 实现噪点波动效果', NULL, NULL, 'https://codepen.io/sunwenxu1997/pen/RNWMXOr', NULL, '2025-08-21', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/anime/anime-切割波浪文字', 'anime-切割波浪文字', 'https://iili.io/FsuNQu1.gif', '闲逛掘金时发现的一个好玩效果🌊，作者是通过scss实现的动画效果，这里我尝试用 animejs 做了实现。
           `.cloneNode:` 克隆复制dom节点，批量创建26（涉及到后面的裁切，这个数量基本能达到100%的裁切）个文字元素层；
           `clip-path:` 第一块裁切比例 clip-path: polygon(-30% 0, -20% 0, 20% 100%, 0% 100%)，clip-path: polygon(-25% 0, -15% 0, 25% 100%, 5% 100%)，以此类推...
           动画执行时间和旋转角度这些就不做过多陈述了，基本都是经过实践得到的最优效果👻', NULL, 'https://juejin.cn/post/7412490116793909286', 'https://codepen.io/sunwenxu1997/pen/pvjrzew', NULL, '2025-08-08', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/anime/anime-礼花彩带效果', 'anime-礼花彩带效果', 'https://iili.io/FeMPOKP.gif', '近期将要做活动中奖相关需求，就想着能不能做一个这种效果。因为之前有见过类似🎉喷洒的动画，后来找又找不到了，其次看到网上的效果也不是很理想，所以就考虑打算自己手搓一个。
         实际效果还可以，主要还是通过animejs动画控制，创建很多随机的彩带元素。点击绽放的效果不是特别流畅，后期可以根据animejs提供不同的 [缓动函数Easings](https://codepen.io/juliangarnier/pen/gbOqbVR) 来调整优化。', NULL, 'https://juejin.cn/post/7534935432866988072', 'https://codepen.io/sunwenxu1997/pen/raOLjzr', NULL, '2025-07-24', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/3D弹跳表情', '3D弹跳表情', 'https://iili.io/Jq9GrUg.gif', '参考大佬 Chokcoco 的作品，用 Vue3.0 实现了一下，代码比较简单，就不多说了。
  知识点：
  1.通过伪元素制造多层表情标签，制造3D假象；
  2.通过记录下落转向上升的那一帧开始，更换表情和背景；
  3.学会如何通过 `conic-gradient` `linear-gradient` `radial-gradient` 实现多样化的背景效果；', NULL, 'https://juejin.cn/post/7262007830721413180', NULL, NULL, '2023-09-09', 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/backdrop-filter-磨砂玻璃效果', 'backdrop-filter-磨砂玻璃效果', 'https://iili.io/JqJOBO7.png', '之前尝试实现磨砂效果，都会想着用fliter滤镜加模糊实现。但是效果总是那么差点意思，后来css推出了 **backdrop-filter** 属性，值得一试。
    知识点：
    1. `backdrop-filter` 背景模块滤镜，类似于filter
    2. `clip-path: inset(10px)` 相当于整体向内裁切10px', NULL, 'https://juejin.cn/post/6979391400844460068?searchId=20230807153325C066903F9072D51F4CEE', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/css-碰撞检测', 'css-碰撞检测', 'https://iili.io/Jq644b1.gif', '动画新属性 **animation-composition** 的学习，可能实际项目上用不到。
    知识点：
    1. `animation-composition` 动画合成
    2. `steps` 按步执行动画', NULL, 'https://juejin.cn/post/7269797025863499837', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/filter-文字背景溶解效果', 'filter-文字背景溶解效果', 'https://iili.io/JqJOAUQ.png', '想要实现这种效果可以通过svg滤镜，也可以通过模糊和对比度来实现。因为效果展示原因，最终采用了后者。但是也有弊端，就是需要重复一套相同的文本，其中一个是专门用作背景效果使用。更多内容可以直接在代码里了解。
    知识点：
    1. `filter:blur() contrast()`filter滤镜模糊和对比度
    2. `box-decoration-break`属性用来定义当元素跨多行、多列或多页时，元素的片段应如何呈现。', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/mask-网点图', 'mask-网点图', 'https://iili.io/JqJOFUl.png', '通过 CSS `mask` 配合 `linear-gradient` 实现网点网格遮罩效果，底层使用渐变色动画背景。<br>知识点：<br>1. `mask` 遮罩属性，通过渐变定义可见区域<br>2. `mask-size` 控制网格密度<br>3. `linear-gradient` + `background-size` 实现重复网格', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml", "mask"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/mask-镂空文字', 'mask-镂空文字', 'https://iili.io/JqJOTfj.png', '参考 [iCSS](https://github.com/chokcoco/iCSS/issues/80) 的效果，利用 CSS `mask` 引入 SVG 图形作为遮罩，实现文字/图形镂空效果，底层使用背景图 + 模糊滤镜。<br>知识点：<br>1. `mask: url()` 引入 SVG 作为遮罩<br>2. `filter: blur() brightness()` 背景模糊和亮度调节<br>3. `background-size: cover` 背景自适应', NULL, 'https://github.com/chokcoco/iCSS/issues/80', NULL, NULL, NULL, 0, TRUE, '{"cssHtml", "mask"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/tailwindcss使用', 'tailwindcss使用', 'https://iili.io/Jq64QqJ.gif', '项目集成 [TailwindCSS](https://tailwindcss.com/) 的简单示例，通过原子化 CSS 类快速构建页面布局，配合自定义 `AppleWindow` 组件展示效果。<br>知识点：<br>1. `npm install -D tailwindcss` 安装配置<br>2. `tailwind.config.js` 配置模板扫描路径<br>3. 常用工具类：`grid`、`place-content-center`、`h-screen`', NULL, 'https://juejin.cn/post/7290740395914362921', NULL, NULL, NULL, 0, TRUE, '{"cssHtml", "tailwindcss"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/循环六边形背景效果', '循环六边形背景效果', 'https://iili.io/JqJOCb9.png', '可能使用价值不太高，娱乐学习一下~
    知识点：
    1. `clip-path` 路径裁切，实现⑥边形效果
    2. `shape-outside` 说白了就是可以让文本围绕着你定义的样式环绕', NULL, 'https://juejin.cn/post/7186572424807186490', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/循环滚动背景效果', '循环滚动背景效果', 'https://iili.io/Jq64rOP.gif', '很早之前遇到的效果了，当时记得还在为自己搞得小程序登录背景发愁呢。突然发现了这个好看又简约的效果，所以便入手了。主要是根据一小块svg矢量图，然后通过背景重复实现的平铺，再加上背景尺寸和位置的改变，实现了动画效果。
    如果你想改颜色，那建议你下载源地址svg，然后修改fill填充色，你也可以通过上传自己的图片实现效果。', NULL, 'https://juejin.cn/post/7159380028417277966', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字效果', '文字效果', 'https://iili.io/JqJOqRS.png', '🌈属于文字效果，里面有各种样式类型的文本，当然不仅仅可以应用于文字上，你也可以应用在其他地方。首先你要先学会他，不是吗？
    知识点：
    1. `background-clip: text;` 背景文本裁切
    2. `mask` 遮罩层 
    3. `svg，fliter`等效果应用', NULL, 'https://juejin.cn/post/7165675529763454983', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字极光动画', '文字极光动画', NULL, '🌈属于文字效果，但更适合于纯黑色背景，有点局限性。更推荐用背景裁切 [background-clip: text;](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-clip)
    知识点：
    1. `mix-blend-mode` 混合模式
    2. `clamp()` 函数的作用是把一个值限制在一个上限和下限之间，当这个值超过最小值和最大值的范围时，在最小值和最大值之间选择一个值使用。它接收三个参数：最小值、首选值、最大值。', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字背景进度', '文字背景进度', 'https://iili.io/JRauCrl.gif', '今天又是忙碌的一天，今天周二还有生产发布，但是发现这个有意思得效果还是要学习下的！😄
    知识点：
    1. `-webkit-text-fill-color`设置文本的填充颜色，这里建议设置透明度低得，否则颜色过渡上会有冲突
    2. `-webkit-background-clip: text`用于将背景应用到文本内容内部，创建文本填充效果 
    3. `background-size: 0% 100%;`文字进度完成度 x轴控制水平进度，y轴控制垂直进度', NULL, 'http://manifesto.clapat.com/', NULL, NULL, '2023-12-26', 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/碎裂文字效果', '碎裂文字效果', 'https://iili.io/JqJOfJ2.png', '单纯的通过 css+html 实现的碎裂效果。
    知识点：
    1. `clip-path` 路径剪切；
    2. `content: attr(data-text);`文本属性引用；', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/网格布局家具背景', '网格布局家具背景', 'https://iili.io/JqJOxWu.png', '这个效果是在别的网站上看到的，感觉挺新奇的，尤其很适用于一些家具，灯具类分模块的的价格展示。但是局限性其实也很大，因为图片大小、页面定位都有特定的要求，所以有兴趣的也可以学习一下。主要是了解网格布局的使用。
    知识点：
    1. `grid` 网格布局；
    2. `grid-area`网格分区域展示；', NULL, 'https://juejin.cn/post/7160495991789977636', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/网格背景效果', '网格背景效果', 'https://iili.io/JqJOoxe.png', '某一天感觉单纯的背景色有点单一，同时看到掘金有些文章背部有类似网格形状的东西，所以就好奇的尝试实现下。其实原理还是挺简单的，当然你也可以直接通过图片来实现（放大会模糊），但是当你真正掌握后，它不仅仅能实现网格，还有其他更多花样背景呢。
  知识点：
  1. `linear-gradient` 背景渐变；
  2. `background-size` 背景尺寸；
  3. `background-repeat` 背景重复；', NULL, 'https://juejin.cn/post/7160858048636911652', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/draggable-细节放大镜', 'draggable-细节放大镜', 'https://iili.io/Jq64iWg.gif', '基于 GSAP `Draggable` 插件实现的图片细节放大镜效果，小窗口和大图视图双向同步联动。<br>知识点：<br>1. `Draggable.create()` 创建可拖拽实例，设置 `bounds` 限制范围<br>2. `gsap.quickSetter()` 高性能属性设置器<br>3. 通过 `imageScale` 比例换算实现大小视图位置同步', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "draggable"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-倾斜滚动特效', 'scrollTrigger-倾斜滚动特效', 'https://iili.io/Jq64ssa.gif', '基于 `ScrollTrigger` 监听滚动速率，动态控制元素的 `skewY` 倾斜角度，实现滚动时的倾斜特效。<br>知识点：<br>1. `self.getVelocity()` 获取实时滚动速率<br>2. `gsap.quickSetter()` 批量设置 skewY 变换<br>3. `gsap.utils.clamp()` 限制倾斜角度范围（-20° ~ 20°）<br>4. 只在倾斜更严重时才干预，避免减速时的跳变', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "scrollTrigger"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-头部导航栏收缩', 'scrollTrigger-头部导航栏收缩', NULL, '基于 `ScrollTrigger` 监听滚动方向，实现导航栏下拉隐藏、上拉显示的交互效果。<br>知识点：<br>1. `self.direction` 判断滚动方向（1=向下，-1=向上）<br>2. `gsap.from()` + `yPercent: -100` 向上收缩动画<br>3. `.play()` / `.reverse()` 控制动画正向/反向播放', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "scrollTrigger"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-横屏滚动', 'scrollTrigger-横屏滚动', NULL, '基于 `ScrollTrigger` 将纵向滚动转化为横向滚动效果，常用于产品展示、画廊等场景。<br>知识点：<br>1. `pin: true` 钉住容器，`scrub: true` 动画进度与滚动同步<br>2. `xPercent: -100 * (n-1)` 横向位移总距离<br>3. `snap: 1/(n-1)` 滚动吸附到每个面板<br>4. `end: ''+=5000''` 控制总滚动距离', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "scrollTrigger"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-烟雾消散效果', 'scrollTrigger-烟雾消散效果', 'https://iili.io/Jq6Qtgs.gif', '结合 `ScrollTrigger` 和 `Three.js` 烟雾粒子效果，通过滚动进度控制烟雾的消散动画。<br>知识点：<br>1. `ScrollTrigger` 的 `pin: true` + `onUpdate` 获取滚动进度<br>2. `smoke.progress` 将滚动进度映射到 Three.js 烟雾动画<br>3. `self.getVelocity()` 获取滚动速度用于增强效果', NULL, NULL, NULL, NULL, '2023-10-10', 0, TRUE, '{"gsap", "scrollTrigger", "three"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-烟雾飘过效果', 'scrollTrigger-烟雾飘过效果', NULL, '使用 `Three.js` 渲染烟雾/云层粒子效果，配合时间段动态切换天空渐变色背景。<br>知识点：<br>1. Three.js 烟雾粒子 Canvas 渲染<br>2. `mix-blend-mode: screen` 混合模式让烟雾与背景融合<br>3. 根据当前时间（`getHours()`）切换不同天空渐变色<br>4. `contain: strict` 性能优化', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "three", "canvas"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-简单过渡效果', 'scrollTrigger-简单过渡效果', NULL, '基于 `ScrollTrigger` 实现元素进入/离开视口时的滑入滑出过渡动画，支持左右交替方向。<br>知识点：<br>1. `onEnter` / `onEnterBack` / `onLeave` 回调控制动画触发<br>2. `gsap.fromTo()` 从偏移位置过渡到原位<br>3. `autoAlpha` 同时控制透明度和可见性<br>4. 通过 class 区分从左/从右进入方向', NULL, 'https://juejin.cn/post/7165808796462219295', NULL, NULL, NULL, 0, TRUE, '{"gsap", "scrollTrigger"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-视频帧跟随滚动', 'scrollTrigger-视频帧跟随滚动', 'https://iili.io/JRaX80B.gif', '基于 `ScrollTrigger` 将滚动进度映射到视频播放进度，实现视频帧跟随滚动的效果。<br>知识点：<br>1. `ScrollTrigger` 的 `pin: true` + `onUpdate` 获取进度<br>2. `video.currentTime = progress * duration` 控制视频帧<br>3. `self.progress.toFixed(3)` 精确到三位小数<br>4. 使用 `webm` 格式视频兼容性更好', NULL, 'https://juejin.cn/post/7162001311225888782', NULL, NULL, NULL, 0, TRUE, '{"gsap", "scrollTrigger"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/光影文字特效', '光影文字特效', 'https://iili.io/JRSZ1Sf.gif', '通过多层文字叠加 + `perspective` 3D 透视 + 鼠标跟踪，实现光影随鼠标偏移的文字特效。<br>知识点：<br>1. `perspective: 2000px` + `translateZ` 构建 3D 层级<br>2. `background-clip: text` 将径向渐变裁剪到文字<br>3. `gsap.to()` 控制 `rotationX/Y` 实现 3D 旋转跟随<br>4. `radial-gradient` 动态计算光源位置', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "3d"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/多张图片伪视频动画', '多张图片伪视频动画', 'https://iili.io/J7b3Ext.gif', '通过多张图片的方式模拟视频动画，通过滚动条平滑过渡，控制图片播放。相比于直接控制视频进度动画可能会好一点。
  实现原理：
  主要是通过 `gsap + scrollTrigger` 来实现的，通过控制 playhead 对象参数的 frame(图片index) 从0到最后一张图片的过程来实现图片的播放动画。', NULL, 'https://codepen.io/sunwenxu1997/pen/eYXzqpG', NULL, NULL, '2024-01-11', 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/数字加载效果', '数字加载效果', 'https://iili.io/JRahFql.gif', '使用 GSAP 实现数字从 0 动态递增的加载效果，支持整数、小数和金额格式化三种模式。<br>知识点：<br>1. `gsap.to(proxy)` 通过代理对象实现数值动画<br>2. `Math.ceil()` 向上取整控制显示精度<br>3. 直接操作 `innerHTML` 的替代方案<br>4. 金额千位分隔符正则：`/(\d)(?=(?:\d{3})+$)/g`', NULL, 'https://juejin.cn/post/7273680035096494099', NULL, NULL, NULL, 0, TRUE, '{"gsap", "animation"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/文字探照灯效果', '文字探照灯效果', 'https://iili.io/JRaVVB2.gif', '通过 SVG `clipPath` 将文字作为裁剪路径，多个彩色圆灯跟随鼠标移动，形成探照灯透过文字的效果。<br>知识点：<br>1. SVG `&lt;clipPath&gt;` + `&lt;text&gt;` 定义文字裁剪区域<br>2. `gsap.to()` + `back` 缓动让圆灯平滑跟随鼠标<br>3. 多个不同大小的彩色圆 + `opacity` 叠加形成光影效果', NULL, NULL, NULL, NULL, '2023-09-10', 0, TRUE, '{"gsap", "svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/水滴按钮效果', '水滴按钮效果', NULL, '结合 GSAP 弹性动画 + SVG `goo` 滤镜，实现水滴融合效果的按钮 hover 交互。<br>知识点：<br>1. SVG `feGaussianBlur` + `feColorMatrix` 实现 goo 粘性滤镜<br>2. `gsap.to()` + `elastic` 缓动函数模拟弹性运动<br>3. 多个球体不同方向和速度形成水滴散开/聚合效果<br>4. `filter: url(''#shadowed-goo'')` 应用 SVG 滤镜', NULL, 'https://juejin.cn/post/7159379138648735780', NULL, NULL, NULL, 0, TRUE, '{"gsap", "svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/深度视觉差效果', '深度视觉差效果', NULL, '通过多层 SVG 叠加 + 鼠标跟踪位移，实现 2.5D 深度视差效果。不同层级按不同系数偏移，营造空间感。<br>知识点：<br>1. 多层 SVG 绝对定位叠加，`filter: drop-shadow()` 增加层次<br>2. `gsap.to(layer, { x, y })` 根据鼠标位置偏移各层<br>3. 偏移系数 `x * i * 0.02` 随层级递增<br>4. `perspective` 和 `scale(1.1)` 避免边缘露出', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "parallax", "svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/鼠标跟随高亮按钮效果', '鼠标跟随高亮按钮效果', NULL, '监听鼠标移动，动态计算鼠标相对于每个按钮的位置，通过 `radial-gradient` 实现跟随高亮效果。<br>知识点：<br>1. `mousemove` + `offsetLeft/offsetTop` 计算相对坐标<br>2. `radial-gradient(100px at x y, ...)` 动态径向渐变<br>3. `gsap.to()` + `back` 缓动平滑过渡<br>4. `backgroundImage` 作为动画属性', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap", "interaction"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/canvas-波浪背景', 'canvas-波浪背景', NULL, '使用 Canvas 2D API 绘制多层波浪动画，通过贝塞尔曲线和不同周期实现自然起伏效果。<br>知识点：<br>1. `quadraticCurveTo()` 绘制二次贝塞尔曲线<br>2. 多层 Canvas 叠加，不同颜色和周期（`setTimeout` 间隔）<br>3. `offset` 偏移量实现波浪水平运动<br>4. `scaleY(-1)` 翻转 Canvas 让波浪朝上', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "canvas"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/canvas-粒子svg浮层', 'canvas-粒子svg浮层', NULL, '通过 Canvas 读取 SVG/图片像素数据，将每个像素转化为粒子，支持鼠标靠近时冲散和自动聚合效果。<br>知识点：<br>1. `drawImage()` 绘制图片 + `getImageData()` 获取像素数据<br>2. `Particle` 类封装粒子属性（位置/速度/半径/方向）<br>3. `requestAnimationFrame` 驱动动画循环<br>4. 鼠标距离检测实现冲散效果，`drag` 参数控制聚合速度', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "canvas", "svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/slidev简单使用', 'slidev简单使用', NULL, '使用 [Slidev](https://sli.dev/) 搭建的 Markdown 驱动演示文稿，通过 iframe 嵌入展示。<br>知识点：<br>1. Slidev 基于 Vite + Vue + Markdown<br>2. 支持代码高亮、动画、LaTeX 等<br>3. `npx slidev` 启动开发服务器', 'https://github.com/sunwenxu1997/slidev', 'https://juejin.cn/post/7288963700538556470', NULL, NULL, NULL, 0, TRUE, '{"other", "slidev"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/富文本编辑器-wangeditor', '富文本编辑器-wangeditor', 'https://iili.io/JqJOzib.png', '集成 [WangEditor v5](https://www.wangeditor.com/v5/for-frame.html#vue3) 富文本编辑器，支持 Vue 3 `v-model` 双向绑定。<br>知识点：<br>1. `@wangeditor/editor` + `@wangeditor/editor-for-vue` 安装<br>2. 自定义工具栏和图片上传配置<br>3. `v-model` 绑定编辑器 HTML 内容', NULL, 'https://www.wangeditor.com/v5/for-frame.html#vue3', NULL, NULL, NULL, 0, TRUE, '{"other", "editor"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-九宫格', '抽奖-九宫格', NULL, '经典九宫格抽奖效果，通过定时器控制高亮位置循环移动，先加速后减速停在目标位置。<br>知识点：<br>1. `setTimeout` 递归调用实现变速循环<br>2. `speed` 动态调整：加速阶段 `speed -= 10`，减速阶段 `speed += 20`<br>3. `cycle` 控制最少转动次数后再确定中奖位置<br>4. 支持指定结果和随机两种模式', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "lottery"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-大转盘', '抽奖-大转盘', NULL, '大转盘抽奖效果，CSS `@keyframes` 动画驱动旋转，支持动态奖品数量和 CSS 变量控制。<br>知识点：<br>1. CSS `var(--nums)` 动态计算旋转角度<br>2. `skew` 变换实现扇形背景<br>3. `animation-fill-mode: both` 保持动画终态<br>4. `classList.remove/add` 技巧实现动画重播', NULL, 'https://juejin.cn/post/7165676884460568590', NULL, NULL, NULL, 0, TRUE, '{"other", "lottery"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-老虎机', '抽奖-老虎机', NULL, '3D 老虎机抽奖效果，使用 CSS `rotateX` + `translateZ` 构建 3D 圆柱滚动动画。<br>知识点：<br>1. `transform-style: preserve-3d` + `perspective` 构建 3D 场景<br>2. `rotateX` + `translateZ` 排列奖品到圆柱面<br>3. 三个轮盘不同 `animation-delay` 依次停止<br>4. CSS 变量 `var(--nums)` 动态适配奖品数量', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "lottery", "3d"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/滑动分割背景', '滑动分割背景', NULL, '鼠标水平滑动控制左右两个面板的分割位置，实现明暗对比的动态分割背景效果。<br>知识点：<br>1. 两个绝对定位面板叠加，左侧 `z-index` 更高<br>2. `mousemove` 监听 + `clientX/innerWidth` 计算百分比<br>3. 动态修改 `width` 实现分割线跟随<br>4. 纯 CSS + 极简 JS 实现', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "interaction"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/自定义拖拽滑块', '自定义拖拽滑块', NULL, '封装的自定义拖拽滑块组件 `SliderPlan`，支持 `v-model` 双向绑定和自定义渐变色。<br>知识点：<br>1. Vue 组件 `v-model:planNum` 自定义 prop 绑定<br>2. 渐变色 `:color` prop 支持单色/双色渐变<br>3. 拖拽交互 + 数值实时反馈', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "component"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/鼠标吸附按钮效果', '鼠标吸附按钮效果', 'https://iili.io/JRSzVKg.gif', '多用于导航栏文字效果，让人感觉有种吸附的效果，主要用的就是监听鼠标得移入移出。
    知识点：
    1. `addEventListener`监听进入按钮时得 mousemove mouseleave
    2. `rotate3d(x, y, z, angle)`
       x：表示绕着X轴旋转的角度。
       y：表示绕着Y轴旋转的角度。
       z：表示绕着Z轴旋转的角度。
       angle：表示旋转的角度，单位为度（deg）', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/鼠标经过发出声音', '鼠标经过发出声音', NULL, '鼠标移入按钮时播放音效，利用 HTML5 `&lt;audio&gt;` 元素实现简单的交互音效。<br>知识点：<br>1. `mouseenter` 事件触发音频播放<br>2. `audio.load()` + `audio.play()` 控制播放<br>3. 浏览器安全策略：需要用户首次点击授权后才能播放音频', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other", "audio"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/2023兔年大吉', '2023兔年大吉', NULL, 'SVG 兔子剪影 + `textPath` 文字环绕动画的新年贺卡效果，路径片段随机淡入淡出。<br>知识点：<br>1. SVG `&lt;path&gt;` 拼接兔子剪影<br>2. `&lt;textPath&gt;` + `&lt;animate&gt;` 实现文字沿路径滚动<br>3. SCSS `@for` 循环 + `random()` 为每个路径片段生成随机动画延迟', NULL, 'https://juejin.cn/post/7187585110403711033', NULL, NULL, NULL, 0, TRUE, '{"svg", "animation"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-多种玻璃图案', 'svg-多种玻璃图案', 'https://iili.io/JqJO5JV.png', '起初对玻璃滤镜这种概念并没有。一直以为只能用图片实现，直到后来发现有些网站上通过 **WebGl** 可以实现，因此就比较痴迷于它了。但是往往代码比较复杂，对于我这种菜鸡来说还没到那一层，于是就想到了如何通过svg滤镜来实现。终于功夫不负有心人，被我搞出来了。但是也有一些不足，就是对玻璃纹路尺寸大小有要求，太小的纹理图片无法重复平铺，且无法占满。so，搞得时候搞大点。这里简单给到效果给大家。
  知识点：
  1. `svg filter`svg滤镜
  2. `feImage`滤镜从外部来源取得图像数据，并提供像素数据作为输出（意味着如果外部来源是一个 SVG 图像，这个图像将被栅格化。） 。
  3. `feDisplacementMap`映射置换滤镜，该滤镜用来自图像中从in2 (en-US)到空间的像素值置换图像从in到空间的像素值。', NULL, 'https://juejin.cn/post/7299671709475766324', NULL, NULL, '2023-11-03', 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-文字环绕效果', 'svg-文字环绕效果', NULL, 'SVG `textPath` 文字沿路径环绕动画 + `clip-path` 路径裁剪填充文字内容。<br>知识点：<br>1. `&lt;textPath xlink:href&gt;` 让文字沿 SVG 路径排列<br>2. `&lt;animate startOffset&gt;` 驱动文字滚动动画<br>3. `clip-path: url(''#clip-path'')` 用同一路径裁剪文本区域', NULL, 'https://juejin.cn/post/7187585110403711033', NULL, NULL, NULL, 0, TRUE, '{"svg", "animation"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-文字边框效果', 'svg-文字边框效果', NULL, '通过 SVG `stroke` 属性和 `dash-array` 动画，实现多种文字描边/边框效果。<br>知识点：<br>1. `stroke` + `stroke-width` 文字描边<br>2. `stroke-dasharray` + `stroke-dashoffset` 虚线动画<br>3. `stroke-linejoin: round` 圆角描边<br>4. `&lt;symbol&gt;` + `&lt;use&gt;` 复用 SVG 元素 + 多层不同颜色动画', NULL, 'https://juejin.cn/spost/7267092779280695337', NULL, NULL, NULL, 0, TRUE, '{"svg", "animation"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-波纹效果', 'svg-波纹效果', NULL, '使用 SVG `feTurbulence` 噪声滤镜 + `feDisplacementMap` 置换映射，实现水面波纹效果。<br>知识点：<br>1. `feTurbulence type=''fractalNoise''` 生成分形噪声<br>2. `feDisplacementMap` 根据噪声偏移像素实现波纹<br>3. `feColorMatrix hueRotate` + `&lt;animate&gt;` 动态色相旋转<br>4. `scale` 属性控制波纹强度', NULL, 'https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence', NULL, NULL, NULL, 0, TRUE, '{"svg", "filter"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-褶皱纸张', 'svg-褶皱纸张', 'https://iili.io/JqJOu0x.png', '使用 SVG 滤镜模拟褶皱纸张和手写文字的质感，营造书信复古效果。<br>知识点：<br>1. `feTurbulence` + `feDiffuseLighting` 生成纸张纹理光照<br>2. `feDistantLight azimuth elevation` 控制光源方向和高度<br>3. `feDisplacementMap` 对文字施加微小形变，模拟手写感<br>4. `filter: url()` 在 CSS 中引用 SVG 滤镜', NULL, 'https://juejin.cn/post/6943032791122575390?searchId=20231025171909A1A3EA985C27827359F6#heading-18', NULL, NULL, NULL, 0, TRUE, '{"svg", "filter"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg滤镜粘性小球', 'svg滤镜粘性小球', NULL, '使用 SVG `goo` 滤镜实现小球的粘性聚合/分离动画效果，点击切换状态。<br>知识点：<br>1. `feGaussianBlur` + `feColorMatrix` 组合实现 goo 粘性效果<br>2. `feColorMatrix` 矩阵值 `0 0 0 18 -7` 提高对比度让模糊后的元素重新锐化<br>3. CSS `transition` 控制小球位置过渡<br>4. `filter: url(''#shadowed-goo'')` 应用滤镜', NULL, 'https://www.jianshu.com/p/aaf14eb2a34a', NULL, NULL, NULL, 0, TRUE, '{"svg", "filter"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg滤镜运动模糊', 'svg滤镜运动模糊', 'https://iili.io/JRSZG94.gif', '知识点：
      `feGaussianBlur`高斯模糊。
      `in`: in属性标识给定过滤器原语的输入。
      `stdDeviation`👍: 它定义了平滑模糊操作的标准偏差，默认值为0。2个参数时为(水平，垂直)模糊方向
      `edgeMode`: 它表示输入层边的多余像素。', NULL, 'https://juejin.cn/post/7273435543677714495', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/three/webGL-玻璃效果切换', 'webGL-玻璃效果切换', 'https://iili.io/JRSZMAl.gif', '基于 `Three.js` + `displacement map` 置换贴图实现图片间的玻璃扭曲过渡切换效果。<br>知识点：<br>1. Three.js `hoverEffect` 库封装了 WebGL 图片过渡<br>2. `displacementImage` 置换贴图控制像素偏移方向<br>3. `intensity` / `speedIn` / `speedOut` 控制过渡参数<br>4. 16 种不同置换贴图实现不同扭曲风格', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"three", "webgl"}');

-- 验证导入结果
SELECT COUNT(*) AS total FROM works_meta;