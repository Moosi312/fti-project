<template>
<g>
  <g v-for="conn in connectionArrows">
    <path :d="`M${conn.fromLoc[0]} ${conn.fromLoc[1]} L${conn.toLoc[0]} ${conn.toLoc[1]}`" :stroke="conn.color" fill="none" stroke-width="10" stroke-dasharray="12 8">
      <animate attributeName="stroke-dashoffset" from="20" to="0" begin="0s" dur="1s" repeatCount="indefinite"></animate>
    </path>
  </g>
</g>
</template>

<script>
import Text from "../block/Text.vue";
import {mapState} from "vuex";

export default {
  components: {Text},
  computed: mapState(['connectionArrows']),
}
</script>
