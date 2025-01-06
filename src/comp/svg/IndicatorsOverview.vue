<template>
  <div> 
    <h3 v-if="indicator" class="indicator-name">{{ $store.getters.getShortname(indicator) }}</h3>
    <p v-else>No indicator selected.</p>
    <p class="description">{{ $store.getters.getLabels(indicator).name_a }}</p>
  </div>
</template>

<script>
export default {
  props: ['indicator'],
  data: () => ({
    width: null,
    testId: 0,
  }),
  mounted() {
  },
  methods: {
  },
};
</script>

<style scoped>

.indicator-name{
  font-weight: 600;
}

.description{
  color: #707070;
  font-size: 12pt;
}

</style>
