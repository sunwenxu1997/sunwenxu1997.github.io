<template>
    <div class="app-content-center" @click="authAudio">
        <audio id="audio" autoplay>
            <source src="//img-qn.51miz.com/preview/sound/00/27/24/51miz-S272417-CA7CCC67.mp3" type="audio/mpeg" />
        </audio>
        <div class="button-box-shadow" v-for="item in 5" @mouseenter="handleMouseenter" :key="item"
            style="margin-bottom: 20px;">
            🎵BUTTON{{ item }}
        </div>
    </div>
</template>

<script>
// import Vue 不是必须的，需要手动指定 Vue 的版本时，可以解开注释
// import Vue from 'vue';

export default {
    data() {
        return {
            count: 0,
        };
    },
    methods: {
        //鼠标移入
        handleMouseenter(e) {
            console.log(e);
            this.playAudio();
        },
        //谷歌浏览器需要用户首次点击授权后才可以播放声音
        authAudio() {
            let audioEl = document.querySelector("#audio");
            audioEl.load();
        },
        playAudio() {
            let audioEl = document.querySelector("#audio");
            audioEl.load();
            audioEl.play();
        },
    },
};
</script>

<style lang="scss" scoped>
.button-box-shadow {
    padding: 10px 20px;
    box-sizing: border-box;
    border-radius: 10px;
    background-color: white;
    box-shadow: 3px 3px 5px #ccc;
    font-size: 13px;
    color: #5a5a5a;
    transition: 0.3;
    cursor: pointer;

    &:hover {
        background: #409eff;
        color: white;
        box-shadow: 0 0 3px #ccc;
    }
}
</style>