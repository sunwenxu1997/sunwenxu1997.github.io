<template>
    <div class="container">
        <div class="box" :class="index % 2 == 1 ? 'gs_reveal_fromRight' : 'gs_reveal_fromLeft'"
            v-for="(item, index) in list" :key="item">
            <div class="img">img{{ item }}</div>
            <p class="title">
                我是一段文字，我会根据页面滚动的具体位置进行显示，过渡动画是由 GSAP
                scrollTrigger 实现
            </p>
        </div>
    </div>
</template>

<script>
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger.js";
export default {
    data() {
        return {
            list: 15,
        };
    },
    mounted() {
        gsap.registerPlugin(ScrollTrigger);
        this.init();
    },
    unmounted() {
        ScrollTrigger.killAll()
    },
    methods: {
        //执行动画的方法
        animateFrom(elem, direction) {
            direction = direction || 1; //执行方向
            var x = 0,
                y = direction * 100;
            //判断是否包含class，用来区分从左或从右出发方向
            if (elem.classList.contains("gs_reveal_fromLeft")) {
                x = -100;
                y = 0;
            } else if (elem.classList.contains("gs_reveal_fromRight")) {
                x = 100;
                y = 0;
            }
            elem.style.transform = "translate(" + x + "px, " + y + "px)";
            elem.style.opacity = "0";
            gsap.fromTo(
                elem,
                { x: x, y: y, autoAlpha: 0 },
                {
                    duration: 1.25,
                    x: 0,
                    y: 0,
                    autoAlpha: 1,
                    ease: "expo",
                    overwrite: "auto",
                }
            );
        },
        hide(elem) {
            gsap.set(elem, { autoAlpha: 0 });
        },
        init() {
            let _this = this;
            gsap.utils.toArray(".box").forEach((elem) => {
                _this.hide(elem);
                ScrollTrigger.create({
                    trigger: elem,
                    onEnter: function () {
                        _this.animateFrom(elem);
                    },
                    onEnterBack: function () {
                        _this.animateFrom(elem, -1);
                    },
                    onLeave: function () {
                        _this.hide(elem);
                    },
                });
            });
            gsap.utils.toArray(".title").forEach((elem) => {
                _this.hide(elem);
                ScrollTrigger.create({
                    trigger: elem,
                    onEnter: function () {
                        _this.animateFrom(elem);
                    },
                    onEnterBack: function () {
                        _this.animateFrom(elem, -1);
                    },
                    onLeave: function () {
                        _this.hide(elem);
                    },
                });
            });
        },
    },
};
</script>
<style lang="scss" scoped>
.container {
    overflow-x: hidden;
}

.box {
    display: flex;

    .img {
        min-width: 300px;
        width: 300px;
        height: 300px;
        background-color: blueviolet;
        color: white;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 30px;
    }

    .title {
        padding: 50px;
    }
}

.box:nth-child(2n + 1) {
    flex-direction: row-reverse;
}

body {
    overflow-x: hidden;
}
</style>