<template>
  <div class="body">
    <div class="wrap">
      <li v-for="item in 800" :key="item"></li>
    </div>
  </div>
</template>

<script>
export default {
  cover: 'https://iili.io/JqJOCb9.png',
  link: 'https://juejin.cn/post/7186572424807186490',
  info: `可能使用价值不太高，娱乐学习一下~
    知识点：
    1. <code>clip-path</code> 路径裁切，实现⑥边形效果
    2. <code>shape-outside</code> 说白了就是可以让文本围绕着你定义的样式环绕
    `
}
</script>

<style lang="scss" scoped>
$--m: 1px;
/* margin 六边形之间的间距 */
//以下不建议配置
$--s: 50px;
/* size 一般为50，调整其它尺寸可能需要调整最优倍数 */
//   1.732为尝试出来的最优倍数，避免造成六边形浮动不统一
$--f: calc(1.732 * $--s + 4 * $--m - 1px); //生成由 六边形高度，六边形间距换算来的浮动隔板的高度

.body {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.wrap {
  position: relative;
  margin: auto;
  width: 120%;
  transform: translateX(-10%) scale(1.1);
  height: 100vh;
  font-size: 0;
  background: #fff;
  overflow: hidden;

  &::before {
    content: '';
    height: 100%;
    width: 26px; //浮动隔板长度
    // 浮动隔板间距80px 浮动隔板高度 --f
    shape-outside: repeating-linear-gradient(transparent 0, transparent 80px, #000 80px, #000 $--f);
    float: left;
  }
}

li {
  width: $--s;
  height: calc($--s * 1.1547);
  background: #f1c929;
  clip-path: polygon(0% 25%, 0% 75%, 50% 100%, 100% 75%, 100% 25%, 50% 0%);
  margin: $--m;
  margin-bottom: calc($--m - $--s * 0.2885); //计算出每个六边形需要往上偏移的距离
  display: inline-block;
}

li:nth-child(2n + 1) {
  background: #f19e29;
}
</style>
