<template>
    <component class='icon' :id='`icon-${id}`' :is='`icon-${id}`'/>
</template>

<script>
export default {
    props: {
        id: String
    },
    created() {
        // console.log(this.id)
        this.$options.components[`icon-${this.id}`] = () => import(`../../../assets/icons/svg/${this.id}.svg`)
    },
    // }
};
</script>
