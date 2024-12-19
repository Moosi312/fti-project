<template>
    <block v-if='["A2", "B1", "B3", "B4", "C2", "C3", "C4", "C6"].includes(topic.id)' type="docs" header="Grüne Produktpotenziale">
        <div class="row g-0">
            <div :class="`col-sm-12 col-md-12`">
                <div class="card border-0">
                    <a href="https://ecto.forwit.at" target="_blank" class="ecto">
                        <div class="card-body p-0" style="position: relative; line-height: 16px;">
                            <div class="img">
                                <icon class="ecto" id='ECTO'/>
                            </div>
                            <div class="content">
                                <span class="name">ECTO-Dashboard</span><br/> Potenziale zur Erzeugung grüner Produkte in Österreich und die dafür benötigten Fachkräfte 
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </block>
</template>

<script>
import Icon from '../icon/Icon.vue';
import Block from './Base.vue';

export default {
    props: ['topic'],
    components: {
        Block, Icon
    }
}
</script>
