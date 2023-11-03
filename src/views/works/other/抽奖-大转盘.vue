<template>
    <div class="overall">
        <div class="zp-box">
            <div class="panzi">
                <div class="bck-box" :style="` transform: rotate(${-90 + 180 / list.length}deg)`">
                    <div class="bck" v-for="(i, index) in list" :key="index"
                        :style="`transform: rotate(${-index * 360 / list.length}deg) skew(${-90 + 360 / list.length}deg);`">
                    </div>
                </div>
                <div class="jiang" :style="`transform: rotate(${-index * 360 / list.length}deg) translateY(-7.5rem);`"
                    v-for="(i, index) in list" :key="index">
                    <span class="title">{{ i.title }}</span>
                    <div class="img">
                        <!-- <img src="@/assets/img/bck.jpg" alt /> -->
                        img{{ index }}
                    </div>
                </div>
            </div>
            <div class="start-btn" @click="start()">抽奖</div>
        </div>
    </div>
</template>

<script>
export default {
    name: '抽奖-大转盘',
    link: 'https://juejin.cn/post/7165676884460568590',
    computed: {
        // eslint-disable-next-line vue/return-in-computed-property
        animationClass() {
            //对应css样式中定义的class属性值,如果有更多的话可以继续添加  case 8:   return 'wr8'
            switch (this.winner) {
                case 0:
                    return 'wr0'
                case 1:
                    return 'wr1'
                case 2:
                    return 'wr2'
                case 3:
                    return 'wr3'
                case 4:
                    return 'wr4'
                case 5:
                    return 'wr5'
                case 6:
                    return 'wr6'
                case 7:
                    return 'wr7'
            }
        }
    },
    data() {
        return {
            winner: 2, //指定获奖下标 specified为true时生效
            specified: false, //是否指定获奖结果，false时为随机
            loading: false, //抽奖执行状态，防止用户多次点击
            panziElement: null,
            list: [
                {
                    title: '特等奖'
                },
                {
                    title: '一等奖'
                },
                {
                    title: '二等奖'
                },
                {
                    title: '三等奖'
                },
                {
                    title: '四等奖'
                },
                {
                    title: '五等奖'
                },
                {
                    title: '六等奖'
                },
                {
                    title: '七等奖'
                }
            ]
        }
    },
    mounted() {
        //通过获取奖品个数，来改变css样式中每个奖品动画的旋转角度
        // var(--nums) 实现css动画根据奖品个数，动态改变
        let root = document.querySelector(':root')
        root.style.setProperty('--nums', this.list.length)
    },
    methods: {
        //开始抽奖
        start() {
            if (!this.loading) {
                this.panziElement = document.querySelector('.panzi')
                this.panziElement.classList.remove(this.animationClass)
                if (this.specified) {
                    //此处可指定后端返回的指定奖品
                    // this.winner = this.winner
                    this.winCallback()
                } else {
                    this.winner = this.random(0, this.list.length - 1)
                    this.winCallback()
                }
                this.loading = true
            }
        },
        //中奖返回方法
        winCallback() {
            setTimeout(() => {
                /* 此处是为了解决当下次抽中的奖励与这次相同，动画不重新执行的 */
                /* 添加一个定时器，是为了解决动画属性的替换效果，实现动画的重新执行 */
                this.panziElement.classList.add(this.animationClass)
                /* 此处是为了记录最终的获奖位置，这样下次旋转就可以从此处开始了 */
                /* 因为动画是 5*360deg 的转度，所以此处设置后，依旧可以旋转 */
                this.panziElement.style.transform = `rotate(${360 / this.list.length * this.winner}deg)`
            }, 0)
            // 因为动画时间为 3s ，所以这里3s后获取结果，其实结果早就定下了，只是何时显示，告诉用户
            setTimeout(() => {
                this.loading = false
                // console.log(`恭喜你获得了${this.winner}`)
            }, 3000)
        },
        //随机一个整数的方法
        random(min, max) {
            return parseInt(Math.random() * (max - min + 1) + min)
        }
    }
}
</script>
<style lang="scss" scoped>
$zp_size: 23rem; //转盘尺寸
$btn_size: 7rem; //抽奖按钮尺寸
$time: 3s; //转动多少秒后停下的时间

.zp-box {
    user-select: none;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    width: $zp_size;
    height: $zp_size;

    /* 抽奖按钮 */
    .start-btn {
        display: inline-block;
        background: #f53737;
        position: relative;
        z-index: 2;
        cursor: pointer;
        width: $btn_size;
        height: $btn_size;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        font-size: 30px;
        font-weight: bold;
        box-sizing: border-box;
        position: relative;
        z-index: 2;

        &::before {
            content: '';
            width: 0;
            height: 0;
            border: 2rem solid transparent;
            border-top: 3rem solid transparent;
            border-bottom: 3rem solid #f53737;
            position: absolute;
            top: -5rem;
            z-index: -1;
        }
    }

    /* 盘子样式 */
    .panzi {
        overflow: hidden;
        border-radius: 50%;
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        border: 10px solid #f74e4e;
        box-sizing: border-box;

        /* 每个奖项的样式 */
        .jiang {
            position: absolute;

            .title {
                font-weight: bold;
                font-size: 18px;
                color: #3b3b3b;
            }

            .img {
                margin: 0.5rem auto;
                width: 2.5rem;
                height: 2.5rem;
                line-height: 2.5rem;
                border: 2px dashed #f87373;
                overflow: hidden;
                color: white;

                img {
                    height: 100%;
                }
            }
        }
    }

    .bck-box {
        overflow: hidden;
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        // background: blue;
        border-radius: 50%;

        /* 转盘扇形背景 */
        .bck {
            box-sizing: border-box;
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 1;
            top: -50%;
            left: 50%;
            transform-origin: 0% 100%;
            // transform:skew(30deg);
        }

        /* 转盘背景色 */
        .bck:nth-child(2n) {
            background: #fffcb9;
        }

        .bck:nth-child(2n + 1) {
            background: #f8a281;
            box-shadow: 0 0 5px red;
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
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 0));
        }
    }

    @keyframes play1 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 1));
        }
    }

    @keyframes play2 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 2));
        }
    }

    @keyframes play3 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 3));
        }
    }

    @keyframes play4 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 4));
        }
    }

    @keyframes play5 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 5));
        }
    }

    @keyframes play6 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 6));
        }
    }

    @keyframes play7 {
        to {
            transform: rotate(calc(5 * 360deg + 360deg / var(--nums) * 7));
        }
    }
}
</style>