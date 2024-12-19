<template>
    <div class='header-right'>
        <div v-if='icon' class='icon-header'>
            <icon :id='icon'/>
        </div>
        <div class='text-header'>
            <div><router-link :style="`visibility: ${['overview', 'print'].includes($route.name) ? 'hidden' : 'visible'}`" :to="{name: 'overview', params: {view: 'system'}}">←</router-link> <span class='sub'>{{ subtitle }}</span></div>
            <h2>{{ title }} <span class='nr'>{{ nr }}</span></h2>
        </div>
        <div class='text-right'>
            <div class="report">
                <span>Jahr&nbsp;&nbsp;&nbsp;&nbsp;</span><br/>
                <select v-model="year" id="year-selector" class="form-select form-select-sm" aria-label=".form-select-sm example">
                    <option value="2024" selected>2024</option>
                    <option value="2023">2023</option>
                    <option value="2022">2022</option>
                </select>
            </div>
            <div class="data">
                <span>Datenstand</span><br/>
                <span id="datenstand" style="font-weight: bold" data-bs-html="true" data-bs-toggle="tooltip" data-bs-placement="bottom" :title="tooltip">März 2024 <i class="bi bi-info-circle-fill"></i></span>
            </div>
            
        </div>
    </div>
</template>

<script>
import Icon from '../icon/Icon.vue';
import { Tooltip } from 'bootstrap';

export default {
    props: ['icon', 'title', 'subtitle', 'nr'],
    data() {
        return {
            year:  this.$store.state.info.year,
            tooltip: "Einige der verwendeten Indikatoren – u.a. manche von OECD und Eurostat – sind nur mit einer zeitlichen Verzögerung von durchschnittlich zwei bis vier Jahren verfügbar. Zur Orientierung werden daher bei jedem Einzelindikator Zeitreihen visualisiert und die Datenquelle angegeben. Für manche Indikatoren, die starken Schwankungen aufgrund von Methoden- oder Datenbrüchen unterliegen, werden gleitende Durchschnitte herangezogen."
        }
    },
    components: {
        Icon
    },
    mounted() {
        new Tooltip(document.getElementById('datenstand'));
    },
    watch: {
        year() {
            if (this.year != this.$store.state.info.year) {
                window.location.href = `/${this.year}`
            }
        }
    }
}
</script>


<style>
select {
    text-align-last: right;
}
option {
    direction: rtl;
}
</style>