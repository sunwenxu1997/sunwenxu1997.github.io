<template>
    <div class="body">
        <div class="container">
            <section class="panel">ONE</section>
            <section class="panel">TWO</section>
            <section class="panel">THREE</section>
            <section class="panel">FOUR</section>
            <section class="panel">FIVE</section>
        </div>
        <div class="footer">到底了</div>
    </div>
</template>

<script>
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger.js";
export default {
    mounted() {
        gsap.registerPlugin(ScrollTrigger);
        let sections = gsap.utils.toArray(".panel");
        gsap.to(sections, {
            xPercent: -100 * (sections.length - 1),
            ease: "none",
            scrollTrigger: {
                trigger: ".container", //容器
                pin: true, //钉住目标至窗口运动轨迹位置
                scrub: true, //将动画的进度直接链接到滚动条，这样它就像一个洗涤器
                snap: 1 / (sections.length - 1), //开启后，过渡到模块内后会自动跳转
                // 垂直滚动是基于容器的宽度，这样感觉更自然.
                end: "+=5000",
            },
        });
    },
    unmounted() {
        ScrollTrigger.killAll()
    },
};
</script>

<style lang="scss" scoped>
.body {
    overflow-x: hidden;
    overflow-y: scroll;
}

.container {
    overscroll-behavior: none;
    width: 500%;
    height: 100%;
    display: flex;
    flex-wrap: nowrap;
}

.panel {
    width: 100vw;
    height: 100vh;
    line-height: 100vh;
    text-align: center;
    font-size: 20vw;
    color: white;
    font-weight: 200;
}

.panel:nth-child(2n) {
    background-color: turquoise;
}

.panel:nth-child(2n + 1) {
    background-color: #7be040;
}

.footer {
    height: 50vh;
    width: 100vw;
    text-align: center;
    line-height: 50vh;
    font-size: 10vw;
    background-color: violet;
    color: white;
}</style>