<template>
    <modal-base id="barInfo" :title="info ? info.short : ''">
        <div ref="content" v-if="id">
            <p>
                <strong>{{ info.name_a }}</strong><br/>
                <span class="name">{{ info.unit ? info.unit : info.unit_short }}</span>
            </p>
            <lines-svg :id="id" :width="width" :topic="topic" :settings="settings"></lines-svg>
            <p>
                <strong>Quelle: </strong><span class="source">{{ info.source }}</span><br/>
            </p>
            <p>
                <span class="text">{{ info.text }}</span>
            </p>
        </div>
    </modal-base>
</template>

<script>
import ModalBase from './Base.vue';
import LinesSvg from '../svg/Lines.vue';

export default {
    props: ['id', 'qf', 'topic', 'settings'],
    data: () => ({
        width: undefined
    }),
    computed: {
        info: function() { return this.$store.state.data.labels[this.id] },
    },
    components: {
        ModalBase, LinesSvg, 
    },
    watch: {
        'qf'() {
            const self = this;
            const modal = document.getElementById('barInfo');
            const modalB = new window.Modal(modal);
            modal.addEventListener('shown.bs.modal', event => {
                self.width = self.$refs.content.clientWidth;
            })
            modalB.show();
        }
    }
}
</script>