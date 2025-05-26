<script>
export default {
  hidden: true
}
</script>
<template>
  <div class="app-center">
    <div class="draggable-tabs-box">
      <DraggableTabs :list="list" v-model:active="activeId"> </DraggableTabs>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import DraggableTabs from '@/components/DraggableTabs/index.vue'
const activeId = ref(3)
const list = reactive([
  {
    name: '推荐',
    id: 1,
    content: '推荐内容'
  },
  {
    name: '关注',
    id: 2,
    content: '关注内容'
  },
  {
    name: '销量',
    id: 3,
    content: '销量内容'
  },
  {
    name: '新品',
    id: 4,
    content: '新品内容'
  },
  {
    name: '价格',
    id: 5,
    content: '价格内容'
  }
])
watch(
  () => activeId.value,
  (newVal) => {
    console.log(list.find((item) => item.id === newVal).name)
  }
)
onMounted(() => {})
</script>
<style lang="scss" scoped>
.app-center {
  height: 100vh;
  display: grid;
  place-content: center;
  overflow: hidden;
}
.draggable-tabs-box {
  width: 300px;
}
</style>
