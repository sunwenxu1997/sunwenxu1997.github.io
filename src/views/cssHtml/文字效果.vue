<script>
export default {
    articleLink: 'https://juejin.cn/post/7165675529763454983',
}
</script>
<template>
    <div class="text-box">
        <h1>Hello World</h1>
        <h1>Hello World</h1>
        <h1>Hello World</h1>
        <h1>Hello World</h1>
        <h1>Hello World</h1>
        <h1>Hello World</h1>
        <h1>Hello World</h1>
    </div>
</template>
<style scoped>
.text-box {
    display: grid;
    grid-template-columns: repeat(1, auto);
    grid-gap: 3vh;
    margin-top: 7vh;
    text-align: center;
}

h1 {
    font-size: 3rem;
}

h1:nth-child(1) {
    -webkit-box-reflect: below -0.55em linear-gradient(transparent 0%, rgba(255, 255, 255, .6) 100%);
}

h1:nth-child(2) {
    /* 文字描边 width color */
    -webkit-text-stroke: 0.05rem black;
    color: transparent;
    text-shadow: -5px 0 rgba(0, 255, 255, 0.4), 5px 0 rgba(255, 0, 255, 0.4);
}

h1:nth-child(3) {
    text-decoration: line-through;
}

h1:nth-child(4) {
    color: #f4f4f4;
    text-shadow: -1px -1px white, 1px 1px gray, 2px 2px #7a7a7a, 3px 3px #757575, 4px 4px #707070, 5px 5px #6b6b6b, 6px 6px #666666, 7px 7px #616161, 8px 8px #5c5c5c, 9px 9px #575757;
}

h1:nth-child(5) {
    color: transparent;
    background-image: linear-gradient(transparent 0%, transparent 50%, #447df7 50%, #447df7 100%);
    -webkit-background-clip: text;
    -webkit-text-stroke: 0.05rem #447df7;
}

h1:nth-child(6) {
    color: transparent;
    text-shadow: 0 0 5px black;
}

h1:nth-child(7) {
    /* 文字间距 */
    letter-spacing: .3rem;
    text-shadow: 1px 1px 0px white, 3px 3px 0px black;
}
</style>