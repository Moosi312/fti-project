<template>
  <router-link :to="{name: 'indicator', params: {indicatorId: indicator}}">
    <h3 v-if="indicator" class="indicator-name">{{ $store.getters.getShortname(indicator) }}</h3>
    <p v-else>No indicator selected.</p>
    <p class="description">{{ $store.getters.getLabels(indicator).name_a }}</p>
    <p class="description">{{ $store.getters.value(indicator) }}</p>
    
    <topic-entry-in-out v-for="([topic, io]) in relevantTopics" :key='topic.id' :topic='topic' :in-out="io"/>
  </router-link>
</template>

<script>
import BarIndicator from './BarIndicator.vue';
import TopicsBlock from '../block/TopicsIndicator.vue'
import TopicEntryInOut from '../block/shared/TopicEntryInOut.vue';
import Block from '../block/Base.vue'

export default {
  props: ['indicator'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: { BarIndicator, TopicsBlock, TopicEntryInOut, Block,
  },
  computed: {
      relevantTopics: function () { return this.$store.getters.topicsForIndicator(this.indicator).map(topic => [topic, this.$store.getters.getInOutForTopicIndicator(topic, this.indicator)]) ; },
    },
  mounted() {
  },
  methods: {
  },
};
</script>

<style scoped>

.indicator-name{
  font-weight: 600;
}

.description{
  color: #707070;
  font-size: 12pt;
}

</style>
