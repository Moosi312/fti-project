<template>
    <block v-if='topics.length > 0' type="area" header="Betroffene Bereiche">
        <topic-entry v-for="topic in topics" :key='topic.id' :topic='topic'/>
    </block>
</template>

<script>
import Block from './Base.vue';
import TopicEntry from './shared/TopicEntry.vue';

export default {
    props: ['target'],
    components: {
        Block, TopicEntry,
    },
    computed: {
        topics: function() { return this.target.topics.map(id => this.$store.getters.topic(id)); }
    },
}
</script>
