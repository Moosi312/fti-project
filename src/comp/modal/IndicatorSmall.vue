<template>
  <div class='indicator'>
    <div ref='indicatorSmall'>
      <div v-if="indicator">
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
        <div v-if="relevantTopics.length > 0" class="d-flex flex-column">
          <strong>Weitere Betroffene Bereiche</strong>
          <div class="mx-4">
            <topic-entry-in-out v-for="([topic, io]) in relevantTopics" :key='topic.id' :topic='topic' :in-out="io"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import LinesSvg from "../svg/Lines.vue";
import TopicControls from "../TopicControls.vue";
import TopicsBlock from '../block/TopicsIndicator.vue';
import DocumentsBlock from "../block/Documents.vue";
import TopicEntryInOut from "../block/shared/TopicEntryInOut.vue";

export default {
  props: ['indicatorId', 'topic'],
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
    TopicEntryInOut,
    DocumentsBlock,
    TopicControls,
    LinesSvg,
    TopicsBlock
  },
  computed: {
    docs: function () { return this.$store.getters.docsForIndicator(this.indicatorId); },
    indicator: function () {return this.$store.getters.getLabels(this.indicatorId); },
    relevantTopics: function () {
        return this.$store.getters.topicsForIndicator(this.indicatorId)
            .filter(topic => this.topic.id !== topic)
            .map(topic => [topic, this.$store.getters.getInOutForTopicIndicator(topic, this.indicatorId)]);
      },
  },
  methods: {
    updateWidth() {
      if (this.$refs.indicatorSmall && this.$refs.indicatorSmall.clientWidth) {
        this.width = this.$refs.indicatorSmall.clientWidth;
        this.testId += 1;
      }
    }
  },
  mounted() {
    this.resizeObserver = new ResizeObserver(() => this.updateWidth());
    this.resizeObserver.observe(this.$refs.indicatorSmall);
    this.width = 800
  },
}
</script>
