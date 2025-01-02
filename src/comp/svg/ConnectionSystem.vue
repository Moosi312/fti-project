<template>
    <svg class='overview'>
      <g class='overview-inner' style="opacity: 0.5">
<!--            &lt;!&ndash; Rahmenbedingung -> Effizienz &ndash;&gt;-->
<!--            <line x1="440" y1="380" x2="440" y2="585" class="arrows" marker-end="url(#arrowhead)"/>-->

<!--            &lt;!&ndash; Rahmenbedingung -> Kern &ndash;&gt;-->
<!--            <line x1="530" y1="270" x2="610" y2="320" class="arrows" marker-end="url(#arrowhead)"/>-->

<!--            &lt;!&ndash; Kern -> Effizienz &ndash;&gt;-->
<!--            <line x1="570" y1="514" x2="485" y2="596" class="arrows" marker-end="url(#arrowhead)"/>-->

<!--            &lt;!&ndash; Kern <-> Querschnitt &ndash;&gt;-->
<!--            <line x1="820" y1="330" x2="945" y2="292" class="arrows" marker-end="url(#arrowhead)" marker-start="url(#arrowhead)"/>-->

<!--            &lt;!&ndash; Rahmenbedingung <-> Querschnitt &ndash;&gt;-->
<!--            <line x1="590" y1="210" x2="900" y2="210" class="arrows" marker-end="url(#arrowhead)"/>-->

            <icon-circle-group transform='translate(440, 220)' :icons="{
                'A3': 330,
                'A1': 210,
                'A2':  90
            }" :radius="90" />

            <g class="group" transform='translate(440, 80)'>
                <text>FTI-RAHMENBEDINGUNGEN</text>
                <text>RESSOURCEN</text>
                <text>& ANREIZE</text>
            </g>

            <icon-circle-group transform='translate(440, 690)' :icons="{
                'D1':   0,
                'D2': 180,
            }" :radius="80" />

            <g class="group" transform='translate(440, 800)'>
                <text>WIRKUNG</text>
            </g>

            <icon-circle-group transform='translate(710, 455)' :icons="{
                'B1':   0 - 90,
                'B2':  72 - 90,
                'B3': 144 - 90,
                'B4': 216 - 90,
                'B5': 288 - 90,
            }" :radius="140" />

            <g class="group" transform='translate(710, 452)'>
                <text>FTI-KERNSYSTEM</text>
                <text>PRODUKTION</text>
                <text>VON WISSEN &</text>
                <text>INNOVATIONEN</text>
            </g>

            <icon-circle-group transform='translate(1105, 290)' :icons="{
                'C1':   0 - 90,
                'C4':  60 - 90,
                'C3': 120 - 90,
                'C2': 180 - 90,
                'C5': 240 - 90,
                'C6': 300 - 90,
            }" :radius="135" />

            <g class="group" transform='translate(1105, 80)'>
                <text>FTI-QUERSCHNITTSTHEMEN</text>
            </g>

            <!-- <g class="group green" transform='translate(1140, 510)'>
                <text>GRÜNE</text>
                <text>TRANSFORMATION</text>
            </g>

            <g class="group green" transform='translate(1156, 398)'>
                <path d="m 97.4519 18.7917 a 1 1 150 0 0 -67.5 -116.9134 l -112.83444 65.145 a 1 1 150 0 0 67.5 116.9134 z" stroke-width="7" fill="None"/>
            </g> -->

            <a href="https://ecto.forwit.at/" target="_blank">
                <g class="group green" transform='translate(1015, 560)' @click="">
                    <text>GRÜNE</text>
                    <text>PRODUKTPOTENTIALE</text>
                    <text>ECTO-DASHBOARD</text>
                    <g class="ecto" transform='translate(-45, 24)'>
                        <icon class="ecto" id='ECTO' height='90px' width='90px'/>
                    </g>
                    <line transform='translate(90, -65)' x1="0" y1="0" x2="0" y2="60"/>
                    <line transform='translate(-149, 10)' x1="0" y1="0" x2="45" y2="0"/>
                </g>
            </a>




            <defs>
                <marker id="arrowhead" markerWidth="4" markerHeight="4" refX="0" refY="2" orient="auto-start-reverse">
                    <polygon points="0 0, 4 2, 0 4" />
                </marker>
                <filter id="black-glow">
                    <feColorMatrix type="matrix" values=
                               "0 0 0 0   0
                                0 0 0 0   0
                                0 0 0 0   0
                                0 0 0 0.2 0"/>
                    <feGaussianBlur stdDeviation="4.5" result="coloredBlur"/>
                    <feMerge>
                        <feMergeNode in="coloredBlur"/>
                        <feMergeNode in="SourceGraphic"/>
                    </feMerge>
                </filter>
            </defs>
        </g>
      <g class='overview-inner'>
        <connection-arrows/>
      </g>
      <g class='overview-inner'>
        <conn-icon-circle-group transform='translate(440, 220)' :icons="{
                'A3': 330,
                'A1': 210,
                'A2':  90
            }" :radius="90" />

        <conn-icon-circle-group transform='translate(440, 690)' :icons="{
                'D1':   0,
                'D2': 180,
            }" :radius="80" />

        <conn-icon-circle-group transform='translate(710, 455)' :icons="{
                'B1':   0 - 90,
                'B2':  72 - 90,
                'B3': 144 - 90,
                'B4': 216 - 90,
                'B5': 288 - 90,
            }" :radius="140" />

        <conn-icon-circle-group transform='translate(1105, 290)' :icons="{
                'C1':   0 - 90,
                'C4':  60 - 90,
                'C3': 120 - 90,
                'C2': 180 - 90,
                'C5': 240 - 90,
                'C6': 300 - 90,
            }" :radius="135" />

        <defs>
          <marker id="arrowhead" markerWidth="4" markerHeight="4" refX="0" refY="2" orient="auto-start-reverse">
            <polygon points="0 0, 4 2, 0 4" />
          </marker>
          <filter id="black-glow">
            <feColorMatrix type="matrix" values=
                "0 0 0 0   0
                                0 0 0 0   0
                                0 0 0 0   0
                                0 0 0 0.2 0"/>
            <feGaussianBlur stdDeviation="4.5" result="coloredBlur"/>
            <feMerge>
              <feMergeNode in="coloredBlur"/>
              <feMergeNode in="SourceGraphic"/>
            </feMerge>
          </filter>
        </defs>
      </g>
    </svg>
</template>

<script>
import * as d3 from "d3";

import Icon from '../icon/Icon.vue';
import IconCircle from '../icon/IconCircle.vue';
import IconCircleGroup from '../icon/IconCircleGroup.vue';
import ConnIconCircleGroup from "../icon/ConnIconCircleGroup.vue";
import ConnectionArrows from "../icon/ConnectionArrows.vue";

export default {
    data: () => ({
    }),
    components: {
      ConnectionArrows,
      ConnIconCircleGroup,
        Icon, IconCircle, IconCircleGroup
    },
    mounted() {
        d3.select("svg.overview")
            .attr("viewBox", [250, 40, 1041, 800]);
    }

}
</script>
