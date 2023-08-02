<template>
  <div class="overall">
    <div class="lottery-box">
      <div class="lottery" v-for="(i,index) in list" :key="index">
        <div class="item" :class="{'on':index == rollIndex}">{{i.title}}</div>
      </div>
      <div class="start" @click="start()">抽奖</div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      winner: 0, //指定获奖下标 specified为true时生效
      specified: true, //是否指定获奖结果，false时为随机
      rollIndex: -1, //转动时的下标位置
      prize: -1, // 中奖位置
      count: 8, // 总共有多少个位置
      speed: 100, // 初始转动速度
      cycle: 50, // 转动基本次数：即至少需要转动多少次再进入抽奖环节
      rolling: false, //是否处于抽奖状态，防止多次点击
      timer: null, // 每次转动定时器
      times: 0, // 转动次数
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
  methods: {
    start() {
      if (!this.rolling) {
        this.startRoll()
      }
    },
    //开始转动方法
    startRoll() {
      this.rolling = true //开启转动状态
      this.times += 1 // 转动次数
      this.oneRoll() // 转动过程调用的每一次转动方法，这里是第一次调用初始化

      // 如果当前转动次数达到要求 && 目前转到的位置是中奖位置
      if (this.times > this.cycle + 10 && this.prize === this.rollIndex) {
        clearTimeout(this.timer) // 清除转动定时器，停止转动
        //初始化相关数据
        this.times = this.$options.data().times
        this.speed = this.$options.data().speed
        setTimeout(res => {
          this.rolling = false
          alert(`恭喜你抽中了${this.list[this.rollIndex].title}`)
        }, 500)
      } else {
        if (this.times < this.cycle) {
          this.speed -= 10 // 加快转动速度
        } else if (this.times === this.cycle) {
          //当转动次数达到规定的 必要转动次数后 开始确定中奖位置
          //判断是否指定获奖结果，false时为随机
          if (this.specified) {
            this.prize = this.winner
          } else {
            const index = this.random(0, this.count - 1) // 随机获得一个中奖位置
            this.prize = index //中奖位置,可由后台返回
          }
        } else {
            //当转动次数times > cycle规定停止的转次时，开始慢慢减速，直到达到指定的中奖位置
          this.speed += 20
        }
        //当转速达到一定高度时，就固定为40ms/转
        if (this.speed < 40) {
          this.speed = 40
        }
        this.timer = setTimeout(this.startRoll, this.speed)
      }
    },
    // 每一次转动
    oneRoll() {
      let index = this.rollIndex // 当前转动到哪个位置
      const count = this.count // 总共有多少个位置
      index += 1
      if (index > count - 1) {
        index = 0
      }
      this.rollIndex = index
    },
    random(min, max) {
      return parseInt(Math.random() * (max - min + 1) + min)
    }
  }
}
</script>
<style lang="scss" scoped>
$lottery_w: 5rem; //每个奖品的宽高
$lottery_h: 5rem; //每个奖品的宽高
$lottery_margin: 0.2rem; //每个奖品的间隔

.lottery-box {
  position: relative;
  //抽奖盒子宽高 因为是 3*3布局，所以这里*3
  width: $lottery_w * 3;
  height: $lottery_h * 3;
  //抽奖按钮样式
  .start {
    width: $lottery_w - $lottery_margin * 2;
    height: $lottery_h - $lottery_margin * 2;
    background: rgb(8, 230, 218);
    position: absolute;
    top: $lottery_h + $lottery_margin;
    left: $lottery_w + $lottery_margin;
    border-radius: 0.5rem;
    display: flex;
    justify-content: center;
    align-items: center;
    color: white;
  }
  //每个奖品的外层样式
  .lottery {
    background: #fcfcfc;
    width: $lottery_w;
    height: $lottery_h;
    box-sizing: border-box;
    position: absolute;
    left: 0;
    top: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: $lottery_margin;
    // 每个奖品的内容样式
    .item {
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      box-sizing: border-box;
      border-radius: 0.5rem;
      box-shadow: 0 0 5px #ccc;
      //转动时的高亮效果
      &.on {
        background: rgb(92, 245, 199);
        color: white;
        font-weight: bold;
      }
    }
  }
  //针对每个奖品块单独调整位置，以便适应于跑马灯的效果
  .lottery:nth-child(1) {
    left: 0;
    top: 0;
  }
  .lottery:nth-child(2) {
    top: 0 * $lottery_h;
    left: $lottery_w;
  }
  .lottery:nth-child(3) {
    top: 0 * $lottery_h;
    left: 2 * $lottery_w;
  }
  .lottery:nth-child(4) {
    top: 1 * $lottery_h;
    left: 2 * $lottery_w;
  }
  .lottery:nth-child(5) {
    top: 2 * $lottery_h;
    left: 2 * $lottery_w;
  }
  .lottery:nth-child(6) {
    top: 2 * $lottery_h;
    left: 1 * $lottery_w;
  }
  .lottery:nth-child(7) {
    top: 2 * $lottery_h;
    left: 0 * $lottery_w;
  }
  .lottery:nth-child(8) {
    top: 1 * $lottery_h;
    left: 0 * $lottery_w;
  }
}
</style>