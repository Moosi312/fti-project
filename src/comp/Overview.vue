<template>
    <div class='overview'>
        <header-str v-if="type != 'print'" :cols="4">
            <template v-slot:right>
                <header-right-str title='FTI-Monitor' subtitle='Übersicht' icon='icon_FTISystem2'/>
            </template>
        </header-str>
        <div class="container-fluid full-width">
            <div class='container-xl'>
                <div class="row g-2 content" style="position: relative;">
                    <div class="test-links">
                      <h5>Test links</h5>
                      <router-link :to="{name: 'connection'}">Connections</router-link>
                      <router-link :to="{name: 'test'}">Test</router-link>
                    </div>
                    <div v-if="type != 'print'" class="col-md-5 col-lg-4 col-xl-4">
                        <overview-targets group="fti" header="Ziele der FTI-Strategie 2030" :expanded=true></overview-targets>
                        <overview-targets group="klw" :header="$store.getters.targets('klw')[0]['name']" :expanded=true></overview-targets>
                    </div>
                    <div ref='system' :class="type != 'print' ? 'col-md-7 col-lg-8 col-xl-8' : 'offset-xl-2 col-xl-8'">
                        <div v-if='width > 600'>
                            <system-svg :key='`system-svg-${testId}`' v-if='view == "system"' class="mt-md-5 mt-lg-2 mt-xl-0"/>
                            <system-bar-svg :key='`system-bar-${testId}`' v-else class="mt-md-5 mt-lg-2 mt-xl-0"/>
                            <div class="row mb-2">
                                <div style="font-size: 14px; text-align: center; line-height: 15px;" class="col-xl-5 offset-xl-3 col-md-6 offset-md-2 offset-0 col-7">
                                    Österreich im Verhältnis zur Gruppe der Innovation Leaders <br/> (*EU27 zu den USA)<br/>
                                    <!-- Im Verhältnis zur Gruppe der Innovation Leaders (*EU-27 zu den USA)<br/> -->
                                    <color-legend style="width: 250px; margin: 3px auto 0 auto;"/>
                                </div>
                                <div style="text-align: right;" class="col-lg-4 col-5">
                                    <div class="mt-2">
                                        <switch-control v-model="view" :labels="{system: 'System', bar: 'Balken'}" @input="(v) => $router.push({ name: 'overview', params: { view: v } })"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div v-else>
                            <system-list/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import SystemSvg from './svg/System.vue';
import SystemBarSvg from './svg/SystemBar.vue';
import SystemList from './SystemList.vue';

import OverviewTargets from './block/OverviewTargets.vue';

import HeaderStr from './str/Header.vue';
import HeaderRightStr from './str/HeaderRight.vue'
import ColorLegend from './svg/Legend.vue';

import SwitchControl from './controls/Switch.vue';


export default {
    props: ['view', 'type'],
    data: () => ({
        width: null,
        testId: 0,
    }),
    components: {
        SystemSvg, HeaderRightStr, HeaderStr, SystemList, SystemBarSvg,
        ColorLegend, OverviewTargets, SwitchControl,
    },
    methods: {
        updateWidth() {
            if (this.$refs.system) {
                this.width = this.$refs.system.clientWidth
                this.testId += 1;
            }
        }
    },
    mounted() {
        this.width = this.$refs.system.clientWidth
        window.addEventListener('resize', this.updateWidth)
    },
    // beforeUnmount() {
    //     console.log('unmounted')
    //     window.removeEventListener('resize', this.updateWidth)
    // }
}
</script>

<style>
.full-width {
    width: 100vw;
    position: relative;
    margin-left: -50vw;
    left: 50%;
    background-color: #f5f6fa;
}
.test-links {
  position: absolute;
  top: 1rem;
  right: -150px;
  width: fit-content;
  display: flex;
  flex-direction: column;
  background-color: #444444;
  padding: 1rem;
  border: solid 1px black;
  border-radius: 4px;
  color: white;

  a {
    color: white;
    text-decoration: underline;
  }
}
</style>
