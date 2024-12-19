<template>
    <modal id="datenschutz" title="Datenschutzerklärung">
        <div>
            <h2 id="zweck-der-datenverarbeitung">Zweck der Datenverarbeitung</h2>
            <p>Diese Webseite verwendet Matomo 66, eine selbstgehostete Open Source
            Software um anonyme Nutzungsdaten für diese Webseite zu sammeln. Die
            Daten zum Verhalten der Besucher werden gesammelt, um eventuelle
            Probleme wie nicht gefundene Seiten, Suchmaschinenprobleme oder
            unbeliebte Seiten herauszufinden. Sobald die Daten (Anzahl der Besucher
            die Fehlerseiten oder nur eine Seite sehen usw.) verarbeitet werden,
            erzeugt Matomo Berichte für die Webseitenbetreiber, damit diese darauf
            reagieren können (Layoutveränderungen, neue Inhalte usw.).</p>
            <p>Matomo verarbeitet die folgenden Daten:</p>
            <ul>
            <li>Anonymisierte IP-Adressen indem die letzten 2 bytes entfernt werden
            (also 198.51.0.0 anstatt 198.51.100.54)</li>
            <li>Pseudoanonymisierter Standort (basierend auf der anonymisierten
            IP-Adresse)</li>
            <li>Datum und Uhrzeit</li>
            <li>Titel der aufgerufenen Seite</li>
            <li>URL der aufgerufenen Seite</li>
            <li>URL der vorhergehenden Seite (sofern diese das erlaubt)</li>
            <li>Bildschirmauflösung</li>
            <li>Lokale Zeit</li>
            <li>Dateien die angeklickt und heruntergeladen wurden</li>
            <li>Externe Links</li>
            <li>Dauer des Seitenaufbaus</li>
            <li>Land, Region, Stadt (mit niedriger Genauigkeit aufgrund von
            IP-Adresse)</li>
            <li>Hauptsprache des Browsers</li>
            <li>User Agent des Browsers</li>
            </ul>
            <h2 id="cookies">Cookies</h2>
            <p>Weder Matomo noch andere Funktionalitäten dieser Website verwenden
            Cookies.</p>
            <h2 id="indirekte-datensammlung">Indirekte Datensammlung</h2>
            <h3 id="server-logs">Server Logs</h3>
            <p>Wenn Sie diese Webseite verwenden, wird der Aufruf vom Host der
            Webseite (<a href="https://edis.at">Edis</a>) aufgezeichnet. Dieses Log
            enthält Ihre IP-Adresse, welche Sie indirekt über Ihren Internetanbieter
            identifiziert. Die Aufzeichnung dieser Daten ist gesetzlich
            verpflichtend und für die Sicherheit notwendig. Es gibt keine
            Möglichkeit zum Opt-Out, die Daten werden aber niemals für andere Zwecke
            verwendet.</p>
            <h2 id="basis-des-legitimen-interesses">Basis des Legitimen
            Interesses</h2>
            <p>Die Datenverarbeitung basiert auf dem Prinzip des legitimen
            Interesses. Verarbeiten der Daten hilft uns, herauszufinden, was auf
            unserer Seite funktioniert und was nicht. Zum Beispiel finden wir damit
            heraus, ob wie Inhalte rezipiert werden oder wie wir die Struktur der
            Webseite verbessern können. Aufgrund der Datenverarbeitung profitieren
            Sie daher von einer Webseite, die laufend besser wird. Ohne diese Daten
            könnten wir den Service nicht bieten. Ihre Daten werden ausschließlich
            zum Verbessern der Webseitennutzung verwendet.</p>
            <h2 id="empfänger-der-daten">Empfänger der Daten</h2>
            <p>Die von Matomo erfassten anonymisierten und pseudonymisierten Daten
            werden ausschließlich an den Rat für Forschung, Wissenschaft, Innovation und
            Technologieentwicklung gesendet.</p>
            <h2 id="details-zum-transfer-in-drittstaaten">Details zum Transfer in
            Drittstaaten</h2>
            <p>Die Daten dieser Webseite und Matomo werden in Österreich gehostet.
            Die Daten verlassen nie die EU.</p>
            <h2 id="rechte-der-betroffenen-personen">Rechte der betroffenen
            Personen</h2>
            <p>Da Matomo Daten basierend auf legitimen Interesse sammelt, können Sie
            folgende Rechte ausüben:</p>
            <ul>
            <li>Recht auf Auskunft und Datenübertragbarkeit: Sie können jederzeit
            alle Ihre Daten anfordern.</li>
            <li>Recht auf Löschung und Berichtigung: Sie können jederzeit anfragen,
            dass wir alle Ihre Daten vollständig löschen.</li>
            </ul>
            <h2
            id="das-recht-eine-beschwerde-bei-der-datenschutzbehörde-einbringen">Das
            Recht, eine Beschwerde bei der Datenschutzbehörde einbringen</h2>
            <p>Wenn Sie denken, dass die Art, wie wir Daten mit Matomo verarbeiten,
            gegen das Gesetz verstößt, haben Sie das Recht eine Beschwerde bei der
            Datenschutzbehörde einzubringen.</p>
            <h2 id="verantwortlich-für-den-inhalt">Verantwortlich für den
            Inhalt</h2>
            <p>
                FORWIT<br/>
                Rat für Forschung, Wissenschaft, Innovation und Technologieentwicklung<br/>
                Pestalozzigasse 7/42<br/>
                1010 Wien<br/>
                <a href="mailto:fti-monitor@forwit.at">fti-monitor@forwit.at</a>
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