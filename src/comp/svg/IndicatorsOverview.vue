<template>
  <div class="indicators-overview">
    <div class="name-description">
    <router-link :to="{ name: 'indicator', params: { indicatorId: indicator }}">
      <h4 class="block-header">{{ $store.getters.getShortname(indicator) }} ↗</h4>
    </router-link>
      <p>{{ $store.getters.getLabels(indicator).name_a }}</p>
    </div>
      <div class="topics-container">
        <div class="ind-bar">
          <bar-indicator :indicator="indicator" :options="options" />
        </div>
        <h4 class="block-header">Betroffene Bereiche</h4>
        <div class="topic-row">
          <div class="topic-entry" v-for="([topic, io]) in relevantTopics" :key="topic.id">
            <topic-entry-in-out :topic="topic" :in-out="io" />
          </div>
        </div>
      </div>
  </div>
</template>

<script>
import BarIndicator from './BarIndicator.vue';
import TopicEntryInOut from '../block/shared/TopicEntryInOut.vue';

export default {
  props: ['indicator', 'options'],
  computed: {
    relevantTopics() {
      return this.$store
        .getters.topicsForIndicator(this.indicator)
        .map(topic => [
          topic,
          this.$store.getters.getInOutForTopicIndicator(topic, this.indicator),
        ]);
    },
  },
  components: {
    BarIndicator,
    TopicEntryInOut,
  },
};
</script>
