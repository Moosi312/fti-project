<template>
    <g class='iconCircleGroup'>
        <conn-icon-circle v-for='(o, id) in icons' :id='id' :key='id' :transform='`translate(${radius*Math.cos(o/360*2*Math.PI)}, ${radius*Math.sin(o/360*2*Math.PI)})`'/>
    </g>
</template>

<script>
import IconCircle from './IconCircle.vue';
import ConnIconCircle from "./ConnIconCircle.vue";

export default {
    props: ['icons', 'radius'],
    components: {
      ConnIconCircle,
        IconCircle
    }
}
</script>
