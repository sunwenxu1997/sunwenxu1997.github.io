<script setup lang="ts">
import { onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
onMounted(() => {
})
const router = useRouter()
const route = useRoute()
const toHome = () => {
    // window.location.reload()
    console.log(route);
    
    router.push(`/`)
}
</script>
<template>
    <div class="header-nav">
        <div class="nav">
            <!-- <div class="item">🧻</div> -->
            <div class="item" @click="toHome">🐔换一个</div>
            <!-- <div class="item">🔗</div> -->
        </div>
    </div>
</template>
<style lang="scss" scoped>
.header-nav {
    width: 100vw;
    display: flex;
    justify-content: center;
    position: fixed;
    top: 5vh;
    left: 0;
    z-index: 99;
    user-select: none;

    .nav {
        display: grid;
        grid-template-columns: repeat(auto, 1fr);
        grid-gap: 2rem;
        background: transparent;
        transition: 0.3s;
        padding: 0.5rem 2rem;
        box-sizing: border-box;
        border-radius: 0.2rem;
        mix-blend-mode: multiply;

        &:hover {
            background: white;
            box-shadow: 2px 2px 10px #c5c5c5;
        }

        .item {
            font-size: 0.8rem;
            padding: 0.2rem;
            box-sizing: border-box;
            cursor: pointer;
            opacity: 0.8;

            &:hover {
                opacity: 1;
                color: #5a5a5a;
            }
        }
    }
}
</style>