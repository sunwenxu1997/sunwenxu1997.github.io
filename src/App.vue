<script setup>
import { RouterView } from 'vue-router'
import HeaderNav from './components/HeaderNav.vue'
import { computed } from 'vue'
import { useRouter } from 'vue-router'
// 路由缓存
const keepAliveRoutes = computed(() => {
  const routes = useRouter().options.routes
  // 存在meta.keepAlive的路由，会根据name进行缓存
  return routes.filter((item) => item.meta?.keepAlive).map((item) => item.name)
})
</script>

<template>
  <HeaderNav />
  <router-view v-slot="{ Component }">
    <keep-alive :include="keepAliveRoutes">
      <component :is="Component" />
    </keep-alive>
  </router-view>
</template>

<style lang="scss" scoped></style>
