<template>
    <modal-base id="barInfo" :title="info ? info.short : ''" size="xl">
      <indicator :indicator-id="id" :modal="true"></indicator>
    </modal-base>
</template>

<script>
import ModalBase from './Base.vue';
import LinesSvg from '../svg/Lines.vue';
import Indicator from "../Indicator.vue";

export default {
    props: ['id', 'qf', 'topic', 'settings'],
    data: () => ({
        width: undefined
    }),
    computed: {
        info: function() { return this.$store.state.data.labels[this.id] },
    },
    components: {
      Indicator,
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