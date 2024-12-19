<template>
    <div class="form-check form-switch">
        <span :class="{active: !checked }">{{ l[0] }}</span> <input type="checkbox" class="form-check-input" v-model="checked"/> <span :class="{active: checked }">{{ l[1] }}</span>
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
div.form-switch {
    input.form-check-input {
        margin: 4px 5px;
        float: none;
        width: 35px;
        height: 20px;
        background-color: black;
        border-color: black;
        background-image: url("data:image/svg+xml,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%27-6 -6 12 12%27%3e%3ccircle r=%276%27 fill=%27%23fff%27/%3e%3c/svg%3e");
    }
    span {
        font-size: 14px;
        display: inline-block;
        margin-top: 5px;
        &.active {
            color: black;
        }
        color: #777;
    }


}
</style>