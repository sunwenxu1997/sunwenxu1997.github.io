<template>
    <div class="app">
        <img width="600" height="400" src="https://picsum.photos/600/400?random=1" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=2" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=3" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=4" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=5" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=6" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=7" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=8" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=9" alt="" class="skewElem" />
        <img width="600" height="400" src="https://picsum.photos/600/400?random=10" alt="" class="skewElem" />
    </div>
</template>

<script>
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger.js";
export default {
    name: 'scrollTrigger-倾斜滚动特效',
    mounted() {
        gsap.registerPlugin(ScrollTrigger);
        let proxy = { skew: 0 }; //定义一个初始化的对象数据，每次滚动时都会由此对象执行动画操作
        let skewSetter = gsap.quickSetter(".skewElem", "skewY", "deg"); //应用到 .skewElem的skewY 并添加一个 deg单位的数值
        let clamp = gsap.utils.clamp(-20, 20); // 不要让斜度超过20度。
        ScrollTrigger.create({
            onUpdate: (self) => {
                let skew = clamp(self.getVelocity() / 800);
                // console.log(self.getVelocity()) //滚动速率
                //只有在倾斜更严重的情况下才采取措施。记住，我们总是将补间调整回0，所以如果用户快速放慢滚动速度，我们便会更自然地让补间平滑处理而不是跳到更小的倾斜。
                // console.log(proxy.skew);
                if (Math.abs(skew) > Math.abs(proxy.skew)) {
                    proxy.skew = skew;
                    // console.log(proxy);
                    gsap.to(proxy, {
                        skew: 0,
                        duration: 0.8,
                        ease: "power3",
                        overwrite: true,
                        onUpdate: () => {
                            skewSetter(proxy.skew);
                        },
                    });
                }
            },
        });
    },
};
</script>

<style lang="scss" scoped>
.app {
    text-align: center;
}

.skewElem {
    margin: 10px 0;
}
</style>