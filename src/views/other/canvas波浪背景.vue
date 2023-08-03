<template>
   <div id="wave" :style="`height:${waveAllHeight}px`">
      <h1>波浪效果</h1>
      <div class="wave-box">
        <canvas id="wave1"></canvas>
        <canvas id="wave2"></canvas>
        <canvas id="wave3"></canvas>
      </div>
    </div>
</template>

<script>
export default {
  data() {
    return {
      waveAllHeight: 400, //波浪的整体高度
      waveCount: 5, //波浪个数
      waveHeight: 15, //波浪起伏高度
    };
  },
  mounted() {
    this.wavePlay("wave1", 140, "hsl(230, 97%, 61%)", 1500);
    this.wavePlay("wave2", 140, "hsl(200, 97%, 61%)", 3000);
    this.wavePlay("wave3", 140, "hsl(170, 97%, 61%)", 2500);
  },
  methods: {
    //  * 底部波浪
    //  * @param $canvasID     canvasID
    //  * @param $progress     波浪位置的高度
    //  * @param $maveColor    波浪颜色
    //  * @param $time         运动周期
    //
    //波浪运动动画
    wavePlay($canvasID, $progress, $maveColor, $time) {
      let _this = this;
      let waveWidth = 3300, //波浪长度
        offset = 0,
        waveHeight = _this.waveHeight, //波浪起伏高度
        waveCount = _this.waveCount, //波浪个数
        startX = -1000,
        startY = 212, //canvas 高度
        progress = $progress, //波浪位置高度
        d2 = waveWidth / waveCount, //单个波浪的宽度
        d = d2 / 2,
        hd = d / 2,
        c = document.getElementById($canvasID),
        ctx = c.getContext("2d");
      c.width = 1920; //画布宽度
      c.height = _this.waveAllHeight; //画布高度
      function move() {
        offset -= 5;
        if (-1 * offset === d2) {
          offset = 0;
        }
        ctx.clearRect(0, 0, c.width, c.height);
        ctx.fillStyle = $maveColor; //画布填充色
        ctx.beginPath();
        let offsetY = startY - progress;
        //绘制贝塞尔曲线
        ctx.moveTo(startX - offset, offsetY); //开始点
        for (let i = 0; i < waveCount; i++) {
          let dx = i * d2;
          let offsetX = dx + startX - offset;
          //   quadraticCurveTo(1,1,2,2) 方法通过使用表示二次贝塞尔曲线的指定控制点，向当前路径添加一个点。(1,1控制点，2,2结束点)
          ctx.quadraticCurveTo(
            offsetX + hd,
            offsetY + waveHeight,
            offsetX + d,
            offsetY
          );
          ctx.quadraticCurveTo(
            offsetX + hd + d,
            offsetY - waveHeight,
            offsetX + d2,
            offsetY
          );
        }
        ctx.lineTo(startX + waveWidth, 3000);
        ctx.lineTo(startX, 3000);
        ctx.fill();
        setTimeout(move, $time / 60); //速度
      }

      move();
    },
  },
};
</script>

<style lang="scss" scoped>
#wave {
  width: 100%;
  overflow: hidden;
  position: relative;
  h1 {
    text-align: center;
    color: white;
    font-size: 40px;
    font-weight: 300;
    text-transform: uppercase; //转大写
    line-height: 300px;
    position: relative;
    z-index: 5;
  }
}
.wave-box {
  transform: scaleY(-1); //翻转波浪位置
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
  // z-index: -1;
}
canvas {
  opacity: 0.5;
  position: absolute;
  left: 0;
  top: 0;
}
</style>