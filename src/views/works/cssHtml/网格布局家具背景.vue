<script>
export default {
  cover: 'https://iili.io/JqJOxWu.png',
  link: 'https://juejin.cn/post/7160495991789977636',
  info: `这个效果是在别的网站上看到的，感觉挺新奇的，尤其很适用于一些家具，灯具类分模块的的价格展示。但是局限性其实也很大，因为图片大小、页面定位都有特定的要求，所以有兴趣的也可以学习一下。主要是了解网格布局的使用。
    知识点：
    1. <code>grid</code> 网格布局；
    2. <code>grid-area</code>网格分区域展示；
    `
}
</script>
<template>
  <div class="app-content">
    <div class="grid-box">
      <div class="item cabinet">
        <span class="title">柜子</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item light">
        <span class="title">灯</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item chair">
        <span class="title">椅子</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item carpet">
        <span class="title">地毯</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item frame">
        <span class="title">画框</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item desk">
        <span class="title">电视柜</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item wall">
        <span class="title">墙面</span>
        <span class="shop">$999.00</span>
      </div>
      <div class="item floor">
        <span class="title">地板</span>
        <span class="shop">$999.00</span>
      </div>
    </div>
  </div>
</template>
<style scoped lang="scss">
$gw: 50em;
$gh: 44em;

@media (max-width: 1024px) {
  .app-content {
    font-size: 7px !important;
  }
}
.app-content {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 14px; //em单位会根据当前父元素进行转换,设置px大小控制窗口背景大小
}

.grid-box {
  width: $gw;
  height: $gh;
  background-color: black;
  display: grid;
  align-content: flex-start;
  grid-gap: 0.2em;
  grid-template-columns: 10fr 11fr 15fr 13.4fr; //0.2em*3+10em+11em+15em+13.4em = 50em
  grid-template-rows: 6fr 15fr 15fr 7.4fr; //0.2em*3+6em+15em+15em+7.4em= 44em
  // grid-template: repeat(5, 1fr)/repeat(5, 1fr);
  box-sizing: border-box;
}

.grid-box .item {
  width: 100%;
  height: 100%;
  background-image: url('https://images.unsplash.com/photo-1586023492125-27b2c045efd7?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxNDU4OXwwfDF8cmFuZG9tfHx8fHx8fHx8MTY0MDA0NjcyNw&ixlib=rb-1.2.1&q=85');
  background-repeat: no-repeat;
  background-attachment: fixed;
  background-size: $gw $gh;
  background-position: center;
  padding: 1em;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-end;
  position: relative;
  color: white;
  overflow: hidden;
}

.grid-box .item::before {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0) 5%, rgba(0, 0, 0, 0.8));
  backdrop-filter: blur(6px); //背景模糊
  -webkit-backdrop-filter: blur(6px);
  /**
    https://segmentfault.com/a/1190000042059089?sort=votes
    等同于 `top: 0; right: 0; bottom: 0; left: 0;`
    */
  inset: 0;
  opacity: 0;
  transition: opacity 0.4s;
  z-index: -1;
}

.grid-box .item .title {
  font-size: 1rem;
  font-weight: bold;
}

.grid-box .item .shop {
  font-size: 0.8rem;
  font-weight: 100;
  margin-top: 0.5rem;
  margin-bottom: -2rem;
  transition: 0.3s;
  cursor: pointer;
  color: orange;
}

.frame,
.carpet,
.cabinet,
.light,
.desk,
.wall,
.floor,
.chair {
  transition: 0.3s;

  &:hover {
    filter: brightness(1.2); //变亮
    -webkit-filter: brightness(1.2);
  }

  &:hover .shop {
    margin-bottom: 0;
  }

  &:hover:before {
    opacity: 1;
  }
}

// 画框
.frame {
  grid-area: 2/3 / span 1 / span 1;
}

// 地毯
.carpet {
  // 从4行4列开始 合并1行1列
  grid-area: 4/4 / span 1 / span 1;
}

// 柜子
.cabinet {
  grid-area: 1/1 / span 4 / span 1;
}

// 灯
.light {
  grid-area: 2/2 / span 1 / span 1;
}

// 椅子
.chair {
  grid-area: 3/2 / span 1 / span 2;
}

// 电视柜
.desk {
  grid-area: 2/4 / span 2 / span 1;
}

// 墙面
.wall {
  grid-area: 1/2 / span 1 / span 3;
}

// 地板
.floor {
  grid-area: 4/2 / span 1 / span 2;
}
</style>
