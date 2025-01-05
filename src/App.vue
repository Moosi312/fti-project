<template>
    <div v-if='$store.getters.loaded' :class='`container-xl r-${$route.name}`'>
        <svg style="height: 0; margin: 0; padding: 0">
            <defs>
                <marker id="arrowheadPie" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto-start-reverse">
                    <polygon points="0 0, 10 5, 0 10" />
                </marker>
            </defs>
        </svg>
        <dev-banner v-if='$store.getters.isDev'/>
        <topic v-if='$route.name == "topic"' :topic='this.$store.getters.topicByNr($route.params.nr)' />
        <target v-if='$route.name == "target"' :target='$store.getters.target($route.params.id)' />
        <overview v-if='$route.name == "overview"' :view='$route.params.view'/>
        <connection v-if='$route.name == "connection"'/>
        <test v-if='$route.name == "test"'/>
        <bar v-if='$route.name == "bar"'/>
        <all-in-one v-if='$route.name == "print"'/>
        <str-footer v-if='$route.name != "print"'/>
    </div>
</template>

<script>
import Overview from './comp/Overview.vue'
import AllInOne from './comp/AllInOne.vue'

import Topic from './comp/Topic.vue'
import Target from './comp/Target.vue'

import Bar from "./comp/svg/BarPrint.vue";

import DevBanner from './comp/str/DevBanner.vue';

import StrFooter from './comp/str/Footer.vue';
import Test from "./comp/Compare.vue";
import Connection from "./comp/Connection.vue";

export default {
    props: ['view'],
    components: {
      Test,
      Connection,
        Overview, Topic, Target, Bar, DevBanner, StrFooter, AllInOne
    },
    created: function() {
        this.$store.dispatch('init')
    },
    mounted: function() {
        document.addEventListener('click', function (event) {
            if (!event.target.matches('div.block-content .text sup a')) 
                return;
            event.preventDefault();
        }, false); 
    },
    watch: {
        '$route' () {
            this.$store.dispatch('clearHighlighted')
        }
    }
}
</script>

<style>
    div.block-content .text sup a {
        cursor: text;
    }
    section.footnotes a.data-footnote-backref {
        display: none;
    }
</style>


