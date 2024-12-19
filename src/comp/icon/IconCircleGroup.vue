<template>
    <g class='iconCircleGroup'>
        <circle filter="url(#black-glow)" class='back' :cx="radius" :cy="radius" :r="radius" :transform='`translate(-${radius}, -${radius})`'/>
        <icon-circle v-for='(o, id) in icons' :id='id' :key='id' :transform='`translate(${radius*Math.cos(o/360*2*Math.PI)}, ${radius*Math.sin(o/360*2*Math.PI)})`'/>
    </g>
</template>

<script>
import IconCircle from './IconCircle.vue';

export default {
    props: ['icons', 'radius'],
    components: {
        IconCircle
    }
}
</script>
