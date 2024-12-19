<template>
    <block v-if="groups.length > 0" type="sdg" header="Sustainable Development Goals AT:EU" >
        <template v-for="g in groups">
            <div class="group"><span class="sdg-icon" :style="`background-color: ${g[1][0]['color']};`">{{ g[1][0]["no"] }}</span><strong>{{ g[1][0]["name-de"] }}</strong></div>
            <ul>
                <li v-for="e in g[1]">
                    <a :href='e["url"]' target="_blank"><i class="bi-box-arrow-up-right"></i> {{ e["indicator-de"] }}</a>
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
        groups: function() { return d3.groups(this.$store.getters.sdg(this.topic.id), d => d.no) },
    },
    components: {
        Block
    }
}
</script>

<style>
.group {
    position: relative;
}
.sdg-icon {
    font-size: 16px;
    position: absolute;
    left: 5px;
    top: -4px;
    width: 20px;
    height: 20px;
    color: white;
    font-weight: bold;
    text-align: center;
    padding-top: 4px;
}
</style>
