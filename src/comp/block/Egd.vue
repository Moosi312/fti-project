<template>
    <block v-if="groups.length > 0" type="egd" header="European Green Deal AT:EU" >
        <template v-for="g in groups">
            
            <div class="group"><img :src='`/img/egd.png`'/><strong>{{ g[1][0]["goal-de"] }}</strong></div>
            <ul>
                <li v-for="e in g[1]">
                    <a :href='e["url"]' target="_blank"><i class="bi-box-arrow-up-right"></i> {{ e["indicator-no"] }}. {{ e["indicator-de"] }}</a>
                </li>
            </ul>
        </template>
    </block>
</template>

<script>
import * as d3 from "d3";

import Block from './Base.vue';

export default {
    props: ['topic'],
    computed: {
        groups: function() { return d3.groups(this.$store.getters.egd(this.topic.id), d => d["goal-de"]) },
    },
    components: {
        Block
    }
}
</script>
