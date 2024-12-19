<template>
    <block v-if="wirkungsziele.length > 0" type="wirkungsziele" header="Wirkungsziele" >
        <!-- {{ wirkungsziele }} -->
        <ul>
            <li v-for="wz in wirkungsziele">
                <a :href="wz.url" target="_blank"><i class="bi-box-arrow-up-right"></i> <strong>{{ wz.org.short }} UG {{ wz.ug.nr }}.{{ wz.nr }} </strong> {{ wz.name }}</a>
            </li>
        </ul>
    </block>
</template>

<script>
import Block from './Base.vue';
export default {
    props: ['topic'],
    computed: {
        wirkungsziele: function() { return this.$store.getters.wirkungsziele(this.topic.id) },
    },
    components: {
        Block
    }
}
</script>
