<template>
    <div class="overall">
        <div class="text-box">
            <span class="dot"></span>
            <span class="dot"></span>
            <span class="dot"></span>
        </div>
        <svg height="0" width="0">
            <defs>
                <clipPath id="svgTextPath">
                    <!-- textLength 文字的长度 此处对应容器的宽度  x y 为横纵坐标位置 -->
                    <text x="0" y="180" textLength="50vmax">searchlight</text>
                    <text x="0" y="300" textLength="18vmax">text</text>
                </clipPath>
            </defs>
        </svg>
    </div>
</template>

<script>
import { gsap } from "gsap";
export default {
    date: "2023-09-10",
    cover:'https://iili.io/JRaVVB2.gif',
    mounted() {
        window.addEventListener("mousemove", this.mouseListener);
    },
    unmounted() {
        window.removeEventListener('mousemove', this.mouseListener)
    },
    methods: {
        mouseListener(e) {
            let box = document.querySelector(".text-box").getBoundingClientRect();
            let dt = document.querySelectorAll(".dot");
            for (let i = 0; i < dt.length; i++) {
                //圆灯相对于 容器的坐标位置
                let x = e.pageX - box.left - dt[i].getBoundingClientRect().width / 2;
                let y = e.pageY - box.top - dt[i].getBoundingClientRect().height / 2;
                gsap.to(dt[i],{
                    x: x,
                    y: y,
                    ease: 'back(0.1)',
                    duration:i + 1
                });
            }
        }
    }
};
</script>

<style lang="scss" scoped>
.overall{
    background: #f8f8f8;
}
.text-box {
    width: 50vmax;
    height: 400px;
    font-weight: bold;
    text-transform: uppercase;
    position: relative;
    overflow: hidden;
    //引入剪切路径
    clip-path: url(#svgTextPath);
    color: white;
    background: white;

    //移动圆灯的样式
    .dot {
        pointer-events: none;
        display: inline-block;
        border-radius: 50%;
        position: absolute;
        left: 0;
        top: 0;
        opacity: 0.7;
    }

    .dot:nth-child(1) {
        width: 300px;
        height: 300px;
        background: #66aee9;
        z-index: 8;
    }

    .dot:nth-child(2) {
        width: 400px;
        height: 400px;
        background: #b966e9;
        z-index: 7;
    }

    .dot:nth-child(3) {
        width: 500px;
        height: 500px;
        background: #cc0047;
        z-index: 6;
    }
}

//剪切文字的文字样式 此处的文字颜色取背景色
text {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
        Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
    font-weight: 500;
    font-size: 7vmax;
    text-transform: uppercase;
}
</style>