<template>
    <div class="app-content-center">
        <div class="body">
            <SliderPlan v-model:planNum="plan" :color="['#D6FF7F', '#00B3CC']"></SliderPlan>
            <SliderPlan v-model:planNum="plan1" :color="['#ED7B84', '#9055FF']"></SliderPlan>
            <SliderPlan v-model:planNum="plan2" :color="['#2F80ED']"></SliderPlan>
            <SliderPlan v-model:planNum="plan3"></SliderPlan>
        </div>
    </div>
</template>

<script>
import SliderPlan from "@/components/SliderPlan/index.vue";
export default {
    components: {
        SliderPlan,
    },
    data() {
        return {
            plan: 75,
            plan1: 45,
            plan2: 100,
            plan3: 88,
        };
    },
    methods: {},
};
</script>

<style lang="scss" scoped>
</style>