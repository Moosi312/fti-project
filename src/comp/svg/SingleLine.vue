<template>
    <div ref="container" class="single-lines-chart">
        <svg v-show="dataValues" class='single-lines-chart' ref='single-line-chart' :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='y-axis'></g>
                <g class='x-axis' :transform='`translate(0, ${height - margin.top - margin.bottom})`'></g>
                <g class="data"/>
                <g class='s'>
                    <circle/>
                    <text class="v"></text>
                    <text class="y"></text>
                </g>
                <rect :height='innerHeight' :width='width !== null ? innerWidth : 0' class='h' fill='#00000000'/>
            </g>
        </svg>
        <div v-show="dataValues" ref="legend" class="legend clearfix"></div>
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
    props: ['id', 'topic', 'group'],
    data: () => ({
        margin: {top: 20, right: 40, bottom: 40, left: 70},
        height: 150,
        width: undefined
    }),
    components: {
    },
    computed: {
        dataValues: function() { return this.$store.getters.seriesData(this.id); },
        innerWidth: function() { return this.width - this.margin.left - this.margin.right; },
        innerHeight: function() { return this.height - this.margin.top - this.margin.bottom; },
    },
    mounted() { this.doit() },
    watch: {
        id: {
            // immediate: true,
            handler (val) {
                this.doit();
            }
        },
        group: {
            // immediate: true,
            handler (val) {
                this.doit();
            }
        },
    },
    methods: {
        doit() {
            if (!this.dataValues)
                return;

            const nf = d3.format(",.0f")

            const svg = d3.select(this.$refs['single-line-chart']);
            const leg = d3.select(this.$refs['legend']);

            this.width = this.$refs.container.clientWidth
            svg.attr("width", this.width)

            // console.log(this.dataValues)
            const line = [this.group]
            // console.log(lines)
            const svgI = svg.select("g");
            let data = this.dataValues.map(d => ({
                year: d.year,
                value: 1/(d[line])*100,
            })).filter(e => e.year > 2012)

            // console.log(data)

            const years = [...new Set(data.map(d => d.year))];

            // Construct scales and axes.
            const xScale = d3.scaleLinear()
                .domain(d3.extent(data, d => d.year))
                .range([0, this.innerWidth]);

            const yMin = d3.min([...data, { value: 100 }], d => d.value)
            const yMax = d3.max([...data, { value: 100 }], d => d.value)

            const yScale = d3.scaleLinear()
                // .domain([0, 100])
                .domain([yMin, yMax])
                .range([this.innerHeight, 0]);

            let dataGrouped = data.reduce((groups, item) => {
                const group = (groups[item.group] || []);
                // delete item.id;
                group.push(item);
                groups[item.group] = group;
                return groups;
            }, {});

            const gp = svgI.select("g.data")

            gp.selectAll("*").remove()

            gp.append("line")
                .attr("x1", 0)
                .attr("x2", this.innerWidth)
                .attr("y1", yScale(100))
                .attr("y2", yScale(100))
                .attr("stroke", "#444")
                .attr("stroke-dasharray", "2 3")
            
            gp.append("text")
                .attr("x", -10)
                .attr("y", yScale(100))
                .attr("font-size", "0.8em")
                .attr("alignment-baseline", "central")
                .attr("text-anchor", "end")
                .text("100%")

            let vline = 100;
            if (100 - yMin > yMax - 100) {
                vline = Math.ceil(yMin/10)*10
            } else {
                vline = (Math.floor(yMax/10)*10)
            }
            
            gp.append("line")
            .attr("x1", 0)
            .attr("x2", this.innerWidth)
            .attr("y1", yScale(vline))
            .attr("y2", yScale(vline))
            .attr("stroke", "#AAA")
            .attr("stroke-dasharray", "2 3")
            
            gp.append("text")
                .attr("x", -10)
                .attr("y", yScale(vline))
                .attr("font-size", "0.8em")
                .attr("alignment-baseline", "central")
                .attr("text-anchor", "end")
                .text(`${nf(vline)}%`)

            gp.append("line")
                .attr("x1", 0)
                .attr("x2", 0)
                .attr("y1", yScale(yMin) + 20)
                .attr("y2", yScale(yMax))
                .attr("stroke", "#444")


            gp.selectAll("g")
                .data(Object.entries(dataGrouped))
                .enter()
                .append("g")
                .attr("class", d => `${d[0]}`)
                .call(d => d.append("path")
                    .attr("fill", "none")
                    .attr("stroke", "#AAA")
                    .attr("d", d => d3.line()
                        .x(d => xScale(d.year))
                        .y(d => yScale(d.value))
                        (d[1])
                    )
                )
                .call(d => d.selectAll("circle")
                    .data(d => d[1])
                    .enter()
                    .append("circle")
                    // .attr("class", d => `fill-${d.group}`)
                    .attr("class", (d) => `stroke-c${this.$store.getters.toColorNr(d.value)}`)
                    .attr("stroke-width", 3)
                    .attr("fill", "white")
                    .attr("r", 5)
                    .attr("cx", d => xScale(d.year))
                    .attr("cy", d => yScale(d.value))
                )



            svgI.select("rect.h").on('mousemove', (e, i) => {
                const tx = xScale.invert(d3.pointer(e)[0])
                const ty = yScale.invert(d3.pointer(e)[1])
                // console.log(t)
                const year = years[d3.bisectCenter(years, tx)]
                const dataYear = data.filter(d => d.year == year).sort((a, b) => a.value - b.value)
                const d = dataYear[d3.bisectCenter(dataYear.map(d => d.value), ty)]
                highlighEntry(d)
                

            }).on('mousenter', (e, i) => {

            }).on('mouseleave', (e, i) => {
                // svgI.select("g.s").style("visibility", "hidden")
                highlighEntry(null)
            })

            const highlighEntry = (d) => {
                if (!d) {
                    d = data[data.length - 1]
                }
                svgI.select("g.s").style("visibility", "visible")
                // console.log(d)
                svgI.select('g.s circle')
                    .attr("cx", xScale(d.year))
                    .attr("cy", yScale(d.value))
                    .attr("r", 18)
                    .attr("class", `stroke-c${this.$store.getters.toColorNr(d.value)}`)
                    .attr("stroke-width", 5)
                    .attr("fill", "white")

                svgI.select('g.s text.v')
                    .attr("transform", `translate(${xScale(d.year)}, ${yScale(d.value)})`)
                    .text(`${nf(d.value)}%`)
                    .attr("alignment-baseline", "central")
                    .attr("text-anchor", "middle")
                    .attr("font-size", "0.8em")
                    .attr("font-weight", "bold")

                
                svgI.select('g.s text.y')
                    .attr("transform", `translate(${xScale(d.year)}, ${yScale(d.value) + 30})`)
                    .text(`${d.year}`)
                    .attr("alignment-baseline", "central")
                    .attr("text-anchor", "middle")
                    .attr("font-size", "0.8em")
                // svgI.select('g.s text')
                //     .attr("transform", `translate(${xScale(d.year)}, ${yScale(d.value) - 15})`)
                //     .text(`${d.year}: ${nf(d.value)}%`)
                    // .text(`${names2Label[d.group]}: ${d.value}`)
            }
            highlighEntry(null)
        }
    }
}
</script>
