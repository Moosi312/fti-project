<template>
    <div class='target'>
        <div>
            <h4>{{ target.name }}</h4>
            <h5>{{ target.parentNameShort ? target.parentNameShort : target.parentName }}</h5>
        </div>
        <div class="row g-3 content">
            <div class="offset-xl-2 col-xl-8">
                <pie-chart-block :key='`pie-chart-block-${testId}`' :target='target'/>
                <line-chart-block :key='`line-chart-block-${testId}`' :target='target'/>
                <text-block v-if="!$store.getters.isDev" name="Analyse" :file='`Z ${target.id.replace(/\./g, "-")}`' fallback='Z default'/>
            </div>
        </div>
    </div>
</template>

<script>

import TopicsBlock from './block/Topics2.vue';
// import RecommendationsBlock from './block/Recommendations.vue';
// import StudiesBlock from './block/Studies.vue';
import PieChartBlock from './block/PieChart.vue';
import LineChartBlock from './block/LineChart.vue';

import TextBlock from './block/Text.vue';
import DocumentsBlock from './block/Documents.vue';

import HeaderRightStr from './str/HeaderRight.vue';
import HeaderStr from './str/Header.vue';

export default {
    props: ['target'],
    data: () => ({
        testId: 0,
    }),
    components: {
        TopicsBlock, HeaderRightStr, HeaderStr, TextBlock,
        PieChartBlock, LineChartBlock, DocumentsBlock
    },
    created() {
        // window.addEventListener('keydown', this.escListener);
        window.addEventListener('resize', () => {
            // this.width = this.$refs.system.clientWidth
            this.testId += 1;
        })
    },
    // beforeDestroy() {
    //     window.removeEventListener('keydown', this.escListener)
    // },
    // methods: {
    //     escListener(evt) {
    //         if (evt.keyCode === 27) {
    //             this.$router.push({name: 'overview'})
    //         }
    //     }
    // }
}
</script>
