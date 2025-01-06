<template>
  <div class='indicator'>
    <header-str :cols="4" v-if="!modal">
      <template v-slot:right>
        <header-right-str :title="$store.getters.getShortname(indicatorId)" subtitle='Detailansicht Indikator' icon='icon_FTISystem2'/>
        <topic-controls style="text-align: right; margin-bottom: 5px;" :controlStatus='controlStatus' :topic='fakeTopic' @change="t => controlStatus = t"/>
      </template>
    </header-str>
    <div class="row g-3">
      <div class="col-xl-4 col-lg-5 col-md-12">
        <topics-block :indicator-id="indicatorId"/>
        <documents-block v-for="(header, type) in documentBlocks" :key="type" v-if="docs[type]" :input-docs='docs[type]' :type='type' :header='header' :preview-count="3" :preview-use-count="4"/>
      </div>
      <div v-if="indicator" class="col-xl-8 col-lg-7 col-md-12 order-first order-lg-last">
        <p>
          <strong>{{ indicator.short }}</strong><br/>
          <span class="name">{{ indicator.unit ? indicator.unit : indicator.unit_short }}</span>
        </p>
        <p>
          <span class="text">{{ indicator.text }}</span>
        </p>
        <lines-svg :id="indicatorId" :width="width" :topic="fakeTopic" :settings="controlStatus"></lines-svg>
        <p>
          <strong>Quelle: </strong><span class="source">{{ indicator.source }}</span><br/>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import DocumentsBlock from './block/Documents.vue';
import HeaderRightStr from "./str/HeaderRight.vue";
import HeaderStr from "./str/Header.vue";
import LinesSvg from "./svg/Lines.vue";
import TopicControls from "./TopicControls.vue";
import TopicsBlock from './block/TopicsIndicator.vue';

export default {
  props: ['indicatorId', 'modal'],
  data() {
    return {
      documentBlocks: {
        'r': 'Ratsempfehlungen',
        'c': 'Stellungnahmen',
        's': 'Auftragsstudien',
      },
      width: undefined,
      fakeTopic: {comp: ['inno', 'top3', 'eu']},
      controlStatus: {
        compGroup: 'inno',
        compTime: "0",
      },
      testId: 0,
    };
  },
  components: {
    TopicControls,
    LinesSvg,
    HeaderRightStr, HeaderStr, DocumentsBlock, TopicsBlock
  },
  computed: {
    docs: function () { return this.$store.getters.docsForIndicator(this.indicatorId); },
    indicator: function () {return this.$store.getters.getLabels(this.indicatorId); },
  },
  methods: {
    updateWidth() {
      if (this.$refs.system) {
        console.log(this.$refs.system);
        this.width = this.$refs.system.clientWidth;
        this.testId += 1;
      }
    }
  },
  mounted() {
    // TODO: this.$refs is empty???
    // this.width = this.$refs.system.clientWidth;
    this.width = 800
    window.addEventListener('resize', this.updateWidth)
  },
}
</script>

<style>
.compare-content {
  margin-left: 5%;
  padding-top: 20px;
  height: 100%;
}
</style>
