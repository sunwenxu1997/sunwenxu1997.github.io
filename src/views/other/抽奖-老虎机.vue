<template>
    <div class="app-content-center">
        <div>
            <div class="cj-box">
                <div class="cj-block" v-for="item in 3" :key="item">
                    <ul class="gundong">
                        <li v-for="(i, index) in list" :key="index" :style="`transform: rotateX(${(360 / list.length) * index
                            }deg)  translateZ(${13.6 * list.length}px)`">
                            {{ i.title }}
                        </li>
                    </ul>
                </div>
            </div>
            <div class="chou" @click="start">抽奖</div>
        </div>
    </div>
</template>

<script>
export default {
    computed: {},
    data() {
        return {
            list: [
                {
                    title: "0",
                },
                {
                    title: "1",
                },
                {
                    title: "2",
                },
                {
                    title: "3",
                },
                {
                    title: "4",
                },
                {
                    title: "5",
                },
                {
                    title: "6",
                },
                {
                    title: "7",
                },
            ], //奖品列表，目前最多支持8个，想支持更多，可以手动添加对应的css样式动画
            winner: null, //指定的奖品 null时为不中奖
            loading: false, //抽奖执行状态，防止用户多次点击
            gundongElement: null, //储存获取到的滚动容器的标签
            animationClass: [], //3个抽奖模块对应的动画属性,方便后来对应添加和移除该class样式
        };
    },
    mounted() {
        //通过获取奖品个数，来改变css样式中每个奖品动画的旋转角度
        // var(--nums) 实现css动画根据奖品个数，动态改变
        let root = document.querySelector(":root");
        root.style.setProperty("--nums", this.list.length);
    },
    methods: {
        //开始抽奖
        start() {
            if (!this.loading) {
                this.gundongElement = document.querySelectorAll(".gundong");
                this.gundongElement.forEach((element, index) => {
                    if (this.animationClass[index]) {
                        element.classList.remove(this.animationClass[index].class);
                    }
                });
                //此处可指定后端返回的指定奖品------------------------------------------------
                // this.winner = this.winner
                this.winCallback();
                this.loading = true;
            }
        },
        //中奖返回方法
        winCallback() {
            setTimeout(() => {
                /* 此处是为了解决当下次抽中的奖励与这次相同，动画不重新执行的 */
                /* 添加一个定时器，是为了解决动画属性的替换效果，实现动画的重新执行 */
                this.gundongElement.forEach((element, index) => {
                    element.classList.add(this.getAnimationClass(this.winner, index));
                    setTimeout(() => {
                        element.style.transform = `rotateX(${this.animationClass[index].rotate}deg)`;
                    }, 2000);
                });
            }, 0);
            // 因为动画时间为 3s ，所以这里4s后获取结果，其实结果早就定下了，只是何时显示，告诉用户
            setTimeout(() => {
                this.loading = false;
                console.log(
                    `恭喜你获得了${this.winner}-----------------------------------`
                );
            }, 4000);
        },
        //获取对应的class样式，并储存起来，方便后来的class移除
        getAnimationClass(winner, index) {
            //如果是后端指定奖品
            if (winner !== null) {
                this.animationClass[index] = {
                    num: winner,
                    class: `wr${winner}`,
                    rotate: (360 / this.list.length) * -winner,
                };
                //对应css样式中定义的class属性值,如果有更多的话可以继续添加  case 8:   return 'wr8'
                return `wr${winner}`;
            } else {
                /* 此处是当不中奖时，那么3个轮盘会自动随机 */
                let ran = this.random(0, this.list.length - 1);
                /* 此处是为了避免随机时的3个数字一样，因为不中奖的时候3个数字是不可能一样的 */
                if (this.animationClass[0]) {
                    while (this.animationClass[0].num === ran) {
                        ran = this.random(0, this.list.length - 1);
                    }
                }
                this.animationClass[index] = {
                    num: ran,
                    class: `wr${ran}`,
                    rotate: (360 / this.list.length) * -ran,
                };
                //对应css样式中定义的class属性值,如果有更多的话可以继续添加  case 8:   return 'wr8'
                return `wr${ran}`;
            }
        },
        //随机一个整数的方法
        random(min, max) {
            return parseInt(Math.random() * (max - min + 1) + min);
        },
    },
};
</script>

<style lang="scss" scoped>
$time: 3s; //老虎机的转动时间 3s 后停止，修改后需要在计时器 setTimeout 中修改对应获奖提示的时间

.overall {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
    position: absolute;
    perspective: 3000px;

    * {
        box-sizing: content-box;
    }
}

/* 抽奖按钮 */
.chou {
    user-select: none;
    cursor: pointer;
    padding: 10px;
    margin: 20px auto;
    color: white;
    background: #19aca4;
    width: 100px;
    font-size: 20px;
    border-radius: 5px;
    box-shadow: 0 0 10px #ccc;
    text-align: center;

    &:active {
        transform: scale(0.9);
    }
}

.cj-box {
    height: 100px;
    background: white;
    box-shadow: 0 0 10px #ccc;
    border-radius: 5px;
    padding: 20px 40px;
    display: flex;

    .cj-block {
        width: 100px;
        overflow: hidden;
        box-sizing: border-box;
        margin: 0 1px;

        .gundong {
            display: inline-block;
            transform-style: preserve-3d;
            width: 100px;
            height: 100%;
            list-style: none;
            padding: 0;
            position: relative;
            perspective: 3000px;

            /* 每个奖品格子的样式 */
            li {
                transform-style: preserve-3d;
                // transform-origin: 50% 0%;
                display: block;
                height: 100px;
                line-height: 100px;
                font-weight: bold;
                font-size: 30px;
                position: absolute;
                width: 100%;
                height: 100%;
                color: #fcfcfc;
                text-align: center;
            }
        }
    }
}

/* 给每个滚动添加一个延迟动画效果 */
.cj-block:nth-child(1) ul {
    animation-delay: 0.2s;

    li {
        background: #14e4b7;
    }
}

.cj-block:nth-child(2) ul {
    animation-delay: 0.5s;

    li {
        background: #14dde4;
    }
}

.cj-block:nth-child(3) ul {
    animation-delay: 0.8s;

    li {
        background: #14e4b7;
    }
}

/* 下面的css样式为每个奖品的旋转动画，这里写了对应8个奖品的动画，如果想要更多的话，可以添加 */
/* 例如： .wr8  @keyframes play8 */
.wr0,
.wr1,
.wr2,
.wr3,
.wr4,
.wr5,
.wr6,
.wr7 {
    /* 每个转动的时间 */
    animation-duration: $time;
    animation-timing-function: ease;
    animation-fill-mode: both;
    animation-iteration-count: 1;
}

.wr0 {
    animation-name: play0;
}

.wr1 {
    animation-name: play1;
}

.wr2 {
    animation-name: play2;
}

.wr3 {
    animation-name: play3;
}

.wr4 {
    animation-name: play4;
}

.wr5 {
    animation-name: play5;
}

.wr6 {
    animation-name: play6;
}

.wr7 {
    animation-name: play7;
}

@keyframes play0 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * 0));
    }
}

@keyframes play1 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -1));
    }
}

@keyframes play2 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -2));
    }
}

@keyframes play3 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -3));
    }
}

@keyframes play4 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -4));
    }
}

@keyframes play5 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -5));
    }
}

@keyframes play6 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -6));
    }
}

@keyframes play7 {
    to {
        transform: rotateX(calc(5 * 360deg + 360deg / var(--nums) * -7));
    }
}
</style>