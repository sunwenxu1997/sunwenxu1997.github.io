<script setup >
import IconRefresh from './icons/IconRefresh.vue'
import IconGithub from './icons/IconGithub.vue'
import IconLink from './icons/IconLink.vue'
import { onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import routes from '../router/routes'
import { createRandomRoute } from "../utils/index";
onMounted(() => {
})
const $router = useRouter()
const $route = useRoute()
const changeOther = () => {
    $router.push(createRandomRoute(routes).path)
}
const toGithubLink = () => {
    window.open($route.meta.githubCode, '_blank')
}
const toArticleLink = () => {
    console.log(routes);
    let link = $route.meta.articleLink
    if (!link) {
        alert('🐔作者还没写~')
        return
    }
    window.open(link, '_blank')
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
        </div>
    </div>
</template>
<style lang="scss" scoped>
.header-nav {
    width: 100vw;
    display: flex;
    justify-content: center;
    position: fixed;
    top: 2vh;
    left: 0;
    z-index: 99;
    user-select: none;

    .nav {
        display: flex;
        align-items: center;
        // grid-template-columns: repeat(auto, 1fr);
        // grid-gap: 2rem;
        background: transparent;
        transition: 0.3s;
        box-sizing: border-box;
        border-radius: 0.2rem;
        overflow: hidden;

        &:hover {
            background: white;
            box-shadow: 2px 2px 10px #c5c5c5;
        }

        .item {
            flex-grow: 1;
            // font-size: 0.8rem;
            padding: 0.2rem;
            box-sizing: border-box;
            cursor: pointer;
            opacity: 0.7;
            color: #3b3b3b;
            font-weight: 500;
            padding: 0.5rem 0.8rem;
            display: flex;
            align-items: center;

            &:hover {
                opacity: 1;
            }

            &:active {
                opacity: 1;
                transform: scale(0.9);
            }
        }
    }
}
</style>