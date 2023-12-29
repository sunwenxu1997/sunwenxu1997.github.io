<template>
  <div class="overall">
    <div class="container">
      <div class="button one" cursor="link">button1</div>
      <div class="button two" cursor="link">button2</div>
      <div class="button three" cursor="link">button3</div>
      <div class="cursor"></div>
    </div>
  </div>
</template>

<script>
export default {
  cover: 'https://iili.io/JRSzVKg.gif',
  info: `多用于导航栏文字效果，让人感觉有种吸附的效果，主要用的就是监听鼠标得移入移出。
    知识点：
    1. <code>addEventListener</code>监听进入按钮时得 mousemove mouseleave
    2. <code>rotate3d(x, y, z, angle)</code>
       x：表示绕着X轴旋转的角度。
       y：表示绕着Y轴旋转的角度。
       z：表示绕着Z轴旋转的角度。
       angle：表示旋转的角度，单位为度（deg）
  
    `,
  mounted() {
    this.init()
  },
  methods: {
    init() {
      this.cursor()
      this.buttonMouseListener()
    },
    // 按钮粘性效果实现
    buttonMouseListener() {
      let buttons = document.querySelectorAll('.button')
      buttons.forEach((el) => {
        // 移入到按钮时
        el.addEventListener('mousemove', function (e) {
          /* getBoundingClientRect用于获取某个元素相对于视窗的位置集合。集合中有top, right, bottom, left等属性 */
          //   https://www.jianshu.com/p/824eb6f9dda4
          const pos = el.getBoundingClientRect()
          const mx = e.clientX - pos.left - pos.width / 2
          const my = e.clientY - pos.top - pos.height / 2

          // 水平垂直偏移
          el.style.transform = `translate(${mx * 0.3}px,${my * 0.3}px)`
          // 3d旋转偏移
          // rotate3d(x, y, z, angle)
          /**
           * x：表示绕着X轴旋转的角度。取值范围为[-1, 1]，其中-1表示绕着X轴旋转180度，1表示绕着X轴旋转180度。
           * y：表示绕着Y轴旋转的角度。取值范围为[-1, 1]，其中-1表示绕着Y轴旋转180度，1表示绕着Y轴旋转180度。
           * z：表示绕着Z轴旋转的角度。取值范围为[-1, 1]，其中-1表示绕着Z轴旋转180度，1表示绕着Z轴旋转180度。
           * angle：表示旋转的角度，单位为度（deg）
           */
          el.style.transform += `rotate3d(${mx * -0.1},${my * -0.3},0,20deg)`
        })
        // 移出按钮时
        el.addEventListener('mouseleave', function () {
          el.style.transform = 'translate3d(0px, 0px, 0px)'
          el.style.transform = 'rotate3d(0, 0, 0, 0deg)'
        })
      })
    },
    //鼠标样式背景跟随
    cursor() {
      let cursor = document.querySelector('.cursor')
      document.addEventListener('mousemove', function (e) {
        cursor.style.left = e.clientX - 10 + 'px'
        cursor.style.top = e.clientY - 10 + 'px'
      })
    }
  }
}
</script>
<style></style>
<style lang="scss" scoped>
$cursorSize: 20px;
.overall {
  background: #dbfbff;
}
/* 鼠标样式 */
.cursor {
  pointer-events: none; //禁止选择器方法
  border-radius: 50%;
  z-index: 999;
  background: none;
  position: fixed;
  left: -$cursorSize;
  top: -$cursorSize;
  width: $cursorSize;
  height: $cursorSize;
  border-radius: 50%;
  border: 2px solid #ccc;
  transition:
    transform 0.3s ease,
    background 0.3s ease,
    border-color 0.3s ease;
}
/* 鼠标放在按钮上 仿鼠标标签的样式变化 */
[cursor='link']:hover ~ .cursor {
  mix-blend-mode: difference;
  transform: scale(1.5);
  background: #fff;
  border-color: #fff;
}
/* 鼠标点击按钮  仿鼠标标签的样式变化 */
[cursor='link']:active ~ .cursor {
  transform: scale(0.8);
}
.container {
  /* https://developer.mozilla.org/zh-CN/docs/Web/CSS/isolation */
  isolation: isolate; /*如果不单独使用，背景颜色将被考虑进去*/
  display: flex;
  position: absolute;
  width: 100%;
  height: 100%;
  align-items: center;
  justify-content: center;
  transform-style: preserve-3d;
  perspective: 500px;
}
.button {
  border-radius: 2px;
  box-shadow: 0 10px 30px rgba(65, 72, 86, 0.1);
  cursor: none;
  display: inline-block;
  padding: 10px 20px;
  color: white;
  font-size: 20px;
  font-weight: 200;
  margin: 0 20px;
  outline: none;
  user-select: none;
  transition:
    transform 0.1s linear,
    color 0.1s linear,
    background 0.15s linear;
}
.button.one {
  background: #4f29f0;
}
.button.two {
  border: 1px solid #5a5a5a;
  color: #5a5a5a;
  background: none;
}
.button.three {
  background: #12d0e9;
}
</style>
