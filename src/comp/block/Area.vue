<template>
    <block type="area" :header='`Weitere Bereiche ${topic.area.name}`'>
        <topic-entry v-for="t in topics" :key='t.id' :topic='t'/>
    </block>
</template>

<script>
import Block from './Base.vue';
import TopicEntry from './shared/TopicEntry.vue';

export default {
    props: ['topic'],
    components: {
        Block, TopicEntry,
    },
    computed: {
        topics: function() {
            return this.$store.state.info.areas[this.topic.area.code].topicIds.filter(id => id != this.topic.id).map(id => this.$store.getters.topic(id));
        }
    },
}
</script>
