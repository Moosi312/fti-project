<template>
  <div>
    <router-link :to="{ name: 'indicator', params: { indicatorId: indicator }}">
      <h3 class="indicator-name">{{ $store.getters.getShortname(indicator) }}</h3>
    </router-link>
    <div>
      <p class="description">{{ $store.getters.getLabels(indicator).name_a }}</p>

      <div class="topics-container">
        <div class="ind-bar">
          <bar-indicator :indicator="indicator" :options="options" />
        </div>
        <h4 class="affected-topics">Betroffene Bereiche</h4>
        <div class="topic-row">
          <div class="topic-entry" v-for="([topic, io]) in relevantTopics" :key="topic.id">
            <topic-entry-in-out :topic="topic" :in-out="io" />
          </div>
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

<style scoped>
.indicator-name {
  font-size: 16pt;
  font-weight: 600;
}

.description {
  color: #707070;
  font-size: 12pt;
}

.topics-container {
  display: flex;
  flex-direction: column;
  gap: 5px;
  padding: 0;
  margin-top: -5%;
}

.topic-row {
  display: flex;
  flex-wrap: wrap;
  margin-left: -10px;
}

.topic-entry {
  flex: 0 1 auto;
}

.affected-topics
{
  margin-top: -10%;
}
</style>
