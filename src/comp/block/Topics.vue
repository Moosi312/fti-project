<template>
    <block v-if='topics.length > 0' type="strat" header="Betroffene Bereiche">
        <ul class="list-group list-group-flush">
            <li class="list-group-item" v-for="topic in topics" :key="topic.nr">
                <router-link :to="{name: 'topic', params: {nr: topic.nr}}">{{ topic.nr }} {{ topic.name }}</router-link>
            </li>
        </ul>
    </block>
</template>

<script>
import Block from './Base.vue';
export default {
    props: ['target'],
    components: {
        Block,
    },
    computed: {
        topics: function() { return this.target.topics.map(id => this.$store.getters.topic(id)); }
    },
}
</script>
