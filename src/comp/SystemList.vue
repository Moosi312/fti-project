<template>
    <div class='system'>
        <div v-for='(a, k) in areas'  style="text-align: center; margin-top: 10px; margin-bottom: 10px;">
            <strong>{{ a.name }}</strong>
            <div style="text-align: center;">
                <div v-for='topic in a.topicIds.map(id => topic(id))' style="display: inline-block;">
                    <!-- {{ topic }} -->
                    <topic-entry :key='topic.id' :topic='topic'/>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import TopicEntry from './block/shared/TopicEntry.vue';

export default {
    data: () => ({
    }),
    components: {
        TopicEntry
    },
    computed: {
        areas: function() { return this.$store.state.info.areas },
        topic: function() { return this.$store.getters.topic },
    },
}
</script>
