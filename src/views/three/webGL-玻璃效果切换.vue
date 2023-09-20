<script setup>
import { nextTick, onMounted } from 'vue'
import hoverEffect from '@/assets/js/threejsHover'
const list = [
  '/images/displacement/1.jpg',
  '/images/displacement/2.jpg',
  '/images/displacement/3.jpg',
  '/images/displacement/4.jpg',
  '/images/displacement/5.png',
  '/images/displacement/6.jpg',
  '/images/displacement/7.jpg',
  '/images/displacement/8.jpg',
  '/images/displacement/9.jpg',
  '/images/displacement/10.jpg',
  '/images/displacement/11.jpg',
  '/images/displacement/12.jpg',
  '/images/displacement/13.jpg',
  '/images/displacement/14.jpg',
  '/images/displacement/15.jpg',
  '/images/displacement/16.jpg'
]
onMounted(() => {
  nextTick(() => {
    Array.from(document.querySelectorAll('.img-item')).forEach((el) => {
      const imgs = Array.from(el.querySelectorAll('img')) //获取标签下的所有图片
      new hoverEffect({
        parent: el, //标签元素
        intensity: el.dataset.intensity || undefined, //强度
        speedIn: el.dataset.speedin || undefined, //进入速度
        speedOut: el.dataset.speedout || undefined, //离开速度
        image1: imgs[0].getAttribute('src'), // 图片1
        image2: imgs[1].getAttribute('src'), // 图片2
        displacementImage: el.dataset.displacement //转换效果图片
      })
    })
  })
})
</script>
<template>
  <div class="app-content">
    <div
      class="img-item"
      v-for="item in list"
      :key="item"
      :data-displacement="item"
      data-intensity="-0.65"
      data-speedIn="1.2"
      data-speedOut="1.2"
    >
      <img :src="`https://picsum.photos/600/400?random=${item}`" alt="" />
      <img :src="`https://picsum.photos/600/400?random=${item + list.length}`" alt="" />
    </div>
  </div>
</template>
<style scoped>
.app-content {
  display: grid;
  grid-gap: 1rem;
  grid-template-columns: repeat(1, 1fr);
  justify-items: center;
}
.img-item {
  width: 40vmax;
  height: calc(40vmax * (4 / 6));
  overflow: hidden;
  position: relative;
}
.img-item img {
  display: none;
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
}
</style>
