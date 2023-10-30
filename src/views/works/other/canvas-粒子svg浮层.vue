<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import imgSrc from '@/assets/icons/github.svg'
onMounted(() => {
  init()
})
onUnmounted(() => {
  cancelAnimationFrame(requestAnimationFrameFun.value)
})
const requestAnimationFrameFun = ref(null)
const init = () => {
  //相关配置参数
  var img_src = imgSrc //图片路径
  var img_w = 200 //图片宽
  var img_h = 200 //图片高
  var max_radius = 4 //粒子的最大半径
  var min_radius = 1 //粒子的最小半径
  var rate = 0.1 //粒子显示率，最高1 越高显示粒子越密集
  var drag = 50 //粒子被冲散后的聚合速度，值越小越快 不能为0

  var colors_img = false //根据图片颜色生成粒子，开启后 colors无效
  var colors = ['rgba(64, 158, 255, 0.7)', 'rgba(64, 158, 255, 0.4)'] //粒子颜色数组

  // 创建画布
  var canvas = document.createElement('canvas')
  var w = window.innerWidth
  var h = window.innerHeight
  const el = document.querySelector('.canvas-particle-svg')
  el.appendChild(canvas)
  canvas.width = w
  canvas.height = h
  var ctx = canvas.getContext('2d')

  var particles = [] //所有存在的粒子集合

  //初始鼠标坐标
  var mouse = {
    x: -1000,
    y: -1000
  }
  canvas.onmousemove = function (e) {
    mouse.x = e.clientX
    mouse.y = e.clientY
  }
  canvas.ontouchmove = function (e) {
    mouse.x = e.touches[0].clientX
    mouse.y = e.touches[0].clientY
  }

  //添加图片方法
  function addIMG() {
    return new Promise((reslove) => {
      var img = new Image()
      img.src = img_src
      img.onload = function () {
        //默认居中显示，(img,x,y,w,h) x y 可调整图片的位置
        ctx.drawImage(img, w / 2 - img_w / 2, h / 2 - img_h / 2, img_w, img_h)
        reslove()
      }
    })
  }

  // 返回一个数的平方根方法
  function distance(x, y, x1, y1) {
    return Math.sqrt((x1 - x) * (x1 - x) + (y1 - y) * (y1 - y))
  }
  //获取图片上的像素数据
  async function handleImgPxData() {
    await addIMG()
    var temp, radius, color
    //通过 getImageData() 复制画布上指定矩形的像素数据 RGBA(R,G,B,A) 此处+=4取得是 R
    // rgba(255,255,255,1) 纯白色      rgba(0,0,0,1) 出黑色
    var data = ctx.getImageData(0, 0, w, h).data
    for (let i = 0; i < data.length; i += 4) {
      temp = {
        x: (i / 4) % w,
        y: ~~(i / 4 / w)
      }

      if (data[i] !== 0 && ~~((Math.random() * 2) / (2 - rate))) {
        if (colors_img) {
          let r, g, b, a
          r = data[i]
          g = data[i + 1]
          b = data[i + 2]
          a = data[i + 3]
          color = `rgba(${r},${g},${b},${a})`
        } else {
          color = colors[~~(Math.random() * colors.length)]
        }
        radius = max_radius - Math.random() * min_radius
        var p = new Particle(
          temp,
          { x: (i / 4) % w, y: ~~(i / 4 / w) },
          { x: 0, y: 0 },
          color,
          radius
        )

        particles.push(p)
      }
    }
  }

  //创建一个粒子的类，制定相关属性
  class Particle {
    constructor(pos, target, vel, color, radius) {
      this.pos = pos
      this.target = target
      this.vel = vel
      this.color = color
      this.radius = radius
      var arr = [-1, 1]
      this.direction = (arr[~~(Math.random() * 2)] * Math.random()) / 10
    }
    update() {
      this.radius += this.direction
      this.vel.x = (this.pos.x - this.target.x) / drag
      this.vel.y = (this.pos.y - this.target.y) / drag
      if (distance(this.pos.x, this.pos.y, mouse.x, mouse.y) < 50) {
        this.vel.x += this.vel.x - (this.pos.x - mouse.x) / 15
        this.vel.y += this.vel.y - (this.pos.y - mouse.y) / 15
      }
      if (this.radius >= max_radius) {
        this.direction *= -1
      }
      if (this.radius <= 1) {
        this.direction *= -1
      }

      this.pos.x -= this.vel.x
      this.pos.y -= this.vel.y
      this.draw()
    }
    draw() {
      ctx.beginPath()
      ctx.fillStyle = this.color
      ctx.arc(this.pos.x, this.pos.y, this.radius, 0, Math.PI * 2)
      ctx.fill()
    }
  }

  //绘制粒子文字
  function draw() {
    ctx.clearRect(0, 0, w, h)
    for (let n of particles) {
      n.update()
    }
  }
  //每帧执行的粒子变化动画
  function animation() {
    // 相当于每一帧都会执行一次方法
    requestAnimationFrameFun.value = window.requestAnimationFrame(animation)
    draw()
  }
  animation()
  handleImgPxData()
}
</script>
<template>
  <div class="canvas-particle-svg"></div>
</template>
<style scoped>
.canvas-particle-svg {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

.canvas-particle-svg canvas{
    display: block;
    width: 100%;
    height: 100%;
}
</style>
