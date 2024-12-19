<template>
    <div class='controls'>
        <span style="display: inline-block; vertical-align: middle; margin-right: 4px;">Vergleich zu:</span>
        <div class="btn-group" role="group">
            <template v-for="comp in compGroups">
                <input type="radio" class="btn-check" name="comp" :id="comp" autocomplete="off" :checked="controlStatus.compGroup == comp" @change="$emit('change', {compGroup: comp, compTime: controlStatus.compTime})">
                <label class="btn btn-outline-dark btn-sm" :for="comp">{{ nameForCompareGroup(comp) }}</label>
            </template>
            <!-- <a class="btn btn-dark btn-sm " href="#" @click="$emit('change', {compGroup: controlStatus.compGroup, compTime: '0'})">{{ 0 }}</a>
            <a class="btn btn-dark btn-sm " href="#" @click="$emit('change', {compGroup: controlStatus.compGroup, compTime: '1'})">{{ 1 }}</a> -->
        </div>
        <!-- <div class="btn-group">
            <button class="btn btn-dark btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                {{ compTimes[controlStatus.compTime] }}
            </button>
            <ul class="dropdown-menu">
                <template v-for="t, k in compTimes" v-if="k != controlStatus.compTime">
                    <li><a class="dropdown-item" href="#" @click="$emit('change', {compGroup: controlStatus.compGroup, compTime: k})">{{ t }}</a></li>
                    <li v-if="k == 0"><hr class="dropdown-divider"/></li>
                </template>
            </ul>
        </div> -->
    </div>
</template>

<script>

export default {
    props: ['controlStatus', 'topic'],
    data: () => ({
        // compGroups: ['inno', 'top3', 'eu', 'us', 'cn'],
        // compTimes: {
        //     "0": "Ist-Stand",
        //     "1": "Vergleich zu t-1",
        //     "5": "Vergleich zu t-5",
        //     "10": "Vergleich zu t-10",
        // }
    }),
    components: {
    },
    computed: {
        nameForCompareGroup: function() { return this.$store.getters.nameForCompareGroup; },
        compGroups: function() { return this.topic.comp },
    },
}
</script>
