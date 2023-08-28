<script setup>
import IconRefresh from './icons/IconRefresh.vue'
import IconGithub from './icons/IconGithub.vue'
import IconLink from './icons/IconLink.vue'
import IconSearch from './icons/IconSearch.vue'
import 'element-plus/es/components/message/style/css'
import { ElMessage } from 'element-plus'
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import routes from '../router/routes'
import { useAppStore } from '../stores/index'
import SearchBar from './SearchBar.vue'
onMounted(() => {})
const $router = useRouter()
const $route = useRoute()
const store = useAppStore()
const showSearchBar = ref(false)
// 随即切换一个不一样的页面
const changeOther = () => {
  $router.push(store.createRandomRoute(routes).path)
}
const toGithubLink = () => {
  window.open($route.meta.githubCode, '_blank')
}
const toArticleLink = () => {
  let link = $route.meta.articleLink
  if (!link) {
    ElMessage({
      message: '🐔作者还没写~',
      center: true,
      grouping: true,
      type: 'warning'
    })
    return
  }
  window.open(link, '_blank')
}
const toSearch = () => {
  showSearchBar.value = true
}
</script>
<template>
  <div class="header-nav">
    <div class="nav">
      <div class="item" @click="changeOther" title="换一个">
        <IconRefresh />
      </div>
      <div class="item" @click="toGithubLink" title="Github地址">
        <IconGithub />
      </div>
      <div class="item" @click="toArticleLink" title="文章链接">
        <IconLink />
      </div>
      <div class="item" @click="toSearch" title="搜一搜">
        <IconSearch />
      </div>
    </div>
  </div>
  <SearchBar v-model:show="showSearchBar" />
</template>
<style lang="scss" scoped>
.header-nav {
  display: flex;
  justify-content: flex-end;
  position: fixed;
  top: 2vh;
  right: 1vw;
  z-index: 99;
  user-select: none;
  .nav {
    display: flex;
    align-items: center;
    background: transparent;
    transition: 0.3s;
    box-sizing: border-box;
    border-radius: 0.2rem;
    overflow: hidden;
    .item {
      flex-grow: 1;
      // font-size: 0.8rem;
      padding: 0.2rem;
      box-sizing: border-box;
      cursor: pointer;
      color: black;
      font-weight: 500;
      padding: 0.5rem 0.8rem;
      display: flex;
      align-items: center;
      mix-blend-mode: difference;
      transition: 0.3s;
      &:hover {
        filter: invert(1);
      }

      &:active {
        opacity: 1;
        transform: scale(0.9);
      }
    }
  }
}
</style>
