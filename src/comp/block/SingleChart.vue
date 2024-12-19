<template>
    <block type="chart" header="Aggregierter Indikator im Zeitverlauf">
        <div ref="container">
            <!-- <single-svg :topic='topic' :group='compGroup' v-on:modal="d => $emit('modal', d)"/> -->
            <!-- <div style="margin-left: 30px;"><strong>Zeitlicher Verlauf:</strong></div> -->
            <single-line-svg :id="topic.id" :group='compGroup' width="100" :topic="topic"/>
        </div>
    </block>
</template>

<script>
import SingleSvg from '../svg/Single.vue';
import SingleLineSvg from '../svg/SingleLine.vue';
import Block from './Base.vue';


export default {
    props: ['topic', 'compGroup'],
    data: () => ({
    }),
    components: {
        SingleSvg, Block, SingleLineSvg
    },
}
</script>
