<template>
    <div>
        <div class="main-tool-bar">头部导航栏</div>
        <div class="scrollable-area"></div>
    </div>
</template>

<script>
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger.js";
export default {
    mounted() {
        gsap.registerPlugin(ScrollTrigger);
        // //效果1：下拉滚动-收缩导航栏
        // ScrollTrigger.create({
        //   start: 'top -80',
        //   end: 99999,
        //   toggleClass: {
        //     className: 'main-tool-bar--scrolled', //转换className
        //     targets: '.main-tool-bar' //目标对象
        //   }
        // });

        //效果2：下拉收缩，上拉显示
        const showAnim = gsap
            .from(".main-tool-bar", {
                yPercent: -100, //网上收缩 100
                paused: true, //暂停
                duration: 0.2, //0.2s
            })
            .progress(1); //获取或设置时间轴的进度，这是一个在0到1之间的值，指示虚拟播放头(不包括重复)的位置，其中0是开始，0.5是完成一半，1是完成
        ScrollTrigger.create({
            start: "top top",
            end: 99999,
            onUpdate: (self) => {
                // direction 滚动方向 反映实时滚动的方向，其中1是向前，-1是向后
                console.log(1111);
                self.direction === -1 ? showAnim.play() : showAnim.reverse();
            },
        });
    },
    unmounted() {
        ScrollTrigger.killAll()
    }
};
</script>

<style lang="scss" scoped>
body {
    margin: 0;
}

.main-tool-bar {
    height: 80px;
    text-align: center;
    line-height: 80px;
    color: white;
    background-color: yellowgreen;
    position: fixed;
    top: 0;
    width: 100%;
    transition: ease 0.4s;

    &--scrolled {
        //达到滚动效果时的className
        height: 40px;
        line-height: 40px;
        background-color: red;
    }
}

.scrollable-area {
    height: 200vh;
}
</style>