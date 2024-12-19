<template>
    <block type="chart" header="Teilindikatoren">
        <div ref="container">
            <!-- {{ width }} -->
            <div v-if="width >= widthLimit"  style="margin-top: 5px;">
                <div style="text-align: right;">
                    <!-- <span v-if='compTime == "0"' style="display: inline-block; vertical-align: middle; margin-right: 4px;">Skala:</span> -->
                    <div v-if='compTime == "0"' class="btn-group me-2">
                        <!-- {{ scales }} -->
                        <switch-control v-model="scaleSelected" :labels="scales"/>
                        <!-- <template v-for="scale in scales">
                            <input type="radio" class="btn-check" name="scale" :id="scale.id" autocomplete="off" :checked="scaleSelected == scale.id" @change="scaleSelected = scale.id">
                            <label class="btn btn-outline-dark btn-sm" :for="scale.id">{{ scale.text }}</label>
                        </template> -->
                    </div>
                    <!-- <span style="display: inline-block; vertical-align: middle; margin-right: 4px; margin-left: 15px;">Reihenfolge:</span>
                    <div class="btn-group" role="group">
                        <template v-for="sel in orders">
                            <input type="radio" class="btn-check" name="order" :id="sel.id" autocomplete="off" :checked="orderSelected == sel.id" @change="orderSelected = sel.id">
                            <label class="btn btn-outline-dark btn-sm" :for="sel.id" v-html="sel.text"></label>
                        </template>
                    </div> -->
                    <div class="btn-group">
                        <button class="btn btn-dark btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            {{ compTimes[compTime] }}
                        </button>
                        <ul class="dropdown-menu">
                            <template v-for="t, k in compTimes" v-if="k != compTime">
                                <li><a class="dropdown-item" href="javascript:;" @click="compTime = k">{{ t }}</a></li>
                                <li v-if="k == 0"><hr class="dropdown-divider"/></li>
                            </template>
                        </ul>
                    </div>
                </div>
                
            </div>
            <bar-svg v-if="width >= widthLimit" :topic='topic' :options='{group: settings.compGroup, time: compTime, order: orderSelected, scale: scaleSelected}' v-on:modal="d => $emit('modal', d)"/>
            <div v-if="width >= widthLimit"  style="text-align: center; margin-bottom: 5px;">
                <a :href="`/docs/ind/${topic.id}.pdf`" target="_blank"><i class="bi bi-box-arrow-up-right"></i> Metainformation zu den Teilindikatoren</a>
            </div>
            <div v-else class="turnaround">
                <div><i class="bi bi-arrow-clockwise"></i></div>
                <span>Display zu schmal, bitte drehen.</span>
            </div>
        </div>
    </block>
</template>

<script>
import BarSvg from '../svg/Bar.vue';
import Block from './Base.vue';

// $store.state.info.year
import SwitchControl from '../controls/Switch.vue';


const compYears = [0, 1, 5, 10]

export default {
    props: ['topic', 'settings'],
    data: function() {
        return {
            comps: [
                { id: 'inno', text: 'Innovation Leaders'},
                { id: 'top3', text: 'Top 3'},
                { id: 'eu', text: 'EU-Durchschnitt'},
            ],
            scales: {
                log: 'Logarithmisch',
                lin: 'Linear',
            },
            // scales: [
            //     { id: 'log', text: 'Logarithmisch'},
            //     { id: 'lin', text: 'Linear'},
            // ],
            orders: [
                { id: 'name', text: '<i class="bi-sort-alpha-down"></i>'},
                { id: 'value', text: '<i class="bi-sort-down"></i>'},
            ],
            compTimes: Object.fromEntries(compYears.map(d => {
                return [d.toString(), d == 0 ? "Ist-Stand" : `Veränderung zu ${this.$store.state.info.year - d}`]
            })),
            compTime: "0",
            scaleSelected: "lin",
            orderSelected: "name",
            widthLimit: 500,
            width: 0,
        }
    },
    mounted() {
        // console.log(this.$refs.container)
        this.width = this.$refs.container.clientWidth;
    },
    components: {
        BarSvg, Block, SwitchControl
    },
}
</script>
