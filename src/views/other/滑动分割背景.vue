<script setup>
import { onMounted, onUnmounted } from 'vue'
onMounted(() => {
  window.addEventListener('mousemove', mousemove)
})
onUnmounted(() => {
  window.removeEventListener('mousemove', mousemove)
})
const mousemove = (e) => {
  // 鼠标移动时，顶层的背景宽度根据鼠标位置改变
  const left = document.getElementById('left-side')
  left.style.width = `${(e.clientX / window.innerWidth) * 100}%`
}
</script>
<template>
  <div id="left-side" class="side">
    <h2 class="title">
      我是 光明和黑暗
      <p class="fancy">I am the light and the dark</p>
    </h2>
  </div>
  <div id="right-side" class="side">
    <h2 class="title">
      我是 光明和黑暗
      <p class="fancy">I am the light and the dark</p>
    </h2>
  </div>
</template>
<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css?family=Rajdhani:300&display=swap');
$--light: white;
$--dark: black;

.side {
  display: grid;
  height: 100vh;
  overflow: hidden;
  place-items: center;
  position: absolute;
  width: 100%;
  cursor: default;
}

.side .title {
  font-size: 8vw;
  margin: 0px 10vw;
  width: 80vw;
  text-align: center;
}

.side .fancy {
  font-family: 'Rajdhani', sans-serif;
  font-size: 0.8em;
  line-height: 1em;
  margin: 40px 0;
  width: 80vw;
  font-weight: 200;
}

#left-side {
  background-color: $--dark;
  width: 60%;
  z-index: 2;
}

#left-side .title {
  color: white;
}

#left-side .fancy {
  color: $--light;
}

#right-side {
  background-color: $--light;
}

#right-side .title {
  color: $--dark;
}

#right-side .fancy {
  color: $--dark;
}
</style>
