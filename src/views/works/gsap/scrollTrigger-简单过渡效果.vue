<template>
  <div class="app-content">
    <div
      class="box"
      :class="index % 2 == 1 ? 'gs_reveal_fromRight' : 'gs_reveal_fromLeft'"
      v-for="(item, index) in list"
      :key="item"
    >
      <div class="item">
        <div class="img">
          <img
            width="400"
            height="400"
            :src="`https://picsum.photos/400/400?random=${index}`"
            alt=""
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger.js'
export default {
  link: 'https://juejin.cn/post/7165808796462219295',
  data() {
    return {
      list: 30
    }
  },
  mounted() {
    gsap.registerPlugin(ScrollTrigger)
    this.init()
  },
  unmounted() {
    ScrollTrigger.killAll()
  },
  methods: {
    //执行动画的方法
    animateFrom(elem, direction) {
      direction = direction || 1 //执行方向
      var x = 0,
        y = direction * 100
      //判断是否包含class，用来区分从左或从右出发方向
      if (elem.classList.contains('gs_reveal_fromLeft')) {
        x = -100
        y = 0
      } else if (elem.classList.contains('gs_reveal_fromRight')) {
        x = 100
        y = 0
      }
      elem.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
      elem.style.opacity = '0'
      gsap.fromTo(
        elem,
        { x: x, y: y, autoAlpha: 0 },
        {
          duration: 1.25,
          x: 0,
          y: 0,
          autoAlpha: 1,
          ease: 'expo',
          overwrite: 'auto'
        }
      )
    },
    hide(elem) {
      gsap.set(elem, { autoAlpha: 0 })
    },
    init() {
      let _this = this
      gsap.utils.toArray('.box').forEach((elem) => {
        _this.hide(elem)
        ScrollTrigger.create({
          trigger: elem,
          onEnter: function () {
            _this.animateFrom(elem)
          },
          onEnterBack: function () {
            _this.animateFrom(elem, -1)
          },
          onLeave: function () {
            _this.hide(elem)
          }
        })
      })
      gsap.utils.toArray('.title').forEach((elem) => {
        _this.hide(elem)
        ScrollTrigger.create({
          trigger: elem,
          onEnter: function () {
            _this.animateFrom(elem)
          },
          onEnterBack: function () {
            _this.animateFrom(elem, -1)
          },
          onLeave: function () {
            _this.hide(elem)
          }
        })
      })
    }
  }
}
</script>
<style lang="scss" scoped>
.app-content {
  margin: 0 auto;
  width: 45vmax;
  overflow: hidden;
  background-color: white;
}

.box {
  .item {
    margin: 0 40px;
    border-bottom: 1px solid #f8f8f8;
    display: flex;
    justify-content: center;
  }
  .img {
    min-width: 200px;
    width: 200px;
    height: 200px;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 40px;
    overflow: hidden;
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

}

.box:nth-child(2n + 1) .item{
  flex-direction: row-reverse;
}
</style>
