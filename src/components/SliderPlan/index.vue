<template>
  <div class="plan_box" ref="wrapper">
    <div
      class="plan"
      :style="`clip-path: polygon(0 0,${plan}% 0,${plan}% 100%,0 100%);background: linear-gradient(to left, ${this.gradient});`"
    ></div>
    <div class="slider" ref="slider">
      <span class="text">{{planNum}}%</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    planNum: Number, //进度数值
    color: { //背景颜色，['#e233ff'] 为单色 ，['#e233ff', '#ff6b00']为渐变色
      type: Array,
      default: function() {
        return ['#e233ff', '#ff6b00']
      }
    }
  },
  computed: {
    plan: {
      get() {
        return this.planNum
      },
      set(val) {
        this.$emit('update:planNum', Number(val))
      }
    },
    gradient() {
      if (this.color.length > 1) {
        return this.color.join(',')
      } else {
        return `${this.color[0]},${this.color[0]}`
      }
    }
  },
  data() {
    return {
      //   plan: 55
    }
  },
  mounted() {
    this.init(this.$refs.wrapper)
  },
  methods: {
    //pc端鼠标拖动
    mouseDown(el) {
      var _this = this
      var $el = el
      var slider = _this.$refs.slider
      var rect = $el.getBoundingClientRect()
      if (_this.plan) {
        let plan = _this.plan
        slider.style.left = (plan / 100) * rect.width + 'px'
      }
      slider.onmousedown = function(event) {
        event.preventDefault()
        document.onmousemove = function(e) {
          var sliderX = e.clientX - rect.left
          if (sliderX < 0) {
            sliderX = 0
          } else if (sliderX > rect.width) {
            sliderX = rect.width
          }
          //   console.log(sliderX)
          //滑块的位置
          slider.style.left = sliderX + 'px'
          //进度条的长度
          _this.plan = ((sliderX / rect.width) * 100).toFixed(0)
        }
        document.onmouseup = function() {
          document.onmousemove = null
          document.onmousedown = null
        }
      }
    },
    touchStart(el) {
      var _this = this
      var $el = el
      var slider = _this.$refs.slider
      var rect = $el.getBoundingClientRect()
      if (_this.plan) {
        let plan = _this.plan
        slider.style.left = (plan / 100) * rect.width + 'px'
      }
      slider.ontouchstart = function(event) {
        event.preventDefault()
        document.ontouchmove = function(e) {
          var oEvent = e.touches[0]
          var sliderX = oEvent.clientX - rect.left
          if (sliderX < 0) {
             sliderX = 0
          } else if (sliderX > rect.width) {
            sliderX = rect.width
          }
          // console.log(sliderX)
          //滑块的位置
          slider.style.left = sliderX + 'px'
          //进度条的长度
          _this.plan = ((sliderX / rect.width) * 100).toFixed(0)
        }
        document.ontouchend = function() {
          document.ontouchmove = null
          document.ontouchstart = null
        }
      }
    },
    init(el) {
      // 判断是否为移动设备
      if (/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
        this.touchStart(el)
      } else {
        this.mouseDown(el)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.plan_box {
  margin: 50px 0;
  height: 11px;
  width: 300px;
  // border: 1px solid black;
  background: #f1f1f1;
  box-sizing: border-box;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 5px;
  .plan {
    width: 100%;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    // background: black;

    border-radius: 5px;
  }
  .slider {
    cursor: grab;
    position: absolute;
    left: 0px;
    &::before {
      content: '';
      display: block;
      width: 20px;
      height: 20px;
      border-radius: 50%;
      background: white;
      box-shadow: 2px 2px 4px #919191;
      position: absolute;
      left: -10px;
      top: -10px;
    }
    .text {
      font-size: 12px;
      position: absolute;
      display: inline-block;
      padding: 5px;
      border-radius: 3px;
      background: white;
      top: -45px;
      left: -20px;
      box-shadow: 2px 2px 4px #d3d3d3;
      user-select: none;
      pointer-events: none;
      &::after{
          content: '';
          display: block;
          width: 0;
          height: 0;
          border: 5px solid transparent;
          border-top: 5px solid white;
          position: absolute;
          bottom: -10px;
          left: 45%;
      }
    }
  }
}
</style>