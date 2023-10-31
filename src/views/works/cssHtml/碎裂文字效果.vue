<template>
    <div class="overall">
        <h1 data-text="black mirror">
            <span>black mirror</span>
        </h1>
    </div>
</template>

<script>
/**
 * 知识点：
 * clip-path 路径剪切
 * content: attr(data-text); 文本属性引用
 */
export default {
    cover:'https://i.imgur.com/pdhxnTf.png'
}
</script>

<style lang="scss" scoped>
.overall {
    width: 100%;
    height: 100%;
    position: absolute;
    display: flex;
    align-items: center;
    justify-content: center;
    background: black;
}

h1 {
    position: relative;
    font-family: "Montserrat", Arial, sans-serif;
    font-weight: 700;
    font-size: 10vmin;
    color: #fff;
    letter-spacing: 0.02em; //文字间距
    text-transform: uppercase; //转大写
    text-shadow: 0 0 0.15em #1da9cc;
    user-select: none; //文字不能被选择
    white-space: nowrap; //不换行
    filter: blur(0.007em); //模糊度
}

h1:hover {
    transform: translate(0) rotate(-0.5deg);
}

h1:hover::before {
    transform: translate(-20px, -2px);
}

h1:hover::after {
    transform: translate(10px, 0px);
}

h1 span {
    clip-path: polygon(10% 0%,
            44% 0%,
            70% 100%,
            55% 100%); //点1，点2，点3，点4；依次连接这些点，圈起来的部分就为裁剪的部分
}

h1::before,
h1::after {
    content: attr(data-text);
    position: absolute;
    top: 0;
    left: 0;
    z-index: -1;
}

h1::before {
    clip-path: polygon(0% 0%, 10% 0%, 55% 100%, 0% 100%);
}

h1::after {
    clip-path: polygon(44% 0%, 100% 0%, 100% 100%, 70% 100%);
}</style>