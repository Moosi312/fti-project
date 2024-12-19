<template>
    <block v-if="topics.includes(topic.id)" type="critTech" header="Kritische Technologien">
        <div class="group"><img :src='`/img/techtracker-aspi.png`'/><strong>ASPI’s Critical Technology Tracker</strong></div>
        <ul>
            <li>
                <a href='https://techtracker.aspi.org.au' target="_blank">44 kritische und aufkommende Technologien, ihre globale Spitzenforschung und den internationalen Talentefluss</a>
            </li>
        </ul>
    </block>
</template>

<script>
import Block from './Base.vue';

export default {
    props: ['topic'],
    data: () => ({
        topics: ['A3', 'B2', 'B3', 'C4', 'C6', 'D2']
    }),
    components: {
        Block
    }
}
</script>
