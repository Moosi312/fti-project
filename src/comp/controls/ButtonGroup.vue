<template>
    <span style="display: inline-block; vertical-align: middle; margin-right: 4px; font-size: 14px;">Ansicht:</span>
    <div class="btn-group" role="group">
        <input type="radio" class="btn-check" name="v" id="system" autocomplete="off" :checked="view == 'system'" @change="$router.push({ name: 'overview', params: { view: 'system' } })">
        <label class="btn btn-outline-dark btn-sm" for="system">System</label>
        <input type="radio" class="btn-check" name="v" id="bar" autocomplete="off" :checked="view == 'bar'" @change="$router.push({ name: 'overview', params: { view: 'bar' } })">
        <label class="btn btn-outline-dark btn-sm" for="bar">Balken</label>
    </div>
</template>

<script>

export default {
    props: ["labels", "value"],
    data() { 
        return {
            checked: Object.keys(this.labels)[1] == this.value
        }
    },
    computed: {
        l() {
            return Object.values(this.labels)
        }
    },
    watch: {
        checked() {
            this.$emit('input', Object.keys(this.labels)[+this.checked])
        },
        value() {
            this.checked = Object.keys(this.labels)[1] == this.value
        }
    }
}
</script>

<style lang="scss">
</style>