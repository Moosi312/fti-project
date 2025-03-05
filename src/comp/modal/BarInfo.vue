<template>
    <modal-base id="barInfo" :title="info ? info.short : ''" size="xl">
      <indicator-small :indicator-id="id" :topic="topic"></indicator-small>
    </modal-base>
</template>

<script>
import ModalBase from './Base.vue';
import LinesSvg from '../svg/Lines.vue';
import IndicatorSmall from "./IndicatorSmall.vue";

export default {
    props: ['id', 'qf', 'topic', 'settings'],
    data: () => ({
        width: undefined
    }),
    computed: {
        info: function() { return this.$store.state.data.labels[this.id] },
    },
    components: {
      IndicatorSmall,
        ModalBase, LinesSvg, 
    },
    watch: {
        'qf'() {
            const self = this;
            const modal = document.getElementById('barInfo');
            const modalB = new window.Modal(modal);
            modal.addEventListener('shown.bs.modal', event => {
                // self.width = self.$refs.content.clientWidth;
            })
            modalB.show();
        }
    }
}
</script>