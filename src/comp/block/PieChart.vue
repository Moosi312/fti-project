<template>
    <block v-if='targetValue' type="pie-chart" header="Zielerreichung">
        <pie-svg :target='target'/>
    </block>
</template>

<script>
import PieSvg from '../svg/Pie.vue';
import Block from './Base.vue';

export default {
    props: ['target'],
    data: () => ({
    }),
    computed: {
        targetValue: function() { return this.$store.getters.targetValues(this.target.id); }
    },
    components: {
        PieSvg, Block
    },
}
</script>
