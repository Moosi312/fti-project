<template>
    <div ref="container">
        <svg class='pie-chart' ref="svg" :height='height' :width='width'>
            <g :transform='`translate(${width/2}, ${height/2})`'></g>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";
import { mapState } from 'vuex'

export default {
    props: ['target'],
    data: () => ({
        width: 0,
        height: 0,
        radius: 60,
    }),
    computed: {
        targetValue: function() { return Math.round(this.$store.getters.targetValues(this.target.id)); }
    },
    mounted() {
        this.width = this.$refs.container.clientWidth
        this.height = Math.min(this.width, 2.5 * this.radius)
        this.radius = this.height / 2.5

        const svg = d3.select(this.$refs["svg"])
            .attr("width", this.width)
            .attr("height", this.width)

        const svgI = svg.select("g")

        if (this.targetValue === undefined)
            return

        let value = this.targetValue;
        if (value == 0)
            value = 0.01;
        // const value = 0;

        const info = [
             {value: value, back: 'color-b1', fore: 'color-w'},
             {value: 100 - value, back: 'color-g2', fore: 'color-b1'}
        ];
        info.forEach(e => {
            let t = ""
            if (e.value >= 8)
                t = `${Math.round(e.value)}%`
            e.text = t
        });
        const pie = d3.pie()
            .sort(null)
            .value(d => d.value)

        const arcs = pie(info)

        const arcGen = d3.arc()
            .innerRadius(0)
            .outerRadius(this.radius)

        svgI
            .selectAll('slices')
            .data(arcs)
            .enter()
            .append('path')
            .attr('d', d => arcGen(d))
            .attr('class', d => d.data.back)
            .attr("stroke", "black")
            .style("stroke-width", "0px")

        if (value < 100) {
            const arcGenOuter = d3.arc()
                .innerRadius(this.radius + 10)
                .outerRadius(this.radius + 10)
            const arcOuter = arcGenOuter(arcs[1]).split(/[A-Z]/);
            svgI
                .append('path')
                .attr('d', "M" + arcOuter[1] + "A" + arcOuter[2])
                .attr("fill", "none")
                .attr("stroke", "black")
                .attr("marker-end", "url(#arrowheadPie)")
        }

        svgI
            .selectAll('slices')
            .data(arcs)
            .enter()
            .append('text')
            .text(d => d.data.text)
            .attr("transform", d => `translate(${d.data.value != 100 ? arcGen.centroid(d) : '0, 0'})`)
            .style("text-anchor", "middle")
            .style("dominant-baseline", "middle")
            .attr('class', d => d.data.fore)

    }
}
</script>
