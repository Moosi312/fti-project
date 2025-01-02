<template>
  <div class='overview'>
    <header-str v-if="type != 'print'" :cols="4">
      <template v-slot:right>
        <header-right-str title='FTI-Monitor' subtitle='Übersicht' icon='icon_FTISystem2'/>
      </template>
    </header-str>
    <div class="container-fluid full-width">
      <div class='container-xl'>
        <div class="row g-2 content">
          <div ref='system'>
            <div v-if='width > 600'>
              <connection-system :key='`system-svg-${testId}`' class="mt-md-5 mt-lg-2 mt-xl-0"/>
              <div class="row mb-2">
                <div style="font-size: 14px; text-align: center; line-height: 15px;" class="col-xl-5 offset-xl-3 col-md-6 offset-md-2 offset-0 col-7">
                  Österreich im Verhältnis zur Gruppe der Innovation Leaders <br/> (*EU27 zu den USA)<br/>
                  <!-- Im Verhältnis zur Gruppe der Innovation Leaders (*EU-27 zu den USA)<br/> -->
                  <color-legend style="width: 250px; margin: 3px auto 0 auto;"/>
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
import ConnectionSystem from "./svg/ConnectionSystem.vue";


export default {
  props: ['view', 'type'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: {
    ConnectionSystem,
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
</style>
