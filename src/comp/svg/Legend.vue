<template>
    <div class="legend" ref="container">
        <svg class='legend' :width='width' :height='height'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'/>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";


export default {
    data: () => ({
        margin: {top: 8, right: 0, bottom: 30, left: 0},
        width: null,
        height: 50
    }),
    components: {
    },
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
        colorClasses: function() { return this.$store.state.info.colorClasses; },
    },
    mounted() {
        this.width = this.$refs.container.clientWidth
        const svg = d3.select("svg.legend");
        const svgI = svg.select("g");
        //
        //svg.attr("width", this.width)
        const mm = [65, 120];
        const x = d3.scaleLinear()
           .domain(mm)
           .range([ 0, this.width - this.margin.left - this.margin.right]);

        const data = this.colorClasses.map((d, i) => {
            let l = d.nr;
            if (i == this.colorClasses.length - 1)
                l = mm[0]

            let u = null;
            if (i == 0) {
                u = mm[1]
            } else {
                u = this.colorClasses[i - 1].nr;
            }

            return {
                i: [l, u],
                c: d.id
            }
        })

        // console.log(data)
        // //
        svgI.selectAll("path.c")
            .data(data)
            .enter()
            .append("path")
            .attr("fill", "none")
            .attr("class", d => `stroke-c${d.c}`)
            .attr("stroke-width", 5)
            .attr("d", d => d3.line().x(e => x(e)).y(0)(d.i))

        svgI.selectAll("text")
            .data(this.colorClasses)
            .enter()
            .append("text")
            .text(d => `${Math.round(d.nr)}`)
            .attr('x', d => x(d.nr))
            .attr('y', 20)
            .attr('text-anchor', "middle")


        svgI.selectAll("path.b")
            .data(this.colorClasses.filter(d => d.nr != 0))
            .enter()
            .append("path")
            .attr("fill", "none")
            .attr("class", "stroke-b1")
            .attr("stroke-width", 2)
            .attr("d", function(d) {
                return d3.line()
                .x(e => x(e))
                .y((e, i) => [5, -5][i])
                ([d.nr, d.nr])
            })

    }
}
</script>
