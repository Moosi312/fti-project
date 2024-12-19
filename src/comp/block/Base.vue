<template>
    <div :class='`block block-${ type } mb-4`' style="position: relative">
        <h4 v-if="expanded === null" class='block-header'>{{ header }}</h4>
        <h4 v-else="expanded !== null" styclass='block-header block-expand' @click="exp = !exp">{{ header }}
            <span style="cursor: pointer; position: absolute; right: 2px;"><template v-if="!exp">▼</template><template v-if="exp">▲</template></span>
        </h4>
        <div v-if="expanded === null || exp" class='block-content'>
            <slot></slot>
        </div>
        <slot name="hidden" v-if="expanded !== null && exp == false"></slot>
    </div>
</template>

<script>
export default {
    props: {
        expanded: { default: null },
        header: {},
        type: {}
    },
    data: function() {
        return {
            exp: this.expanded
        }
    }
}
</script>
