<template>
    <div class="overall">
        <div class="box">
            <section class="btn" v-for="item in BtnNum" :key="item">
                <span class="text">BUTTON{{ item }}</span>
            </section>
        </div>
    </div>
</template>

<script>
import { gsap } from "gsap";
export default {
    data() {
        return {
            BtnNum: 9
        };
    },
    mounted() {
        window.addEventListener("mousemove", this.mouseListener);
    },
    unmounted() {
        window.removeEventListener('mousemove', this.mouseListener)
    },
    methods: {
        mouseListener(e) {
            let dt = document.querySelectorAll(".btn");
            for (let i = 0; i < dt.length; i++) {
                //按键的坐标位置
                let x = e.pageX - dt[i].offsetLeft;
                let y = e.pageY - dt[i].offsetTop;
                // console.log(x, y);
                gsap.to(dt[i], 1, {
                    ease: 'back(1.7)',
                    // 修改为 rgba(255, 255, 255, 0.5)   为透明白
                    backgroundImage: `radial-gradient(100px at ${x}px ${y}px, rgba(0, 0, 0, 0.4), rgba(255, 255, 255, 0))`
                });
            }
        },
    }
};
</script>

<style lang="scss" scoped>
.box {
    width: 350px;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
}

.btn {
    width: 100px;
    height: 60px;
    background: #26b5ce;
    margin: 5px;
    padding: 3px;
    box-sizing: border-box;

    .text {
        display: inline-block;
        width: 100%;
        height: 100%;
        color: white;
        font-size: 14px;
        background: #26b5ce;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: 0.3s;
        cursor: pointer;
        user-select: none;

        &:hover {
            background: rgba(38, 181, 206, 0.486);
            box-shadow: 0 0 10px #6b6b6b inset;
        }
    }
}
</style>