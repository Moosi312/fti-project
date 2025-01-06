<template>
    <block v-if='relevantTopics.length > 0' type="area" header="Betroffene Bereiche">
        <topic-entry-in-out v-for="([topic, io]) in relevantTopics" :key='topic.id' :topic='topic' :in-out="io"/>
    </block>
</template>

<script>
import Block from './Base.vue';
import TopicEntryInOut from "./shared/TopicEntryInOut.vue";

export default {
    props: ['indicatorId'],
    components: {
      TopicEntryInOut, Block,
    },
    computed: {
      relevantTopics: function () { return this.$store.getters.topicsForIndicator(this.indicatorId).map(topic => [topic, this.$store.getters.getInOutForTopicIndicator(topic, this.indicatorId)]) ; },
    },
}
</script>
