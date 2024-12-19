<template>
    <div class="footer">
        <div id='menu'>
            <router-link :to="{name: 'print' }"><i class="bi bi-printer-fill"></i>&nbsp;Druckansicht</router-link>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="#" data-bs-toggle="modal" data-bs-target="#data"><i class="bi bi-table"></i>&nbsp;Daten</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="#" data-bs-toggle="modal" data-bs-target="#info"><i class="bi bi-info-circle-fill"></i>&nbsp;Über den FTI-Monitor</a>
            <span class="d-md-none"><br/></span>
            <span class="d-none d-md-inline">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <a href="https://forwit.at" target="_blank"><i class="bi bi-file-richtext-fill"></i>&nbsp;Website</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="https://at.linkedin.com/company/forwit-at" target="_blank"><i class="bi bi-linkedin"></i>&nbsp;Linkedin</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="mailto:fti-monitor@forwit.at" target="_blank"><i class="bi bi-envelope-fill"></i>&nbsp;Kontakt</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="#" data-bs-toggle="modal" data-bs-target="#datenschutz"><i class="bi bi-shield-fill"></i>&nbsp;Datenschutz</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="#" data-bs-toggle="modal" data-bs-target="#impressum"><i class="bi bi-file-text-fill"></i>&nbsp;Impressum</a><br/>
        </div>
        <modal-info/>
        <modal-impressum/>
        <modal-datenschutz/>
        <modal-data/>
    </div>
</template>

<script>

import ModalImpressum from   '../modal/Impressum.vue';
import ModalDatenschutz from '../modal/Datenschutz.vue';
import ModalData from '../modal/Data.vue';
import ModalInfo from '../modal/Info.vue';

export default {
    components: {
        ModalImpressum, ModalDatenschutz, ModalData, ModalInfo,
    },
}
</script>
