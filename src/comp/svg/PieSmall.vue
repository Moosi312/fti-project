<template>
    <svg ref="svg" class='pie-small-chart' :height='height' :width='width'>
        <g :transform='`translate(${width/2}, ${height/2})`'></g>
    </svg>
</template>

<script>
import * as d3 from "d3";

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
        this.width = 18;
        this.height = 18;
        this.radius = this.height / 3;

        const svg = d3.select(this.$refs.svg)
            .attr("width", this.width)
            .attr("height", this.width)

        const svgI = svg.select("g");

        if (this.targetValue === undefined)
            return

        let value = this.targetValue;
        if (value == 0)
            value = 0.01;
        // const value = 0;

        const info = [
             {value: value, class: 'pie-fg'},
             {value: 100 - value, class: 'pie-bg'}
        ];

        const pie = d3.pie()
            .sort(null)
            .value(d => d.value)

        const arcs = pie(info)

        const arcGen = d3.arc()
            .innerRadius(0)
            .outerRadius(this.radius)

        svgI
            .append('circle')
            .attr('r', this.radius)

        svgI
            .selectAll('slices')
            .data(arcs)
            .enter()
            .append('path')
            .attr('d', d => arcGen(d))
            .attr('class', d => d.data.class)
    }
}
</script>
