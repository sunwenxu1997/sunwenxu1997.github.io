<template>
    <div class="container">
        <div class="smoke-canvas"></div>
    </div>
</template>

<script>
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger.js";
import smoke from "@/assets/js/threejsSmokeCanvas.js";
export default {
    mounted() {
        smoke.play(".smoke-canvas");
        gsap.registerPlugin(ScrollTrigger);
        ScrollTrigger.create({
            trigger: ".smoke-canvas",
            //   markers: true,
            end: 3000,
            pin: true, //钉住目标至窗口运动轨迹位置
            onUpdate: (self) => {
                console.log(
                    "进度:",
                    self.progress.toFixed(3),
                    "朝向:",
                    self.direction,
                    "滚动速度",
                    self.getVelocity()
                );
                smoke.progress = self.progress.toFixed(3);
            },
        });
    },
    unmounted() {
        smoke.clear()
        ScrollTrigger.killAll()
    }
};
</script>

<style lang="scss" scoped>
.container {
    width: 100%;
    overflow-x: hidden;
    overflow-y: scroll;
}
</style>