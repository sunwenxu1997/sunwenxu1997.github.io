<script setup>
import { ref, reactive, onMounted } from 'vue'
onMounted(() => {})
</script>
<template>
 <div class="sm:max-w-screen-lg sm:m-auto">
    <div class="pt-28 px-12 text-stone-800 text-xs tracking-widest sm:px-60">
    <p>
      日常划水积累的小项目，包含
      <span class="font-bold underline text-sm">css</span>、
      <span class="font-bold underline text-sm">html</span>、
      <span class="font-bold underline text-sm">js</span>、
      <span class="font-bold underline text-sm">vue</span>、
      <span class="font-bold underline text-sm">gsap</span>、
      <span class="font-bold underline text-sm">threejs</span>、
      <span class="font-bold underline text-sm">tailwindcss</span>等。
    </p>
    <p>大多是以动画效果形式展示，方便有效理解和提起我的兴趣。偶尔我自己也会翻着看🤣</p>
    <p>
      自己也有写相关的文章，主要在平台
      <a class="text-sm text-stone-800 font-bold" href="https://juejin.cn/user/1011206430666551"
        >掘金</a
      >、
      <a class="text-sm text-stone-800 font-bold" href="https://www.jianshu.com/u/5294c349f0f1"
        >简书(弃用)</a
      >都有记录，你也可以通过
      <a class="text-sm text-stone-800 font-bold" href="https://github.com/sunwenxu1997">Github</a
      >找到我， 欢迎交流👾。
    </p>
  </div>
  <div class="px-4 py-12 sm:px-60" v-for="(item,index) in 10" :key="index">
    <div class="w-full aspect-video">
      <img class="w-full h-full object-cover" :src="`https://picsum.photos/2500/1667?random=${index}`" alt="" />
    </div>
    <div class="px-8 sm:px-0">
      <div class="py-6 flex justify-between">
        <div class="uppercase text-stone-800 text-sm font-bold">information</div>
      </div>
      <p class=" m-0 text-xs text-stone-600 tracking-widest leading-7">
        AI-OCRやNLP(自然言語処理技術)等の先進的なAI技術を強みとし、転記業務を⾼速・⾃動化するプロダクト・サービスを開発する「株式会社インフォディオ」のWebサイトをリニューアルいたしました。「AIを駆使した先進的なプロダクト開発を行う自社の正しい姿を伝えられおらず、求人者とのミスマッチが起きてしまっている。」という問題を抱えられていたことから、リニューアル後のデザインではプロダクトを中心としたイメージを提案し、インフォディオらしい堅牢かつ先進的なデジタル感を強く押し出したビジュアルで構成いたしました。ビジュアルと共にサイト全体のコンテンツを整理することで、インフォディオの正しい姿をより魅力的に伝えることのできるWebサイトとなりました。
      </p>
    </div>
  </div>
 </div>
</template>
<style lang="scss" scoped></style>
