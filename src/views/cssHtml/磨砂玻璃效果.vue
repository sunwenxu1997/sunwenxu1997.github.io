<script>
/**
 * 知识点：
 * filter 配合 背景图片引入方式实现毛玻璃效果
 *  clip-path: inset(15em);
    filter: blur(20px);
 */
export default {
  articleLink:
    'https://juejin.cn/post/6979391400844460068?searchId=20230807153325C066903F9072D51F4CEE'
}
</script>
<template>
  <div class="app-content">
    <div class="drop-shadow">
      <div class="glass"></div>
      <span>GLASS</span>
    </div>
  </div>
</template>
<style scoped>
@import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');

.app-content {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('https://picsum.photos/1920/1080');
  background-size: cover;
  background-position: center;
  font-family: 'Rajdhani', sans-serif;
}

.drop-shadow {
  height: 100%;
  width: 100%;
  filter: drop-shadow(0px 20px 10px rgba(0, 0, 0, 0.3));
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

.glass {
  height: 100%;
  width: 100%;
  background-image: url('https://picsum.photos/1920/1080');
  background-size: cover;
  background-position: center;
  clip-path: inset(15em);
  filter: blur(20px);
}

.drop-shadow > span {
  position: absolute;
  z-index: 5;
  color: white;
  font-size: 4em;
  letter-spacing: 0.75em;
  padding-left: 0.375em;
}
</style>
