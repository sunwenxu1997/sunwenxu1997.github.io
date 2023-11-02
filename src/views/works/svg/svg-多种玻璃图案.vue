<script>
export default {
    cover:'https://iili.io/JqJO5JV.png'
}
</script>
<script setup>
/**
 * https://www.zhangxinxu.com/wordpress/2020/10/svg-feturbulence/
 * baseFrequency 表示噪声的基本频率参数，默认值是0，频率越高，噪声越密集
 * numOctaves 属性numOctaves就表示倍频的数量，默认值是1，不能是小数，只能是整数，如果是小数会当作默认值1处理。
 */
/**
 * https://www.zhangxinxu.com/wordpress/2017/12/understand-svg-fedisplacementmap-filter/
 * 深入理解SVG feDisplacementMap滤镜及实际应用
 */
</script>
<template>
    <div class="app-content">
        <div class="item" v-for="item in 8" :key="item">
            <img :src="`https://picsum.photos/1920/1080`" alt="" />
            <div class="glass"></div>
        </div>
    </div>
    <svg style="display: none">
        <defs>
            <filter id="image1">
                <feImage result="pict1" xlink:href="/images/displacement/1.jpg" x="0" y="0" width="527" height="336">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict1" in="SourceGraphic">
                </feDisplacementMap>
                <!-- <feComposite operator="in" in2="pict2"></feComposite> -->
            </filter>
        </defs>
        <defs>
            <filter id="image2">
                <feImage result="pict2" xlink:href="/images/displacement/2.jpg" x="0" y="0" width="527" height="336">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict2" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image3">
                <feImage result="pict7" xlink:href="/images/displacement/7.jpg" x="0" y="0" width="523" height="330">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict7" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image4">
                <feImage result="pict4" xlink:href="/images/displacement/4.jpg" x="0" y="0" width="1000" height="1000"/>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict4" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image5">
                <feImage result="pict7" xlink:href="/images/displacement/10.jpg"  x="0" y="0" width="517" height="517">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict7" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image6">
                <feImage result="pict7" xlink:href="/images/displacement/14.jpg" x="0" y="0" width="500" height="500">
                </feImage>
                <feDisplacementMap scale="20" xChannelSelector="R" yChannelSelector="R" in2="pict7" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image7">
                <feImage result="pict13" xlink:href="/images/displacement/13.jpg" x="0" y="0" width="603" height="582">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict13" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
        <defs>
            <filter id="image8">
                <feImage result="pict7" xlink:href="/images/displacement/16.jpg" x="0" y="0" width="510" height="502">
                </feImage>
                <feDisplacementMap scale="30" xChannelSelector="R" yChannelSelector="R" in2="pict7" in="SourceGraphic">
                </feDisplacementMap>
            </filter>
        </defs>
    </svg>
</template>
<style scoped lang="scss">
.app-content {
    width: 100vw;
    display: grid;
    grid-template-columns: repeat(auto-fit, 50vmax);
    justify-content: center;
    background-color: white;
}

.item {
    position: relative;
    clip-path: inset(3rem);
}

.item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    position: relative;
    z-index: 1;
}

.item .glass {
    transition: 0.5s;
    width: 50%;
    height: 50%;
    position: absolute;
    top: 25%;
    left: 25%;
    z-index: 2;
    overflow: hidden;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
    //   玻璃模糊度和蒙层效果
    // backdrop-filter: blur(2px) url(#image1);
}
.item:nth-child(1) .glass {
    //   玻璃模糊度和蒙层效果
    -webkit-backdrop-filter:blur(2px) url(#image1);
    backdrop-filter: blur(2px) url(#image1);
}
.item:nth-child(2) .glass {
    //   玻璃模糊度和蒙层效果
    backdrop-filter: blur(2px) url(#image2);
}
.item:nth-child(3) .glass {
    //   玻璃模糊度和蒙层效果
    backdrop-filter: blur(2px) url(#image3);
}
.item:nth-child(4) .glass {
    //   玻璃模糊度和蒙层效果
    backdrop-filter: blur(2px) url(#image4);

}
.item:nth-child(5) .glass {
    backdrop-filter: blur(2px) url(#image5);
}
.item:nth-child(6) .glass {
    backdrop-filter: blur(2px) url(#image6);
}
.item:nth-child(7) .glass {
    backdrop-filter: blur(2px) url(#image7);
}
.item:nth-child(8) .glass {
    backdrop-filter: blur(2px) url(#image8);
}
</style>
