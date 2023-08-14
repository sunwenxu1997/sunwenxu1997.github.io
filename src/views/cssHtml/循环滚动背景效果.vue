<script>
export default {
  articleLink: 'https://juejin.cn/post/7159380028417277966'
}
</script>
<template>
  <div class="app-content">
    <h1 class="text" aria-label="Thank you. Have a nice day!">
      <span class="heading" aria-hidden="true">
        <span>Thank you</span>
        <span>Thank you</span>
        <span class="filled">Thank you</span>
        <span>Thank you</span>
        <span>Thank you</span>
        <span>Thank you</span>
      </span>
      <span class="subheading" aria-hidden="true">Have a nice day</span>
    </h1>
  </div>
</template>
<style scoped lang="scss">
/* 引入外部字体库 */
@import url('https://fonts.googleapis.com/css2?family=Dela+Gothic+One&display=swap');
$--text-color: hsl(0 95% 60%);
$--bg-color: hwb(0 100% 0% / 0);
$--bg-size: 200px;

.app-content {
  width: 100vw;
  height: 100vh;
  /* 网格布局 */
  display: grid;
  /*  place-items 属性是align-items 和 justify-items 的简写 */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/place-items */
  place-items: center;
  /* place-content 属性是align-content 和 justify-content的简写. */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/place-content */
  place-content: center;
  /* grid-template-areas CSS 属性是网格区域 grid areas 在CSS中的特定命名 */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/grid-template-areas */
  grid-template-areas: 'body';
  overflow: hidden;
  font-family: 'Dela Gothic One', sans-serif;
  background-color: $--bg-color;
}

.app-content::before {
  /* vmin：当前vw和vh中较小的一个值； */
  /* vmax：当前vw和vh中较大的一个值； */
  /* vmin、vmax的作用：在做移动端页面开发时，会使得文字大小在横竖屏下保持一致。 */
  --size: 150vmax;
  /* grid-area 边界的约定 */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/grid-area */
  grid-area: body;
  content: '';
  /* inline-size CSS 属性影响一个元素的width 或 height，以改变一个元素的盒模型的水平或垂直大小 */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/inline-size */
  inline-size: var(--size);
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/block-size */
  block-size: var(--size);
  /* 平铺svg图 */
  background-image: url('https://www.jq22.com/newjs/foot-pattern.svg');
  background-size: $--bg-size;
  background-repeat: repeat;

  transform: rotate(45deg);
  opacity: 0.25;
  animation: bg 6s linear infinite;
}

/* prefers-reduced-motion 用于检测用户的系统是否被开启了动画减弱功能 */
/* https://developer.mozilla.org/zh-CN/docs/Web/CSS/@media/prefers-reduced-motion */
@media (prefers-reduced-motion: reduce) {
  body::before {
    animation-duration: 0s;
  }
}

/* 背景图平移动画 */
@keyframes bg {
  to {
    background-position: 0 calc($--bg-size * -1);
  }
}

.text {
  grid-area: body;
  position: relative;
  display: flex;
  /* https://www.runoob.com/cssref/css3-pr-flex-direction.html */
  flex-direction: column;
  /* clamp() 函数的作用是把一个值限制在一个上限和下限之间，当这个值超过最小值和最大值的范围时，在最小值和最大值之间选择一个值使用。 */
  /* https://www.cnblogs.com/lvonve/p/13816256.html */
  /* clamp() 函数接收三个用逗号分隔的表达式作为参数，按最小值、首选值、最大值的顺序排列 */
  font-size: clamp(3rem, 10vmin, 6rem);
}

.heading span {
  display: block;
  text-transform: uppercase;
}

.heading span.filled {
  color: $--text-color;
}

/* 非 .filled 的所有 span元素 */
.heading span:not(.filled) {
  color: $--bg-color;
  //   文字描边
  // https://blog.csdn.net/taotaomin99/article/details/72553280
  -webkit-text-stroke: 2px $--text-color;
  text-stroke: 2px $--text-color;
}

.subheading {
  position: relative;
  margin-block-start: 1rem;
  margin-inline-start: auto;
  font-size: 0.428em;
  color: $--text-color;
}
</style>
