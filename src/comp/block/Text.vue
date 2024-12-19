<template>
    <block v-if='full != ""' type="text" :header="name">
        <div class="text-content">
            <div v-html="full" class="text" ref="text"></div>
            <div v-if="height > 399" class="readmore">
                <div class="fadeout"></div>
                <div class="buttonContainer">
                    <button type="button" class="btn btn-outline-dark btn-sm" data-bs-toggle="modal" :data-bs-target="`#textModal-${type}`">
                        Weiterlesen ...
                    </button>
                </div>
            </div>
        </div>
        <!-- Modal -->
        <div class="modal fade text" :id="`textModal-${type}`" tabindex="-1" :aria-labelledby="`#textModalLabel-${type}`" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" :id="`textModalLabel-${type}`">{{ name }}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schliessen"></button>
                    </div>
                    <div class="modal-body" v-html="full">
                    </div>
                    <!-- <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div> -->
                </div>
            </div>
        </div>
    </block>
</template>

<script>
import {micromark} from 'micromark'
import {gfmFootnote, gfmFootnoteHtml} from 'micromark-extension-gfm-footnote'
import {gfmAutolinkLiteral, gfmAutolinkLiteralHtml} from 'micromark-extension-gfm-autolink-literal'
import Vue from "vue";

import axios from 'axios';
import Block from './Base.vue';

export default {
    props: ['file', 'name', 'fallback', 'type'],
    data: () => ({
        full: "",
        exists: false,
        height: 1000,
    }),
    methods: {
        loadText: function() {
            const self = this
            const mdFile = this.$store.getters.getMdFile(this.file)
            axios
                .get(mdFile)
                .then(r => {
                    if (r && r.headers["content-type"] != "text/html") {
                        self.setContent(r)
                    } else {
                        self.setIfDefaultContent()
                    }
                }, r => {
                    self.setIfDefaultContent()
                })
        },
        setContent(r) {
            this.full = micromark(r.data, {
                extensions: [gfmFootnote(), gfmAutolinkLiteral],
                htmlExtensions: [gfmFootnoteHtml({ label:'Fußnoten:' }), gfmAutolinkLiteralHtml]
            })

            Vue.nextTick(() => {
                this.height = this.$refs.text.clientHeight;
            });
        },
        setIfDefaultContent() {
            if (this.fallback) {
                axios
                    .get(this.$store.getters.getMdFile(this.fallback))
                    .then(this.setContent, {})
            }
        }
    },
    components: {
        Block
    },
    watch: {
        topic: {
            immediate: true,
            handler (val, oldVal) {
                this.loadText()
            }
        }
    }
}
</script>
