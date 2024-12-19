<template>
    <svg class='icon-circle' viewBox="-70, -70, 140, 140">
        <icon-circle :id='topic.id' :class='`color-c1`'/>
    </svg>
</template>

<script>
import IconCircle from '../../icon/IconCircle.vue';

export default {
    props: ['topic'],
    components: {
        IconCircle,
    }
}
</script>
