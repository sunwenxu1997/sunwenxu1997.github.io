<template>
    <div class="overall">
        <!-- 容器 -->
        <div class="box">
            <!-- 底部文字 -->
            <div class="text">{{ text }}</div>
            <!-- 装光影文字的盒子 -->
            <div class="light_box">
                <div class="text_light" v-for="(i, index) in 10" :key="index"
                    :style="`transform: translateZ(${i * 240}px);`">
                    <span class="light" :style="`opacity:${(30 - index) / 100};`">{{
                        text
                    }}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { gsap } from "gsap";
export default {
    cover:'https://iili.io/JRSZ1Sf.gif',
    data() {
        return {
            //光影文字
            text: "sony",
            w: window.innerWidth,
            h: window.innerHeight,
        };
    },
    mounted() {
        document.addEventListener("mousemove", this.move, false);
    },
    unmounted() {
        document.removeEventListener("mousemove", this.move, false);
    },
    methods: {
        //鼠标移入事件
        move(e) {
            let light_box = document.querySelector(".light_box");
            let lightArray = document.querySelectorAll(".light");
            let text = document.querySelector(".text");
            let text_box = document.querySelector(".box");
            let x = -(e.clientX - this.w / 2) * 10;
            let y = (e.clientY - this.h / 2) * 10;

            // //容纳影子以及影子的容器，实现上下左右的偏移
            // //火狐浏览器好像有问题，所以此处给注释了
            // TweenLite.to(text_box, 0.5, {
            //   ease: Back.easeOut.config(1.7),
            //   x: (x / this.h) * 2,
            //   y: (-y / this.w) * 3
            // });

            //装所有光影的盒子，通过控制盒子的旋转角度，实现影子的偏移
            gsap.to(light_box, 0.5, {
                ease: 'back(1.7)',
                rotationX: y / this.h,
                rotationY: (x / this.w) * 2,
            });

            let t_x = e.clientX - text_box.offsetLeft;
            let t_y = e.clientY - text_box.offsetTop;
            //径向渐变的背景色值，此处是白光
            //此处可以修改光的颜色
            let light_bck = `radial-gradient(
      500px at ${t_x}px ${t_y}px,
    rgb(255, 255, 255),
      rgba(255, 255, 255, 0.477),
      rgba(255, 255, 255, 0.382),
      rgba(255, 255, 255, 0.204),
      transparent
    )`;
            //控制底部文字的背景渐变色
            gsap.to(text, 0.5, {
                ease: 'back(1.7)',
                backgroundImage: light_bck,
            });

            //控制每个光影的背景渐变色
            for (let i = 0; i < lightArray.length; i++) {
                gsap.to(lightArray[i], 0.5, {
                    ease: 'back(1.7)',
                    backgroundImage: light_bck,
                });
            }
        },
    },
};
</script>

<style lang="scss" scoped>
.overall {
    background: black;
    -webkit-perspective: 2000px;
    perspective: 2000px;
    cursor: default;
    user-select: none;
    overflow: hidden;
}

.box {
    text-transform: uppercase;
    -webkit-perspective: 2000px;
    perspective: 2000px;
    box-sizing: border-box;
    position: relative;
    letter-spacing: 1rem;
    font-size: 13vmax;

    .text {
        color: transparent;
        transform-style: preserve-3d;
        /*剪切到文本,把渐变从背景填充到文字当中*/
        -webkit-background-clip: text;
        background-clip: text;
        font-weight: bold;
    }

    .light_box {
        position: absolute;
        top: 0;
        transform-style: preserve-3d;

        .text_light {
            position: absolute;
            top: 0;
            pointer-events: none;

            .light {
                white-space: nowrap;
                color: transparent;
                -webkit-background-clip: text;
                background-clip: text;
                filter: blur(20px);
            }
        }
    }
}
</style>