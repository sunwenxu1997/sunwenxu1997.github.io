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
VALUES ('/anime/anime-切割模糊文字', 'anime-切割模糊文字', 'https://iili.io/K99P0Cv.gif', '近期网上看到的一个效果，实现起来也很简单。同时挖掘到了一个很牛的<a href="https://codepen.io/filipz" target="_blank">Filip Zrnzevic😎大佬</a>，写的效果都很炫酷。
           <code>animejs-text</code> 官方提供的文本 <a href="https://animejs.cn/documentation/text/split/split-parameters/class" target="_blank">分割插件</a>，相比于GSAP是不额外收费的，不过animejs版本要在4.0以上；
           <code>fractalNoise</code> background-image 引入本地定义好的噪点svg，通过重复动画随即修改 background-size 实现噪点波动效果', NULL, NULL, 'https://codepen.io/sunwenxu1997/pen/RNWMXOr', NULL, '2025-08-21', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/anime/anime-切割波浪文字', 'anime-切割波浪文字', 'https://iili.io/FsuNQu1.gif', '闲逛掘金时发现的一个好玩效果🌊，作者是通过scss实现的动画效果，这里我尝试用 animejs 做了实现。
           <code>.cloneNode:</code> 克隆复制dom节点，批量创建26（涉及到后面的裁切，这个数量基本能达到100%的裁切）个文字元素层；
           <code>clip-path:</code> 第一块裁切比例 clip-path: polygon(-30% 0, -20% 0, 20% 100%, 0% 100%)，clip-path: polygon(-25% 0, -15% 0, 25% 100%, 5% 100%)，以此类推...
           动画执行时间和旋转角度这些就不做过多陈述了，基本都是经过实践得到的最优效果👻', NULL, 'https://juejin.cn/post/7412490116793909286', 'https://codepen.io/sunwenxu1997/pen/pvjrzew', NULL, '2025-08-08', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/anime/anime-礼花彩带效果', 'anime-礼花彩带效果', 'https://iili.io/FeMPOKP.gif', '近期将要做活动中奖相关需求，就想着能不能做一个这种效果。因为之前有见过类似🎉喷洒的动画，后来找又找不到了，其次看到网上的效果也不是很理想，所以就考虑打算自己手搓一个。
         实际效果还可以，主要还是通过animejs动画控制，创建很多随机的彩带元素。点击绽放的效果不是特别流畅，后期可以根据animejs提供不同的 <a href="https://codepen.io/juliangarnier/pen/gbOqbVR" target="_blank">缓动函数Easings</a> 来调整优化。', NULL, 'https://juejin.cn/post/7534935432866988072', 'https://codepen.io/sunwenxu1997/pen/raOLjzr', NULL, '2025-07-24', 0, TRUE, '{"anime"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/3D弹跳表情', '3D弹跳表情', 'https://iili.io/Jq9GrUg.gif', '参考大佬 Chokcoco 的作品，用 Vue3.0 实现了一下，代码比较简单，就不多说了。
  知识点：
  1.通过伪元素制造多层表情标签，制造3D假象；
  2.通过记录下落转向上升的那一帧开始，更换表情和背景；
  3.学会如何通过 <code>conic-gradient</code> <code>linear-gradient</code> <code>radial-gradient </code> 实现多样化的背景效果；', NULL, 'https://juejin.cn/post/7262007830721413180', NULL, NULL, '2023-09-09', 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/backdrop-filter-磨砂玻璃效果', 'backdrop-filter-磨砂玻璃效果', 'https://iili.io/JqJOBO7.png', '之前尝试实现磨砂效果，都会想着用fliter滤镜加模糊实现。但是效果总是那么差点意思，后来css推出了 <b>backdrop-filter</b> 属性，值得一试。
    知识点：
    1. <code>backdrop-filter</code> 背景模块滤镜，类似于filter
    2. <code>clip-path: inset(10px)</code> 相当于整体向内裁切10px', NULL, 'https://juejin.cn/post/6979391400844460068?searchId=20230807153325C066903F9072D51F4CEE', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/css-碰撞检测', 'css-碰撞检测', 'https://iili.io/Jq644b1.gif', '动画新属性 <b>animation-composition</b> 的学习，可能实际项目上用不到。
    知识点：
    1. <code>animation-composition</code> 动画合成
    2. <code>steps</code> 按步执行动画', NULL, 'https://juejin.cn/post/7269797025863499837', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/filter-文字背景溶解效果', 'filter-文字背景溶解效果', 'https://iili.io/JqJOAUQ.png', '想要实现这种效果可以通过svg滤镜，也可以通过模糊和对比度来实现。因为效果展示原因，最终采用了后者。但是也有弊端，就是需要重复一套相同的文本，其中一个是专门用作背景效果使用。更多内容可以直接在代码里了解。
    知识点：
    1. <code>filter:blur() contrast()</code>filter滤镜模糊和对比度
    2. <code>box-decoration-break</code>属性用来定义当元素跨多行、多列或多页时，元素的片段应如何呈现。', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/mask-网点图', 'mask-网点图', 'https://iili.io/JqJOFUl.png', NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/mask-镂空文字', 'mask-镂空文字', 'https://iili.io/JqJOTfj.png', NULL, NULL, 'https://github.com/chokcoco/iCSS/issues/80', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/tailwindcss使用', 'tailwindcss使用', 'https://iili.io/Jq64QqJ.gif', NULL, NULL, 'https://juejin.cn/post/7290740395914362921', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/循环六边形背景效果', '循环六边形背景效果', 'https://iili.io/JqJOCb9.png', '可能使用价值不太高，娱乐学习一下~
    知识点：
    1. <code>clip-path</code> 路径裁切，实现⑥边形效果
    2. <code>shape-outside</code> 说白了就是可以让文本围绕着你定义的样式环绕', NULL, 'https://juejin.cn/post/7186572424807186490', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/循环滚动背景效果', '循环滚动背景效果', 'https://iili.io/Jq64rOP.gif', '很早之前遇到的效果了，当时记得还在为自己搞得小程序登录背景发愁呢。突然发现了这个好看又简约的效果，所以便入手了。主要是根据一小块svg矢量图，然后通过背景重复实现的平铺，再加上背景尺寸和位置的改变，实现了动画效果。
    如果你想改颜色，那建议你下载源地址svg，然后修改fill填充色，你也可以通过上传自己的图片实现效果。', NULL, 'https://juejin.cn/post/7159380028417277966', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字效果', '文字效果', 'https://iili.io/JqJOqRS.png', '🌈属于文字效果，里面有各种样式类型的文本，当然不仅仅可以应用于文字上，你也可以应用在其他地方。首先你要先学会他，不是吗？
    知识点：
    1. <code>background-clip: text;</code> 背景文本裁切
    2. <code>mask</code> 遮罩层 
    3. <code>svg，fliter</code>等效果应用', NULL, 'https://juejin.cn/post/7165675529763454983', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字极光动画', '文字极光动画', NULL, '🌈属于文字效果，但更适合于纯黑色背景，有点局限性。更推荐用背景裁切 <a href="https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-clip">background-clip: text;</a>
    知识点：
    1. <code>mix-blend-mode</code> 混合模式
    2. <code>clamp()</code> 函数的作用是把一个值限制在一个上限和下限之间，当这个值超过最小值和最大值的范围时，在最小值和最大值之间选择一个值使用。它接收三个参数：最小值、首选值、最大值。', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/文字背景进度', '文字背景进度', 'https://iili.io/JRauCrl.gif', '今天又是忙碌的一天，今天周二还有生产发布，但是发现这个有意思得效果还是要学习下的！😄
    知识点：
    1. <code>-webkit-text-fill-color</code>设置文本的填充颜色，这里建议设置透明度低得，否则颜色过渡上会有冲突
    2. <code>-webkit-background-clip: text</code>用于将背景应用到文本内容内部，创建文本填充效果 
    3. <code>background-size: 0% 100%;</code>文字进度完成度 x轴控制水平进度，y轴控制垂直进度', NULL, 'http://manifesto.clapat.com/', NULL, NULL, '2023-12-26', 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/碎裂文字效果', '碎裂文字效果', 'https://iili.io/JqJOfJ2.png', '单纯的通过 css+html 实现的碎裂效果。
    知识点：
    1. <code>clip-path</code> 路径剪切；
    2. <code>content: attr(data-text); </code>文本属性引用；', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/网格布局家具背景', '网格布局家具背景', 'https://iili.io/JqJOxWu.png', '这个效果是在别的网站上看到的，感觉挺新奇的，尤其很适用于一些家具，灯具类分模块的的价格展示。但是局限性其实也很大，因为图片大小、页面定位都有特定的要求，所以有兴趣的也可以学习一下。主要是了解网格布局的使用。
    知识点：
    1. <code>grid</code> 网格布局；
    2. <code>grid-area</code>网格分区域展示；', NULL, 'https://juejin.cn/post/7160495991789977636', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/cssHtml/网格背景效果', '网格背景效果', 'https://iili.io/JqJOoxe.png', '某一天感觉单纯的背景色有点单一，同时看到掘金有些文章背部有类似网格形状的东西，所以就好奇的尝试实现下。其实原理还是挺简单的，当然你也可以直接通过图片来实现（放大会模糊），但是当你真正掌握后，它不仅仅能实现网格，还有其他更多花样背景呢。
  知识点：
  1. <code>linear-gradient</code> 背景渐变；
  2. <code>background-size</code> 背景尺寸；
  3. <code>background-repeat</code> 背景重复；', NULL, 'https://juejin.cn/post/7160858048636911652', NULL, NULL, NULL, 0, TRUE, '{"cssHtml"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/draggable-细节放大镜', 'draggable-细节放大镜', 'https://iili.io/Jq64iWg.gif', NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-倾斜滚动特效', 'scrollTrigger-倾斜滚动特效', 'https://iili.io/Jq64ssa.gif', NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-头部导航栏收缩', 'scrollTrigger-头部导航栏收缩', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-横屏滚动', 'scrollTrigger-横屏滚动', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-烟雾消散效果', 'scrollTrigger-烟雾消散效果', 'https://iili.io/Jq6Qtgs.gif', NULL, NULL, NULL, NULL, NULL, '2023-10-10', 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-烟雾飘过效果', 'scrollTrigger-烟雾飘过效果', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-简单过渡效果', 'scrollTrigger-简单过渡效果', NULL, NULL, NULL, 'https://juejin.cn/post/7165808796462219295', NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/scrollTrigger-视频帧跟随滚动', 'scrollTrigger-视频帧跟随滚动', 'https://iili.io/JRaX80B.gif', NULL, NULL, 'https://juejin.cn/post/7162001311225888782', NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/光影文字特效', '光影文字特效', 'https://iili.io/JRSZ1Sf.gif', NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/多张图片伪视频动画', '多张图片伪视频动画', 'https://iili.io/J7b3Ext.gif', '通过多张图片的方式模拟视频动画，通过滚动条平滑过渡，控制图片播放。相比于直接控制视频进度动画可能会好一点。
  实现原理：
  主要是通过 <code>gsap + scrollTrigger</code> 来实现的，通过控制 playhead 对象参数的 frame(图片index) 从0到最后一张图片的过程来实现图片的播放动画。', NULL, 'https://codepen.io/sunwenxu1997/pen/eYXzqpG', NULL, NULL, '2024-01-11', 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/数字加载效果', '数字加载效果', 'https://iili.io/JRahFql.gif', NULL, NULL, 'https://juejin.cn/post/7273680035096494099', NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/文字探照灯效果', '文字探照灯效果', 'https://iili.io/JRaVVB2.gif', NULL, NULL, NULL, NULL, NULL, '2023-09-10', 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/水滴按钮效果', '水滴按钮效果', NULL, NULL, NULL, 'https://juejin.cn/post/7159379138648735780', NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/深度视觉差效果', '深度视觉差效果', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/gsap/鼠标跟随高亮按钮效果', '鼠标跟随高亮按钮效果', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"gsap"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/canvas-波浪背景', 'canvas-波浪背景', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/canvas-粒子svg浮层', 'canvas-粒子svg浮层', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/slidev简单使用', 'slidev简单使用', NULL, NULL, 'https://github.com/sunwenxu1997/slidev', 'https://juejin.cn/post/7288963700538556470', NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/富文本编辑器-wangeditor', '富文本编辑器-wangeditor', 'https://iili.io/JqJOzib.png', NULL, NULL, 'https://www.wangeditor.com/v5/for-frame.html#vue3', NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-九宫格', '抽奖-九宫格', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-大转盘', '抽奖-大转盘', NULL, NULL, NULL, 'https://juejin.cn/post/7165676884460568590', NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/抽奖-老虎机', '抽奖-老虎机', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/滑动分割背景', '滑动分割背景', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/自定义拖拽滑块', '自定义拖拽滑块', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/鼠标吸附按钮效果', '鼠标吸附按钮效果', 'https://iili.io/JRSzVKg.gif', '多用于导航栏文字效果，让人感觉有种吸附的效果，主要用的就是监听鼠标得移入移出。
    知识点：
    1. <code>addEventListener</code>监听进入按钮时得 mousemove mouseleave
    2. <code>rotate3d(x, y, z, angle)</code>
       x：表示绕着X轴旋转的角度。
       y：表示绕着Y轴旋转的角度。
       z：表示绕着Z轴旋转的角度。
       angle：表示旋转的角度，单位为度（deg）', NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/other/鼠标经过发出声音', '鼠标经过发出声音', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"other"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/2023兔年大吉', '2023兔年大吉', NULL, NULL, NULL, 'https://juejin.cn/post/7187585110403711033', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-多种玻璃图案', 'svg-多种玻璃图案', 'https://iili.io/JqJO5JV.png', '起初对玻璃滤镜这种概念并没有。一直以为只能用图片实现，直到后来发现有些网站上通过 <b>WebGl</b> 可以实现，因此就比较痴迷于它了。但是往往代码比较复杂，对于我这种菜鸡来说还没到那一层，于是就想到了如何通过svg滤镜来实现。终于功夫不负有心人，被我搞出来了。但是也有一些不足，就是对玻璃纹路尺寸大小有要求，太小的纹理图片无法重复平铺，且无法占满。so，搞得时候搞大点。这里简单给到效果给大家。
  知识点：
  1. <code>svg filter</code>svg滤镜
  2. <code>feImage</code>滤镜从外部来源取得图像数据，并提供像素数据作为输出（意味着如果外部来源是一个 SVG 图像，这个图像将被栅格化。） 。
  3. <code>feDisplacementMap</code>映射置换滤镜，该滤镜用来自图像中从in2 (en-US)到空间的像素值置换图像从in到空间的像素值。', NULL, 'https://juejin.cn/post/7299671709475766324', NULL, NULL, '2023-11-03', 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-文字环绕效果', 'svg-文字环绕效果', NULL, NULL, NULL, 'https://juejin.cn/post/7187585110403711033', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-文字边框效果', 'svg-文字边框效果', NULL, NULL, NULL, 'https://juejin.cn/spost/7267092779280695337', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-波纹效果', 'svg-波纹效果', NULL, NULL, NULL, 'https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg-褶皱纸张', 'svg-褶皱纸张', 'https://iili.io/JqJOu0x.png', NULL, NULL, 'https://juejin.cn/post/6943032791122575390?searchId=20231025171909A1A3EA985C27827359F6#heading-18', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg滤镜粘性小球', 'svg滤镜粘性小球', NULL, NULL, NULL, 'https://www.jianshu.com/p/aaf14eb2a34a', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/svg/svg滤镜运动模糊', 'svg滤镜运动模糊', 'https://iili.io/JRSZG94.gif', '知识点：
      <code>feGaussianBlur</code>高斯模糊。
      <code>in</code>: in属性标识给定过滤器原语的输入。
      <code>stdDeviation</code>👍: 它定义了平滑模糊操作的标准偏差，默认值为0。2个参数时为(水平，垂直)模糊方向
      <code>edgeMode</code>: 它表示输入层边的多余像素。', NULL, 'https://juejin.cn/post/7273435543677714495', NULL, NULL, NULL, 0, TRUE, '{"svg"}');

INSERT INTO works_meta (slug, name, cover_url, info_html, code_url, link_url, codepen_url, open_url, date, sort_weight, is_published, tags)
VALUES ('/three/webGL-玻璃效果切换', 'webGL-玻璃效果切换', 'https://iili.io/JRSZMAl.gif', NULL, NULL, NULL, NULL, NULL, NULL, 0, TRUE, '{"three"}');

-- 验证导入结果
SELECT COUNT(*) AS total FROM works_meta;