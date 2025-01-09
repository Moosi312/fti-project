<template>
    <div class="sticky-top" style="top: -1px; background-color: white; position: sticky">
        <div class="container-fluid full-width" style="background-color: white;">
            <div class='container-xl'>
                <div class="header row">
                    <div :class="`col-md-${cols} col-sm-12`">
                        <slot name="left">
                            <header-left/>
                        </slot>
                        
                    </div>
                    <div :class="`col-md-${12 - cols} col-sm-12`">
                        <slot name="right"></slot>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import Icon from '../icon/Icon.vue';
import HeaderLeft from './HeaderLeft.vue';

export default {
    props: {
        cols: {
            type: Number,
            default: 3
        },
    },
    components: {
        Icon, HeaderLeft
    },
    mounted() {
        this.$nextTick(function () {
            const el = document.querySelector(".sticky-top")
            // console.log(el)
            const observer = new IntersectionObserver( 
                ([e]) => e.target.classList.toggle("pinned", e.intersectionRatio < 1),
                { threshold: [1] }
            );
            observer.observe(el);
        })
    },
}
</script>


<style lang="scss">
.sticky-top {
    margin: 0 -8px 8px -8px;
    padding: 0 8px;
    background-color: white;

    > .header {
        margin-top: 0px;
        background-color: white;
    }

    &.pinned {
        margin-bottom: 2px;
        // color: red;
        // padding-bottom: 2px;
        
        > .header {
            
            // border-bottom: 1px solid #CCC;
        }
        // overflow: hidden;
    }
}
</style>