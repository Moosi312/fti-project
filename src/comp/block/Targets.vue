<template>
    <block v-if='targets.length > 0' type="strat" :header="header">
        <ul class="list-group list-group-flush">
            <template v-for="tc in targets">
                <router-link :to="{name: 'target', params: {id: `${tc.id}`}}">
                    <li class="target">
                        <pie-small-svg :target='tc'/>
                        <span class="target">{{ tc.id }}</span>
                        <span class="text">{{ tc.name }}</span>
                    </li>
                </router-link>
            </template>
        </ul>
    </block>
</template>

<script>
import Block from './Base.vue';
import PieSmallSvg from '../svg/PieSmall.vue';

export default {
    props: ['topic', 'type', 'header'],
    components: {
        Block, PieSmallSvg,
    },
    computed: {
        targets: function() { return this.$store.getters.targetsForTopic(this.topic, this.type) }
    },
}
</script>
