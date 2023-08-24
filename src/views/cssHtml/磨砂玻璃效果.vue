<script >
/**
 * 知识点：
 * backdrop-filter 背景模块滤镜，类似于filter 推荐
 */
/**
 *  filter 配合 也可以实现背景图片引入方式实现毛玻璃效果
 *  clip-path: inset(15em);
    filter: blur(20px);
 */
export default {
    articleLink: 'https://juejin.cn/post/6979391400844460068?searchId=20230807153325C066903F9072D51F4CEE'
}
</script>
<template>
    <div class="app-content-center">
        <div class="glass">GLASS</div>
    </div>
</template>
<style scoped>
@import url("https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap");

.app-content-center {
    background-image: url("https://picsum.photos/1920/1080");
    background-size: cover;
    background-position: center;
    font-family: 'Rajdhani', sans-serif;
}

.glass {
    width: 40vw;
    height: 30vh;
    font-size: 4em;
    color: white;
    text-align: center;
    line-height: 30vh;
    letter-spacing: 0.75em;
    padding-left: 0.75em;

    -webkit-backdrop-filter: blur(10px);
    backdrop-filter: blur(10px);
    /* filter: drop-shadow(0px 20px 10px rgba(0, 0, 0, 0.3)); */
    box-shadow: 0px 20px 10px rgba(0, 0, 0, 0.3);
}
</style>