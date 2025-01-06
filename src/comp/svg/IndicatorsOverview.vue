<template>
  <router-link :to="{ name: 'indicator', params: { indicatorId: indicator }}">
    <h3 v-if="indicator" class="indicator-name">{{ $store.getters.getShortname(indicator) }}</h3>
    <p v-else>No indicator selected.</p>
    <p class="description">{{ $store.getters.getLabels(indicator).name_a }}</p>

    <div class="topics-container">
      <div
        class="topic-row">
        <div class="topic-entry" v-for="([topic, io]) in relevantTopics" :key="topic.id">
          <topic-entry-in-out :topic="topic" :in-out="io" />
        </div>
      </div>
      <div class="ind-bar">
        <bar-indicator :indicator="indicator" :options="options"/>
      </div>
    </div>
  </router-link>
</template>

<script>
import BarIndicator from './BarIndicator.vue';
import TopicsBlock from '../block/TopicsIndicator.vue';
import TopicEntryInOut from '../block/shared/TopicEntryInOut.vue';
import Block from '../block/Base.vue';

export default {
  props: ['indicator', 'options'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: {
    BarIndicator,
    TopicsBlock,
    TopicEntryInOut,
    Block,
  },
  computed: {
    relevantTopics: function () {
      return this.$store
        .getters.topicsForIndicator(this.indicator)
        .map(topic => [
          topic,
          this.$store.getters.getInOutForTopicIndicator(topic, this.indicator),
        ]);
    },
  },
  mounted() {},
  methods: {},
};
</script>

<style scoped>
.indicator-name {
  font-weight: 600;
}

.description {
  color: #707070;
  font-size: 12pt;
}

.topics-container {
  display: grid;
  grid-template-columns: 1fr 3fr;
  grid-gap: 15px;
  padding: 0;
}

.topic-row {
  display: flex;
  flex-direction: column;
}
</style>
