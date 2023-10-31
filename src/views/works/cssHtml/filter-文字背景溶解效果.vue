<script>
/**
 * 当然你也可以选择采用svg滤镜来快速实现这种效果
 * https://stackoverflow.com/questions/62341132/how-do-i-add-a-highlight-behind-the-text-via-css-so-it-looks-like-instagram-one
 * 在线代码地址
 * https://code.juejin.cn/pen/7278217192406483000
 */
/**
 * 此处实现方法主要是通过,模糊程度和对比度来控制阴影
 * filter: blur(var(--roundiness)) contrast(40);
 * 不方便之处在于,需要建立2个一摸一样的标签,其中一个用于实现阴影效果,一个用于展示实际的文字
 */
export default {
    cover:'https://i.imgur.com/m72fcoT.png'
}
</script>
<template>
  <div class="app-content-center">
    <div class="wrapper">
      <!-- 内容文字阴影 -->
      <div class="container shadow-container">
        <span class="text shadow">
          hello,想要实现这种效果吗?<br />
          come on~<br />
          先这样,再那样<br />
          好了.
        </span>
      </div>
      <!-- 实际的内容文字 -->
      <div class="container">
        <span class="text actual">
          hello,想要实现这种效果吗?<br />
          come on~<br />
          先这样,再那样<br />
          好了.
        </span>
      </div>
    </div>
  </div>
</template>
<style scoped>
.wrapper {
  --spread: 12px;
  /* 圆弧程度 */
  --roundiness: 8px;
  font-size: 20px;
  position: relative;
  line-height: 2em;
  padding: var(--spread);
}

.container {
  /* 给到边距，避免因为模糊度和对比度导致边缘被影响到 */
  padding: calc(var(--spread) * 2) var(--spread);
}

.shadow-container {
  position: absolute;
  /* 模糊程度和对比度来控制阴影 */
  background-color: white;
  filter: blur(var(--roundiness)) contrast(10);
  pointer-events: none;
}

.shadow {
  background-color: #000;
  color: green;
}

.text {
  position: relative;
  padding: var(--spread);
  /* box-decoration-break 属性用来定义当元素跨多行、多列或多页时，元素的片段应如何呈现。 */
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/box-decoration-break */
  box-decoration-break: clone;
  -webkit-box-decoration-break: clone;
}

.actual {
  z-index: 1;
  color: white;
}
</style>
