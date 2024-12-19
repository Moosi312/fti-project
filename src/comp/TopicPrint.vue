<template>
    <div class='topic'>
        <div>
            <h4>{{ topic.name }}</h4>
            <h5>{{ topic.area.name }}</h5>
        </div>
        <div class="row g-3">
            <div class="offset-xl-2 col-xl-8">
            </div>
            <div class="offset-xl-2 col-xl-8">
                <div class='row'>
                    <div class="col-12">
                        <!-- <single-chart-block v-if='false && controlStatus.compTime == "0"' :key='`single-chart-block-${testId}`' :settings='controlStatus' :topic='topic'/> -->
                        <single-chart-block :key='`single-chart-block-${testId}`' :compGroup='controlStatus.compGroup' :topic='topic' @modal="showModal"/>
                        <!-- <europe-map-block v-if='false && controlStatus.compTime == "0"' :key='`europe-map-block-${testId}`' :comp='controlStatus.compGroup' :topic='topic'/> -->
                        <europe-map-block :key='`europe-map-block-${testId}`' :comp='controlStatus.compGroup' :topic='topic'/>
                        <bar-chart-block :key='`bar-chart-${testId}`' :settings='controlStatus' :topic='topic' @modal="showModal"/>
                        <div class="row">
                            <div class="col-6">
                                <targets-block type="klw" :topic='topic' :header="$store.getters.targets('klw')[0]['name']"/>
                                <wirkungsziele-block :topic='topic'/>
                            </div>
                            <div class="col-6">
                                <targets-block type="fti" :topic='topic' header="Ziele der FTI-Strategie 2030"/>
                            </div>
                        </div>
                        <template v-if="!$store.getters.isDev">
                            <text-block :key='`text-a-${topic.id}`'name="Analyse" type="a" :file='`${topic.id}`'/>
                            <text-block :key='`text-h-${topic.id}`' name="Handlungsempfehlungen" type="h" :file='`${topic.id} HE`'/>
                        </template>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import Block from './block/Base.vue';
import BarChartBlock from './block/BarChart.vue';
import SingleChartBlock from './block/SingleChart.vue';

import DocumentsBlock from './block/Documents.vue';
import WirkungszieleBlock from './block/Wirkungsziele.vue';
import SdgBlock from './block/Sdg.vue';
import EgdBlock from './block/Egd.vue';
import EctoDashboard from './block/EctoDashboard.vue';
import CritTechBlock from './block/CritTech.vue';

import TextBlock from './block/Text.vue';
import TargetsBlock from './block/Targets.vue';
import AreaBlock from './block/Area.vue';
import EuropeMapBlock from './block/EuropeMap.vue';


// import HeaderLeftStr from './str/HeaderLeft.vue';
import HeaderRightStr from './str/HeaderRight.vue';
import HeaderStr from './str/Header.vue';

import TopicControls from './TopicControls.vue';
import ModalBarInfo from './modal/BarInfo.vue';

export default {
    props: ['topic', 'type'],
    data() {
        // console.log(this.topic.comp[0])
        return {
            controlStatus: {
                compGroup: this.topic.comp[0],
                compTime: "0",
            },
            testId: 0,
            modalId: undefined,
            modalQF: true,
        }
    },
    components: {
        Block, BarChartBlock, SingleChartBlock, TargetsBlock,
        HeaderRightStr, HeaderStr, AreaBlock, TextBlock, EuropeMapBlock,
        DocumentsBlock, WirkungszieleBlock, EctoDashboard,
        TopicControls, SdgBlock, EgdBlock, ModalBarInfo,
        CritTechBlock,
    },
    computed: {
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
    methods: {
        // escListener(evt) {
        //     if (evt.keyCode === 27) {
        //         // console.log('ESC')
        //         this.$router.push({name: 'overview'})
        //     }
        // },
        showModal(d) {
            // console.log(`showModal: ${d}`)
            this.modalId = d;
            this.modalQF = !this.modalQF;
        }
    },
    watch: {
        'topic' () {
            this.controlStatus.compGroup = this.topic.comp[0]
        }
    }
}
</script>
