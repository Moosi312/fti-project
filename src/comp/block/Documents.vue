<template>
    <block v-if="docs.length > 0" :type="`docs`" :header="header">
        <div class="row g-0">
            <div v-if="type != 'd'" v-for="item in docs.slice(0, (previewUse && preview) ? previewCount : count)" :key="item.fileUrl" :class="`col-sm-12 col-md-${12/cols}`">
                <div class="card border-0">
                    <a :href="item.fileUrl" target="_blank">
                        <div class="card-body p-0" style="position: relative; line-height: 16px;">
                            <div class="img">
                                <img :src='item.imgUrl' class="rounded">
                            </div>
                            <div class="content">
                                <span v-if='item.name.length < 100' class="name">{{
                                    item.name
                                }}</span><span v-else :title="item.name" class="name">{{
                                    item.name.substring(0, 90)
                                }}...</span><span v-if='item.authors' class="institute">{{
                                    item.authors.map(d => d.short).join(' | ')
                                }}</span><span v-if="showYear" class="year">{{
                                    item.year
                                }}</span>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
            <div v-if="type == 'd'" :class="`col-sm-12 col-md-${12/cols}`">
                <div class="card border-0">
                    <a href="/data/national.csv" target="_blank" class='csv'>
                        <div class="card-body p-0" style="position: relative; line-height: 16px;">
                            <div class="img">
                                <i class="bi bi-filetype-csv"></i>
                            </div>
                            <div class="content">
                                <span class="name">Indikatoren Österreich</span><br/> alle Indikatoren (Teil- und aggregierte Indikatoren) für Österreich
                            </div>
                        </div>
                    </a>
                </div>
            </div>
            <div v-if="type == 'd'" :class="`col-sm-12 col-md-${12/cols}`">
                <div class="card border-0">
                    <a href="/data/international.csv" target="_blank" class='csv'>
                        <div class="card-body p-0" style="position: relative; line-height: 16px;">
                            <div class="img">
                                <i class="bi bi-filetype-csv"></i>
                            </div>
                            <div class="content">
                                <span class="name">Indikatoren international</span><br/> alle aggregierten Indikatoren international
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <button v-if="(previewUse && preview)" type="button" class="btn btn-light"  @click="preview = false">Alle {{ count }} {{ header }}</button>
    </block>
</template>

<script>
import Block from './Base.vue';
export default {
    props: {
        inputDocs: {default: undefined},
        topicIds: {},
        type: {},
        header: {},
        cols: {default: 1},
        showYear: {default: true},
        previewCount: {default: 4},
        previewUseCount: {default: 6},
    },
    data() {
        return {
            preview: true,
        }
    },
    computed: {
        docs: function() { return this.inputDocs ?? this.$store.getters.docs(this.topicIds, this.type) },
        count: function() { return this.docs.length },
        previewUse: function() { return this.count > this.previewUseCount },
    },
    components: {
        Block
    }
}
</script>
