<template>
  <div class='overview'>
    <header-str v-if="type != 'print'" :cols="4">
      <template v-slot:right>
        <header-right-str title='FTI-Monitor' subtitle='Test component' icon='icon_FTISystem2'/>
      </template>
    </header-str>
    <div class="container-fluid full-width">
      <div class='container-xl'>
        Test component
      </div>
    </div>
  </div>
</template>

<script>
import OverviewTargets from './block/OverviewTargets.vue';

import HeaderStr from './str/Header.vue';
import HeaderRightStr from './str/HeaderRight.vue'


export default {
  props: ['view', 'type'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: {
    HeaderRightStr, HeaderStr,
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
.full-width {
  width: 100vw;
  position: relative;
  margin-left: -50vw;
  left: 50%;
  background-color: #f5f6fa;
}
</style>
