<template>
  <div class="overall">
    <div class="container">
      <div class="button one" cursor="link">我很粘人</div>
      <!-- <div class="button two" cursor="link">button2</div>
      <div class="button three" cursor="link">button3</div> -->
      <div class="cursor"></div>
    </div>
  </div>
</template>

<script>
export default {
  mounted() {
    this.init();
  },
  methods: {
    init() {
      this.cursor();
      this.mousemove();
      this.mouseleave();
    },
    //鼠标执行方法
    cursor() {
      let cursor = document.querySelector(".cursor");
      document.addEventListener("mousemove", function (e) {
        cursor.style.left = e.clientX - 25 + "px";
        cursor.style.top = e.clientY - 25 + "px";
      });
    },
    mousemove() {
      let buttons = document.querySelectorAll(".button");
      buttons.forEach((el) => {
        el.addEventListener("mousemove", function (e) {
          /* getBoundingClientRect用于获取某个元素相对于视窗的位置集合。集合中有top, right, bottom, left等属性 */
          //   https://www.jianshu.com/p/824eb6f9dda4
          const pos = el.getBoundingClientRect();
          const mx = e.clientX - pos.left - pos.width / 2;
          const my = e.clientY - pos.top - pos.height / 2;

          el.style.transform =
            "translate(" + mx * 0.15 + "px, " + my * 0.3 + "px)";
          el.style.transform +=
            "rotate3d(" + mx * -0.1 + ", " + my * -0.3 + ", 0, 12deg)";
        });
      });
    },
    mouseleave() {
      let buttons = document.querySelectorAll(".button");
      buttons.forEach((el) => {
        el.addEventListener("mouseleave", function (e) {
          el.style.transform = "translate3d(0px, 0px, 0px)";
          el.style.transform = "rotate3d(0, 0, 0, 0deg)";
        });
      });
    },
  },
};
</script>
<style >
</style>
<style lang="scss" scoped>
$cursorSize: 50px;
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
  transition: transform 0.3s ease, background 0.3s ease, border-color 0.3s ease;
}
/* 鼠标放在按钮上 仿鼠标标签的样式变化 */
[cursor="link"]:hover ~ .cursor {
  mix-blend-mode: difference;
  transform: scale(1.5);
  background: #fff;
  border-color: #fff;
}
/* 鼠标点击按钮  仿鼠标标签的样式变化 */
[cursor="link"]:active ~ .cursor {
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
}
.button {
  border-radius: 2px;
  box-shadow: 0 10px 30px rgba(65, 72, 86, 0.1);
  cursor: none;
  display: inline-block;
  padding: 10px 20px;
  color: white;
  font-size: 14px;
  font-weight: 200;
  margin: 0 20px;
  outline: none;
  user-select: none;
  transition: transform 0.1s linear, color 0.1s linear, background 0.15s linear;
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