<script setup>
import { ref, reactive, onMounted, watch, computed } from 'vue'
import routes from '../router/routes'
import { useRouter } from 'vue-router'
import { useAppStore } from '../stores/index'
const store = useAppStore()
const $emit = defineEmits(['update:show'])
defineProps({
  show: {
    type: Boolean,
    default: false
  }
})
const $router = useRouter()
const keywords = ref('')
const resultList = computed(() => {
  if (!keywords.value) return []
  let resultArr = []
  routes.map((r, index) => {
    if (r.name.indexOf(keywords.value) > -1) {
      resultArr.push({ name: r.name, path: r?.path, index: index })
    }
  })
  return resultArr
})
onMounted(() => {})
const toPath = (row) => {
  // 通过搜索结果点击的路由也记录到随机的路由index数组中，避免下次随机到
  store.setRdmRouteIndexArr(row.index)
  $router.push(row.path)
  close()
}
const close = () => {
  keywords.value = ''
  $emit('update:show', false)
}
</script>
<template>
  <div class="search-bar" :class="show ? 'show' : 'hide'">
    <div class="input">
      <input v-model="keywords" type="text" placeholder="搜索关键词" />
    </div>
    <div class="result">
      <div class="item" v-for="item in resultList" :key="item.index" @click="toPath(item)">
        {{ item.name }}
      </div>
    </div>
    <div class="close-btn" @click="close"></div>
  </div>
</template>
<style lang="scss" scoped>
// 搜索框显示时的样式
.search-bar.show {
  opacity: 1;

  & .close-btn::before,
  & .close-btn::after {
    opacity: 1;
  }
  & .close-btn::before {
    transition: all 0.3s 0.3s cubic-bezier(0.72, 0.09, 0.32, 1.57);
    transform: rotate(45deg) translateX(0);
  }
  & .close-btn::after {
    transition: all 0.3s 0.45s cubic-bezier(0.72, 0.09, 0.32, 1.57);
    transform: rotate(-45deg) translateX(0);
  }

  & .input:after {
    transform: scaleX(1);
    transition-delay: 0.3s;
  }
}
// 搜索框隐藏时的样式
.search-bar.hide {
  opacity: 0;
  pointer-events: none; // 通过pointer-events: none;让元素不可点击
  transition-delay: 0.5s;
  & .close-btn::before {
    transition: all 0.3s 0.3s cubic-bezier(0.72, 0.09, 0.32, 1.57);
    transform: rotate(45deg) translateX(100%);
  }
  & .close-btn::after {
    transition: all 0.3s 0.45s cubic-bezier(0.72, 0.09, 0.32, 1.57);
    transform: rotate(-45deg) translateX(100%);
  }

  & .input:after {
    transform: scaleX(0.05);
    transition-delay: 0.3s;
  }
}
.search-bar {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  position: fixed;
  z-index: 99;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: white;
  display: grid;
  grid-template-rows: auto 50vh;
  place-content: center;
  transition: all 0.3s;
  .input {
    position: relative;
    &::after {
      content: '';
      width: 100%;
      height: 4px;
      background: #333333;
      position: absolute;
      left: 0;
      bottom: 0;
      transition: 0.3s;
    }
    input {
      width: 100%;
      background-color: transparent;
      color: #333333;
      border: none;
      outline: none;
      font-size: 3rem;
      padding: 1rem;
      text-align: center;
      &::placeholder {
        color: #bdbdbd;
      }
    }
  }
  .result {
    margin-top: 2rem;
    overflow-y: auto;
    /*滚动条容器*/
    &::-webkit-scrollbar {
      width: 4px;
      height: 4px;
      background-color: #e3e3e3;
    }

    /*滚动条里面小方块*/
    &::-webkit-scrollbar-thumb {
      background: #bfbfbf;
    }
    .item {
      font-size: 2rem;
      margin-bottom: 0.5rem;
      cursor: pointer;
      &:hover {
        text-decoration: underline;
      }
    }
  }
  .close-btn {
    width: 40px;
    height: 40px;
    cursor: pointer;
    position: absolute;
    top: 4vh;
    right: 1vw;
    &:after,
    &:before {
      content: '';
      position: absolute;
      width: 100%;
      height: 4px;
      background: #333333;
      opacity: 0;
      transition: opacity 0s;
    }
    &:before {
      transform: rotate(45deg) translateX(100%);
    }
    &:after {
      transform: rotate(-45deg) translateX(100%);
    }
  }
}
</style>
