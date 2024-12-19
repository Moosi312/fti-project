<template>
    <modal id="data" title="Daten">
        <div>
            <p>
                <strong>Indikatoren Österreich</strong><br/>
                Alle Indikatoren (Teilindikatoren und aggregierte Indikatoren) für Österreich sind unter
                <a href="/data/national.csv" target="_blank"><strong>/data/national.csv</strong></a>
                zu finden.
            </p>
            <p>
                <strong>Indikatoren International</strong><br/>
                Alle aggregierten Indikatoren sind unter der Adresse
                <a href="/data/international.csv" target="_blank"><strong>/data/international.csv</strong></a>
                abrufbar.
            </p>
        </div>
    </modal>
</template>

<script>
import Modal from './Base.vue';

export default {
    components: {
        Modal,
    }
}
</script>