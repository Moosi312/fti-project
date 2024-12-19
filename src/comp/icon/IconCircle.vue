<template>
    <g :class='`iconCircle${this.$store.state.highlightTopics.includes(topic.nr) ? " activated" : ""} color-c${color}`'
        @click="$router.push({name: 'topic', params: {nr: topic.nr}})" :id='`topic-${id}`'
        @mouseover="$store.dispatch('highlightTargetsOfTopic', id)"
        @mouseout="$store.dispatch('highlightTargetsOfTopic')">
        <g :transform='`translate(-${circleRadius}, -${circleRadius})`'>
            <circle class="back" :cx="circleRadius" :cy="circleRadius" :r="circleRadius + 6"/>
            <circle class="fore" :cx="circleRadius" :cy="circleRadius" :r="circleRadius"/>
            <g :transform='`translate(${circleRadius - iconSize/2}, 13)`'>
                <icon :id='topic.icon' :key='topic.icon' :height='`${iconSize}px`' :width='`${iconSize}px`'/>
            </g>
            <text text-anchor="middle" :class='`lines-${topic.splitted.length}`' :transform='`translate(${circleRadius}, ${86 - (topic.splitted.length)/2*lineHeight})`'>
                <tspan x='0' v-for='(text, i) in topic.splitted' :y='i*lineHeight' :class='`line-${i}`'>{{ text }}{{ comp == "us" ? "*" : "" }}</tspan>
            </text>
        </g>
    </g>
</template>

<script>
//
import Icon from './Icon.vue';

export default {
    props: {
        id: String,
        circleRadius: {
            type: Number,
            default: 55
        },
        iconSize: {
            type: Number,
            default: 50
        }
    },
    data: () => ({
        lineHeight: 12,
    }),
    computed: {
        topic: function() {
            return this.$store.getters.topic(this.id);
        },
        comp: function() {
            return this.topic.comp[0];
        },
        color: function() {
            const value = this.$store.getters.value(this.topic.id, `rel.${this.comp}`)
            return this.$store.getters.toColorNr(value);
        },
    },
    components: {
        Icon,
    }
}
</script>
