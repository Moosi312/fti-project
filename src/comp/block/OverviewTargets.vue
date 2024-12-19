<template>
    <block type="overview-targets" :header="header" :expanded="expanded">
        <ul class='parent'>
            <li v-for="tp in $store.getters.targets(group)" :key="tp.nr">
                <div v-if="$store.getters.targets(group).length > 1">
                    {{ tp.nr }} - {{ tp.name }}
                </div>
                <ul>
                    <template v-for="tc in tp.children.map(i => $store.getters.target(`${tp.nr}.${i.nr}`))">
                        <router-link :to="{name: 'target', params: {id: tc.id}}">
                            <li :class='{highlighted: $store.state.highlightTargets.includes(tc.id), target: true}'
                                @mouseover="$store.dispatch('highlightTopicsOfTarget', tc.id)"
                                @mouseout="$store.dispatch('highlightTopicsOfTarget')">
                                <pie-small-svg :target='tc'/>
                                <span class="target">{{ tc.id }}</span>
                                <!-- <div class="badge-container"><span class="badge target rounded-pill">{{ tc.id }}</span></div> -->
                                <span class="text">{{ tc.name }}</span>
                            </li>
                        </router-link>
                    </template>
                </ul>
            </li>
        </ul>
        <template v-slot:hidden>
            <template v-if="high.length > 0">
                <div class='block-content'>
                    <ul class='parent'>
                        <li>
                            <ul>
                                <template v-for="tc in high">
                                    <li :class='{highlighted: true, target: true}'>
                                        <pie-small-svg :target='tc'/>
                                        <span class="target">{{ tc.id }}</span>
                                        <!-- <div class="badge-container"><span class="badge target rounded-pill">{{ tc.id }}</span></div> -->
                                        <span class="text">{{ tc.name }}</span>
                                    </li>
                                </template>
                            </ul>
                        </li>
                    </ul>
                </div>
            </template>
        </template>
    </block>
</template>

<script>


import PieSmallSvg from '../svg/PieSmall.vue';
import Block from './Base.vue';

export default {
    props: ['group', 'header', 'expanded'],
    data: () => ({
    }),
    computed: {
        high() {
            const ids = this.$store.getters.targets(this.group).map(d => d.children.map(d => d.id)).flat();
            return this.$store.state.highlightTargets.filter(d => ids.includes(d)).map(this.$store.getters.target)
        }
    },
    components: {
        Block, PieSmallSvg,
    },
    methods: {
    }
}
</script>
