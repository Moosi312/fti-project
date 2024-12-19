<template>
    <block type="map" header="Internationaler Vergleich">
        <div class='row g-2'>
            <template v-if='comp == "top3"'>
                <div class="col-12" style="padding: 20px;">
                    Relativ zu den Top3-Ländern wird keine Landkarte gezeigt, weil die Top3-Länder für jeden Einzelindikator unterschiedlich sind. Der Vergleich einzelner Länder gegenüber den Top3 ist daher nur auf Ebene der einzelnen Indikatoren sinnvoll, wie unten für Österreich relativ zu den Top3 gezeigt.
                </div>
            </template>
            <template v-else>
                <div :class='`${typeSelected == "europe" ? "col-md-5" : "col-xl-4 col-lg-12 col-md-4"} col-sm-12 left`'>
                    <div v-if='comp == "inno"' class='compare'>
                        Im Verhältnis zur Gruppe der<br/><br/>
                        <span>Innovation Leaders</span><br/>
                        <template v-for="(d, i) in innoLeaders">
                            {{ i + 1 }}. {{ d.map(i => countries[i]).join(', ') }} <br/>
                        </template><br/>
                    </div>
                    <div v-if='comp == "top3"' class='compare'>
                        Im Verhältnis zum Durchschnitt der <span>Top 3</span><br/><br/>
                        <!-- <span>Top 3 - {{ topic.name }}</span><br/>
                        <template v-for="(d, i) in topCountries">
                            {{ i + 1 }}. {{ d.map(i => countries[i]).join(', ') }} <br/>
                        </template><br/> -->
                    </div>
                    <div v-if='comp == "us"' class='compare'>
                        EU-27 im Verhältnis zu den <span>USA</span><br/><br/>
                    </div>
                    <div v-if='comp == "cn"' class='compare'>
                        EU-27 im Verhältnis zu <span>China</span><br/><br/>
                    </div>
                    <div v-if='comp == "jp"' class='compare'>
                        EU-27 im Verhältnis zu <span>Japan</span><br/><br/>
                    </div>
                    <div v-if='comp == "kr"' class='compare'>
                        EU-27 im Verhältnis zu <span>Südkorea</span><br/><br/>
                    </div>
                    <!-- <div v-if='comp == "top3"'><div v-if='comp == "kr"' class='compare'>
                        EU-27 im Verhältnis zu <span>Südkorea</span><br/><br/>
                    </div>
                    <div v-if='comp == "top3"' style='font-size: 11px; margin-left: 15px;'>
                        <p>Der Gesamtindikator berechnet sich aus dem Durchschnitt der Teilindikatoren unten, die nicht für alle Länder gleich verfügbar sind. Der Top 3 Gesamtindikator ist daher mit Vorsicht zu interpretieren.</p>
                    </div> -->

                    <div v-if='comp == "eu"' class='compare'>
                        Im Verhältnis zum <span>EU-Durchschnitt</span><br/><br/>
                    </div>
                    <div style="margin-left: 15px;">
                        <color-legend/>
                    </div>
                </div>
                <div :class='`${typeSelected == "europe" ? "col-md-7" : "col-xl-8 col-lg-12 col-md-8"} col-sm-12 map-container`'>
                    <europe-map :topic='topic' :comp='comp' :type='typeSelected'/>
                    <switch-control class="map-control" v-model="typeSelected" :labels="types"/>
                </div>
            </template>
        </div>
    </block>
</template>

<script>
import EuropeMap from '../svg/EuropeMap.vue';
import Block from './Base.vue';
import ColorLegend from '../svg/Legend.vue';

import SwitchControl from '../controls/Switch.vue';

export default {
    props: ['topic', 'comp'],
    data: function() {
        return {
            typeSelected: this.topic.mapDefault,
            // types: [
            //     { id: 'europe', text: 'Europa'},
            //     { id: 'world', text: 'Welt'},
            // ],
            types: {
                europe: 'Europa',
                world: 'Welt',
            },
        }
    },
    components: {
        EuropeMap, Block, ColorLegend, SwitchControl
    },
    computed: {
        topCountries: function() { return this.$store.getters.topCountries(this.topic.id, this.comp); },
        countries: function() { return this.$store.state.data.countries; },
        innoLeaders: function() { return this.$store.state.info.innovationLeaders; },
        nameForCompareGroup: function() { return this.$store.getters.nameForCompareGroup; },
    },
    watch: {
        'topic' () {
            this.typeSelected = this.topic.mapDefault
        }
    }
}
</script>
