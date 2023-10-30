<script>
/**
 * 优先采取移动端样式开发，加上md:时，表示在md屏幕以上才生效
 * 不要把 sm: 当成 “在小屏幕上” 的意思，把它当成 “在小断点“
 * 通常最好先为设计实现移动布局，然后对任何对 sm 屏幕有意义的更改进行分层，然后是 md 屏幕
 * https://tailwindcss.com/docs/responsive-design#working-mobile-first
 */
export default {
  hidden: true // 页面路由隐藏
}
</script>
<script setup>
import { ref, reactive, onMounted } from 'vue'
onMounted(() => {
  console.log(import.meta)
})
</script>
<template>
  <div class="fixed w-full h-20 bg-white shadow-md px-3 z-50">
    <div class="flex items-center justify-center h-full text-center">
      <h1 class="uppercase text-center text-base text-sky-800 font-bold py-3 sm:w-1/5">opple</h1>
      <div class="hidden sm:flex sm:justify-around sm:items-center sm:w-full">
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >全屋智能照明</span
        >
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >家居照明</span
        >
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >商用照明</span
        >
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >道路照明</span
        >
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >欧普门店</span
        >
        <span
          class="text-sm text-current font-extralight leading-normal py-3 cursor-pointer relative before:transition-all before:origin-center before:scale-x-0 before:w-full hover:before:scale-x-100 before:h-[2px] before:bg-black before:absolute before:bottom-0"
          >关于欧普</span
        >
      </div>
    </div>
  </div>
  <div class="w-full h-80 pt-20 sm:h-screen">
    <img class="w-full h-full object-cover" src="https://picsum.photos/1920/1080?random=1" alt="" />
  </div>
  <h1 class="text-center text-slate-700 text-xl my-4 font-bold sm:text-2xl">为您推荐</h1>
  <div class="sm:flex sm:justify-center sm:items-center">
    <div class="sm:w-2/5">
      <div class="w-60 h-auto mx-auto my-4 rounded-md overflow-hidden sm:w-3/4">
        <img class="w-full" src="https://www.opple.com.cn/media/3104/风扇灯.png" alt="" />
      </div>
      <h1 class="text-center my-1 font-normal">风扇灯</h1>
      <p class="text-center text-base text-slate-500">欧普新一代风扇灯，超10项创新技术</p>
    </div>
    <div class="w-full flex flex-nowrap my-4 overflow-x-auto sm:w-2/5 sm:grid sm:grid-cols-3 sm:gap-3 sm:overflow-x-hidden">
      <div
        class="w-2/5 h-55 relative shrink-0 ml-5 rounded-md overflow-hidden bg-white sm:w-full "
        v-for="item in 9"
        :key="item"
      >
        <p class="text-sm absolute z-10 top-3 left-3">护眼灯</p>
        <img
          class="w-full h-full object-cover block scale-50"
          src="https://www.opple.com.cn/media/4311/封面_悦瞳.png"
          alt=""
        />
      </div>
    </div>
  </div>
</template>
<style scoped></style>
