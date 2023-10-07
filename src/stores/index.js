import { ref, reactive, computed } from 'vue'
import { defineStore } from 'pinia'

const useAppStore = defineStore('app', () => {
    const rdmRouteIndexArr = reactive([])//随机路由下标集合

    /**
     * 根据路由文件生成一个随机的路由地址
     * @param {array} routes 
     * @returns 
     */
    function createRandomRoute(routes) {
        // 过滤掉hidden为true的路由,因为这些路由不需要随机展示出来
        routes.filter(item => !item.meta.hidden)
        // 如果都随机过了，那么就清空重新随机
        if (rdmRouteIndexArr.length == routes.length) {
            rdmRouteIndexArr.length = 0
            console.log('--重新随机');
        }
        // 生成的同时需要记录下标，防止下次再随机到
        let index = ~~(Math.random() * routes.length)
        while (rdmRouteIndexArr.includes(index)) {
            index = ~~(Math.random() * routes.length)
        }
        rdmRouteIndexArr.push(index)
        return routes[index]
    }
    function setRdmRouteIndexArr(index) {
        rdmRouteIndexArr.push(index)
    }
    // const count = ref(0)
    // const doubleCount = computed(() => count.value * 2)
    // function increment() {
    //     count.value++
    // }

    return { rdmRouteIndexArr, setRdmRouteIndexArr, createRandomRoute }
})

export { useAppStore }