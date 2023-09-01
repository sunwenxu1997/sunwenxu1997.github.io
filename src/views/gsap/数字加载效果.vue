<script>
export default {
  articleLink: 'https://juejin.cn/post/7273680035096494099'
}
</script>
<script setup>
import { gsap } from 'gsap'
import { ref, onMounted } from 'vue'
const number = ref(0)
const number2 = ref(0)
const number3 = ref(0)

onMounted(() => {
  loadNumber(1000)
  loadNumber2(2000.1)
  loadNumber3(3000.12)
})
//  加载数字方法 方式1：
// 通过动态更新proxy.value的值，来实现数字的加载效果
const loadNumber = (value) => {
  const proxy = { value: 0 }
  gsap.to(proxy, {
    duration: 2,
    ease: 'power2.out',
    value: value,
    onUpdate: () => {
      // 向上取整，会改变原始传入值
      number.value = Math.ceil(proxy.value)
    },
    onComplete: () => {
      // 改变了number.value的值
      console.log(number.value)
    }
  })
}

// 加载数字方法 方式2：
// 通过获取dom元素，控制innerHTML属性，来实现数字的加载效果
const loadNumber2 = (value) => {
  // 获取要改变的dom元素
  const proxy = document.querySelector('.number-text-2')
  gsap.to(proxy, {
    duration: 2,
    ease: 'power2.out',
    innerHTML: value,
    onUpdate: () => {
      // 保留一位小数
      proxy.innerHTML = Math.ceil(proxy.innerHTML * 10) / 10
    },
    onComplete: () => {
      // 没有改变number2.value的值
      console.log(number2.value)
    }
  })
}

const loadNumber3 = (value) => {
  const proxy = { value: 0 }
  gsap.to(proxy, {
    duration: 2,
    ease: 'power2.out',
    value: value,
    onUpdate: () => {
      number3.value = Math.ceil(proxy.value * 100) / 100
    },
    onComplete: () => {
      // 改变了number3.value的值
      console.log(number3.value)
    }
  })
}
//每三位逗号隔开,后面补两位小数，多用于金额数字
const floatThree = (value) => {
  value = '' + value
  if (!value) return '0.00'
  var intPart = parseInt(Number(value)) //获取整数部分
  var intPartFormat = intPart.toString().replace(/(\d)(?=(?:\d{3})+$)/g, '$1,') //将整数部分逢三一断
  var floatPart = '.00' //预定义小数部分
  var value2Array = value.split('.')
  //=2表示数据有小数位
  if (value2Array.length == 2) {
    floatPart = value2Array[1].toString() //拿到小数部分
    // console.log('floatPart',floatPart)
    if (floatPart.length == 1) {
      //补0,实际上用不着
      return intPartFormat + '.' + floatPart + '0'
    } else {
      return intPartFormat + '.' + floatPart
    }
  } else {
    return intPartFormat + floatPart
  }
}
</script>
<template>
  <div class="app-content-center">
    <div class="number-text">{{ number }}</div>
    <div class="number-text-2">{{ number2 }}</div>
    <div class="number-text">{{ floatThree(number3) }}</div>
  </div>
</template>
<style scoped>
.app-content-center {
  overflow: hidden;
  font-size: 20vh;
  font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
  font-weight: 800;
}
</style>
