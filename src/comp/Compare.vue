<template>
  <div class='compare'>
    <header-str v-if="type != 'print'" :cols="4">
      <template v-slot:right>
        <header-right-str title='FTI-Monitor' subtitle='Indikatorenvergleich' icon='icon_FTISystem2'/>
      </template>
    </header-str>
    <div class="container-fluid full-width">
        <div class="compare-content">
     
          <!-- You can add your topic controls here if needed -->
          <!-- <topic-controls style="text-align: right; margin-bottom: 5px;" :controlStatus='controlStatus' :topic='topic' @change="t => controlStatus = t"/> -->
          
          <div ref='system'>
            <div v-if='width > 600' class="row">

              <div class="col-md-3 col-lg-3 col-xl-3">
                <indicators :key='`system-svg-${testId}`'/>
              </div>
              
              <div class="col-md-4 col-lg-4 col-xl-4">
                  <h2>Column 1</h2>
                  <p>{{ $store.state.selectedIndicators.map(ind => $store.getters.getShortname(ind)) }}</p>
              </div>
              
              <div class="col-md-4 col-lg-4 col-xl-4">
                  <h2>Column 2</h2>
              </div>
            </div>
            <br />
            <br />
            <br />
            <br />
          </div>
          
        </div>
      </div>
    </div>
</template>

<script>
import HeaderStr from './str/Header.vue';
import HeaderRightStr from './str/HeaderRight.vue'
import TopicControls from './TopicControls.vue';
import SystemSvg from './svg/System.vue';
import Indicators from './svg/Indicators.vue';

export default {
  props: ['view', 'type'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: {
    HeaderRightStr, HeaderStr, TopicControls, SystemSvg, Indicators
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
}
</script>

<style>
.compare-content {
  margin-left: 5%;
  padding-top: 20px;
  height: 100%;
}
</style>
