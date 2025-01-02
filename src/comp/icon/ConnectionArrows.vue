<template>
<text :transform='`translate(300, 300)`'>
  {{connectionArrows}}
</text>
</template>

<script>
import Text from "../block/Text.vue";
import {mapState} from "vuex";

export default {
  components: {Text},
  computed: mapState(['connectionArrows'])
}
</script>
