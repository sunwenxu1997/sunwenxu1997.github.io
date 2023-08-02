<template>
    <div class="app-content-center">
        <div class="box">
            <div class="ball" @click="ball = !ball">
                <div class="dot" v-for="(i, index) in 3" :key="index" :style="ball
                    ? `transform: rotate(${120 * index}deg) translateX(90px)`
                    : `transform: rotate(${120 * index}deg)`
                    "></div>
            </div>
        </div>
        <svg style="width: 0; height: 0">
            <defs>
                <filter id="shadowed-goo">
                    <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="10" />
                    <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7"
                        result="goo" />
                    <feGaussianBlur in="goo" stdDeviation="3" result="shadow" />
                    <feColorMatrix in="shadow" mode="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 -0.2"
                        result="shadow" />
                    <feOffset in="shadow" dx="1" dy="1" result="shadow" />
                    <feBlend in2="shadow" in="goo" result="goo" />
                    <feBlend in2="goo" in="SourceGraphic" result="mix" />
                </filter>
                <filter id="goo">
                    <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="10" />
                    <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7"
                        result="goo" />
                    <feBlend in2="goo" in="SourceGraphic" result="mix" />
                </filter>
            </defs>
        </svg>
    </div>
</template>

<script>
export default {
    data() {
        return {
            ball: false,
        };
    },
};
</script>

<style lang="scss" scoped>
.box {
    -webkit-tap-highlight-color: transparent;
    user-select: none;
    width: 360px;
    height: 360px;
    filter: url("#shadowed-goo");
    display: flex;
    justify-content: center;
    align-items: center;

    //  filter: contrast(20); //对比度
    .ball {
        color: white;
        width: 100px;
        height: 100px;
        border-radius: 50%;
        background: black;
        // filter: blur(10px); //模糊度
        position: relative;
        cursor: pointer;

        .dot {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: black;
            position: absolute;
            top: calc(50% - 35px);
            left: calc(50% - 35px);
            transition: 0.5s;
            line-height: 70px;
            z-index: -1;
        }
    }
}
</style>