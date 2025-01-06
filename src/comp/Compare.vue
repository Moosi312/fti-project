<template>
  <div class="compare">
    <header-str v-if="type != 'print'" :cols="4">
      <template v-slot:right>
        <header-right-str title="FTI-Monitor" subtitle="Indikatorenvergleich" icon="icon_FTISystem2" />
      </template>
    </header-str>
    <div class="container-fluid full-width">
      <div class="compare-content">
        <div ref="system" class="grid-container">

          <div class="fixed-column">
            <indicators :key="`system-svg-${testId}`" />
          </div>

          <div class="dynamic-grid">
            <div v-if="$store.state.selectedIndicators.length === 0" class="sample-text">
              <p>Um Indikatoren vergleichen zu können, müssen diese im linken Bereich ausgewählt werden.</p>
            </div>

            <div v-for="indicator in $store.state.selectedIndicators" :key="indicator.id" class="grid-item">
              <indicators-overview :indicator="indicator" />
            </div>
          </div>

        </div>
        <br />
        <br />
        <br />
        <br />
      </div>
    </div>
  </div>
</template>

<script>
import HeaderStr from './str/Header.vue';
import HeaderRightStr from './str/HeaderRight.vue';
import Indicators from './svg/Indicators.vue';
import IndicatorsOverview from './svg/IndicatorsOverview.vue';

export default {
  props: ['view', 'type'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  components: {
    HeaderStr,
    HeaderRightStr,
    Indicators,
    IndicatorsOverview,
  },
  methods: {
    updateWidth() {
      if (this.$refs.system) {
        this.width = this.$refs.system.clientWidth;
        this.testId += 1;
      }
    },
  },
  mounted() {
    this.width = this.$refs.system?.clientWidth || 0;
    window.addEventListener('resize', this.updateWidth);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.updateWidth);
  },
};
</script>

<style scoped>
.compare-content {
  margin-left: 5%;
  padding-top: 20px;
  height: 100%;
}

.grid-container {
  display: grid;
  grid-template-columns: 1fr 3fr;
  gap: 20px;
}

.fixed-column {
  grid-row: 1 / span 1;
  position: sticky;
  top: 0;
}

.dynamic-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr); 
  gap: 20px;
}

.grid-item {
  padding: 10px;
  border-radius: 8px;
  height: 100%; 
  display: flex;
  align-items: left;
  justify-content: left;
}

.sample-text {
  grid-column: span 2;
  text-align: center;
  margin-top: 20%; /* try on different screens */
  padding: 10px;
  color: #707070;
}
</style>
