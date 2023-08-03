<template>
    <div class="container">
        <div class="smoke-canvas"></div>
    </div>
</template>

<script>
import smoke from "@/assets/js/threejsSmokeMoveCanvas.js";
export default {
    mounted() {
        smoke.play(".smoke-canvas");
    },
    unmounted() {
        smoke.clear()
    }
};
</script>

<style lang="scss" scoped>
.container {
    width: 100%;
    height: 100vh;
    overflow: hidden;
    background: linear-gradient(20deg,
            rgb(205, 248, 248) 0%,
            rgb(51, 139, 161) 50%,
            rgb(3, 84, 122) 100%);
    //   background: linear-gradient(
    //     -150deg,
    //     rgb(205, 224, 248) 0%,
    //     rgb(51, 99, 161) 50%,
    //     rgb(3, 55, 122) 100%
    //   );
    contain: strict;
    backface-visibility: visible;
}

.smoke-canvas {
    mix-blend-mode: screen;
}
</style>