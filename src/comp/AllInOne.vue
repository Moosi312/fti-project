<template>
    <div class='all-in-one'>
        <header-str :cols="4">
            <template v-slot:right>
                <header-right-str title='FTI-Monitor' subtitle='Druckansicht' icon='icon_FTISystem2'/>
            </template>
        </header-str>
        <div class="d-none d-print-block" style="height: 50px;"></div>
        <div>
            <h4>FTI-System</h4>
            <h5>System</h5>
        </div>
        <Overview view="system" :type='`print`'/>
        <div style="page-break-after: always;"></div>
        <div>
            <h4>FTI-System</h4>
            <h5>Vergleich Vorjahr</h5>
        </div>
        <Overview view="bar" :type='`print`'/>
        <div style="page-break-after: always;"></div>
        <template v-for="topic in $store.getters.topics">
            <TopicPrint :topic='topic'/>
            <div style="page-break-after: always;"></div>
        </template>
        <template v-for="g in ['fti', 'klw']">
            <template v-for="tp in $store.getters.targets('fti')">
                <template v-for="tc in tp.children.map(i => $store.getters.target(`${tp.nr}.${i.nr}`))">
                    <TargetPrint :target='tc'/>
                    <div style="page-break-after: always;"></div>
                </template>
            </template>
        </template>
    </div>
</template>

<script>
import Overview from './Overview.vue';
import TopicPrint from './TopicPrint.vue';
import TargetPrint from './TargetPrint.vue';
import HeaderStr from './str/Header.vue';
import HeaderRightStr from './str/HeaderRight.vue'


export default {
    props: ['view'],
    data: () => ({
        width: null,
        testId: 0,
    }),
    components: {
        Overview, TopicPrint, TargetPrint, HeaderStr, HeaderRightStr
    },
    methods: {
        updateWidth() {
            if (this.$refs.system) {
                this.width = this.$refs.system.clientWidth
                this.testId += 1;
            }
        }
    },
    mounted() {
        this.width = this.$refs.system.clientWidth
        window.addEventListener('resize', this.updateWidth)
    },
    // beforeUnmount() {
    //     console.log('unmounted')
    //     window.removeEventListener('resize', this.updateWidth)
    // }
}
</script>
