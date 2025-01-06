<template>
    <svg class='icon-circle' viewBox="-70, -70, 140, 160">
        <icon-circle :id='topic' :class='`color-c1`'/>
        <circle :fill="inOut === 'i' ? '#000' : 'transparent'" r="8" cx="-40" cy="78" stroke="#000"></circle>
        <text transform="translate(-20, 85)" font-size="24">{{inOut === 'i' ? 'Input' : 'Output'}}</text>
    </svg>
</template>

<script>
import IconCircle from '../../icon/IconCircle.vue';

export default {
    props: ['topic', 'inOut'],
    components: {
        IconCircle,
    }
}
</script>
