<template>
    <div class='header-left'>
        <router-link :to="{name: 'overview', params: {view: 'system'}}">
            <img src="/img/forwit.png" id='logo'/>
        </router-link>
    </div>
</template>

<script>
import Icon from '../icon/Icon.vue';

export default {
    props: ['icon', 'title', 'subtitle'],
    components: {
        Icon
    },
}
</script>

<style>
#logo {
    height: 40px;
    margin-top: 16px;
    margin-left: 2px;
}
</style>