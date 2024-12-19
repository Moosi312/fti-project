<template>
    <block v-if="targetValues" type="line-chart" header="Entwicklung Zielerreichung">
        <div style="text-align: right;">
            <switch-control v-model="typeSelected" :labels="types"/>
            <!-- <div class="btn-group" role="group">
                <template v-for="type in types">
                    <input type="radio" class="btn-check" name="type" :id="type.id" autocomplete="off" :checked="typeSelected == type.id" @change="typeSelected = type.id">
                    <label class="btn btn-outline-dark btn-sm" :for="type.id">{{ type.text }}</label>
                </template>
            </div> -->
        </div>
        <line-svg :target='target' :type="typeSelected"/>
        <div style="margin-left: 10px">
            <strong>{{ target.desc }}</strong><br/>
            <template v-if="target.source"><strong>Quelle:</strong> {{ target.source }}</template>
        </div>
    </block>
</template>

<script>
import LineSvg from '../svg/Line.vue';
import Block from './Base.vue';

import SwitchControl from '../controls/Switch.vue';

export default {
    props: ['target'],
    data: () => ({
        // types: [
        //     { id: 'v', text: 'tatsächliche Werte'},
        //     { id: 'n', text: 'Zielerreichung'},
        // ],
        types: {
            v: 'tatsächliche Werte',
            n: 'Zielerreichung',
        },
        typeSelected: 'v',
    }),
    computed: {
        targetValues: function() { return this.$store.getters.targetValues(this.target.id, "series"); },
    },
    components: {
        LineSvg, Block, SwitchControl
    },
}
</script>
