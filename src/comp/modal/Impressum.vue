<template>
    <modal id="impressum" title="Impressum" size="md">
        <div id='impressum' style="margin: 0 20px;">
            <p>
                <strong>Herausgeber und Medieninhaber</strong><br/>
                <p>
                    FORWIT<br/>
                    Rat für Forschung, Wissenschaft,<br/>
                    Innovation und Technologieentwicklung<br/>
                    Pestalozzigasse 4/D1<br/>
                    1010 Wien<br/>
                    <a href="mailto:office@forwit.at" target="_blank">office@forwit.at</a><br/>
                    +43 1 713 14 14-0<br/><br/>
                </p>
            </p>
            <p>
                <strong>Design und Entwicklung</strong>
                  
                <div style="margin: 40px auto 10px; text-align: center;">
                    <a href="https://forwit.at/" target="_blank"><img src="/img/forwit.png" alt="FORWIT" style="max-width: 50%; width: 100px; margin-bottom: 5px"/></a><br/>
                    
                    Kontakt: <a href="mailto:amh@forwit.at">Alexandra Mazak-Huemer</a>
                </div>  

                <div style="margin: 40px auto 10px; text-align: center;">
                    <a href="https://wifo.ac.at/" target="_blank"><img src="/img/wifo.png" alt="WIFO" style="max-width: 50%; width: 100px; margin-bottom: 5px"/></a><br/>
                    Kontakt: <a href="mailto:juergen.janger@wifo.ac.at">Jürgen Janger</a>
                </div>
                
                <div style="margin: 40px auto; text-align: center;">
                    <a href="https://www.extraplan.at/" target="_blank"><img src="/img/extraplan.png" alt="Extraplan" style="max-width: 50%; width: 100px;"/></a><br/>
                </div>
            </p>
        </div>
    </modal>
</template>

<script>
import Modal from './Base.vue';
import Icon from '../icon/Icon.vue';

export default {
    components: {
        Modal, Icon
    }
}
</script>
