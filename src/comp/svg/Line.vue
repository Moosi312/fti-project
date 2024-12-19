<template>
    <div ref="container">
        <svg ref="line-chart" class='line-chart' :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='y-axis'></g>
                <g class='x-axis' :transform='`translate(0, ${height - margin.top - margin.bottom})`'></g>
                <g class='s'>
                    <circle/>
                    <text text-anchor="middle"></text>
                </g>
                <rect :height='innerHeight' :width='width !== null ? innerWidth : 0' class='h' fill='#00000000'/>
            </g>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
    props: ['target', 'type'],
    data: () => ({
        margin: {top: 30, right: 20, bottom: 50, left: 60},
        height: 320,
        width: null,
    }),
    components: {
    },
    computed: {
        targetValues: function() { return this.$store.getters.targetValues(this.target.id, "series"); },
        toColorNr: function() { return this.$store.getters.toColorNr; },
        colorClasses: function() { return this.$store.state.info.colorClasses; },
        innerWidth: function() { return this.width - this.margin.left - this.margin.right; },
        innerHeight: function() { return this.height - this.margin.top - this.margin.bottom; },
    },
    watch: {
        type: {
            // immediate: true,
            handler (val) {
                    this.doit();
            }
        },
        width: {
            // immediate: true,
            handler (val) {
                    this.doit();
            }
        },
    },
    mounted() { 
        this.doit();
    },
    methods: {
        doit() {
            const svg = d3.select(this.$refs["line-chart"]);
            this.width = this.$refs.container.clientWidth
            // console.log(this.width)
            svg.attr("width", this.width)

            const svgI = svg.select("g");
            let data = this.targetValues

            // Construct scales and axes.
            const xScale = d3.scaleLinear()
                .domain(d3.extent(data, d => d.year))
                .range([ 0, this.innerWidth]);

            let domain = [0, 100];
            let getValue = d => d.per;
            let getText = d => `${Math.round(d)} %`;

            if (this.type == 'v') {
                getValue = d => d.value;
                let min = 0;
                if (this.target.format == "r")
                    min = 1
                domain = [min, d3.max(data, getValue) * 1.1];
                getText = d => d < 5 ?  `${d3.format(".2~r")(d)}` : `${d3.format(".1~f")(d)}`;
            }

            const yScale = d3.scaleLinear()
                .domain(domain)
                // .domain(d3.extent(data, d => d.value))
                .range([this.innerHeight, 0]);
            
            const xAxis = d3.axisBottom(xScale)
                .tickFormat(n => n)
                .tickPadding(10)
                

                
            // if (data.length > 5) {
            //     xAxis.ticks(5)
            // } else {
            //     // console.log(d => d.year)
            //     xAxis.tickValues()
            // }
            const years = data.map(d => d.year)
            const tickStep = Math.ceil(years.length/7);
            xAxis.tickValues(years.filter((y, i) => i%tickStep == 0))

            // console.log(Math.min(data.length, 6))

            const yAxis = d3.axisLeft(yScale)
                .tickFormat(n => getText(n))
                .ticks(5)

            svgI.select("g.x-axis")
                .call(xAxis);

            svgI.select("g.y-axis")
                .call(yAxis)

            // console.log(data)

            const groups = data.reduce((groups, item) => {
                const group = (groups[item.type] || []);
                group.push(item);
                groups[item.type] = group;
                return groups;
            }, {});

            const lastA = groups.a.slice(-1)[0]
            // console.log(groups);
            if (groups.p)
                groups.p.unshift(lastA)


            svgI.select('g.paths').remove()
            svgI.append("g")
                .attr("class", "paths")
                .selectAll("path")
                .data(Object.entries(groups))
                .enter()
                .append("path")
                .attr("class", d => `type-${d[0]}`)
                .attr("d", d => d3.line()
                    .x(d => xScale(d.year))
                    .y(d => yScale(getValue(d)))
                    (d[1])
                )

            svgI.select('line.actual').remove()
            svgI.append("line")
                .attr("class", "actual")
                .attr("x1", xScale(lastA.year))
                .attr("x2", xScale(lastA.year))
                .attr("y1", this.innerHeight)
                .attr("y2", yScale(getValue(lastA)))
                .attr("stroke", "black")


            svgI.select('line.target').remove()
            if (this.type == "v")
                svgI.append("line")
                    .attr("class", "target")
                    .attr("x1", 0)
                    .attr("x2", this.innerWidth)
                    .attr("y1", yScale(lastA.target))
                    .attr("y2", yScale(lastA.target))
                    .attr("stroke", "black")
                    .attr("stroke-dasharray", "1 4")

            const h = d => {
                // svgI.select("g.s").style("visibility", "visible")
                // console.log(d)
                svgI.select('g.s circle')
                    .attr("cx", xScale(d.year))
                    .attr("cy", yScale(getValue(d)))
                    .attr("r", 5)

                svgI.select('g.s text')
                    .attr("transform", `translate(${xScale(d.year)}, ${yScale(getValue(d)) - 15})`)
                    .text(getText(getValue(d)))
            }

            svgI.select("rect.h").on('mousemove', (e, i) => {
                const t = xScale.invert(d3.pointer(e)[0])
                // console.log(t)
                const d = data[d3.bisectCenter(data.map(d => d.year), t)]
                h(d)
            }).on('mousenter', (e, i) => {

            }).on('mouseleave', (e, i) => {
                h(lastA)
                // svgI.select("g.s").style("visibility", "hidden")
            })

            h(lastA)
        }
    }
}
</script>
