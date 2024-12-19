<template>
    <div ref="container" class="lines-chart">
        <!-- {{ settings }} -->
        <!-- {{ this.$refs.container.clientWidth }} -->
        <svg v-show="dataValues" class='lines-chart' :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='y-axis'></g>
                <g class='x-axis' :transform='`translate(0, ${height - margin.top - margin.bottom})`'></g>
                <g class="data"/>
                <g class='s'>
                    <circle/>
                    <text text-anchor="middle"></text>
                </g>
                <rect :height='innerHeight' :width='width !== null ? innerWidth : 0' class='h' fill='#00000000'/>
            </g>
        </svg>
        <div v-show="dataValues" ref="legend" class="legend clearfix">
        </div>
    </div>
</template>

<script>
import * as d3 from "d3";

const names2Label = {
    value: "Österreich",
    top3: "Top 3",
    eu: 'EU-Durchschnitt',
    inno: "Innovation Leaders",
    // il_old: "Innovation Leaders (ALT)",
    us: 'USA',
	cn: 'China',
	jp: 'Japan',
	kr: 'Südkorea',
}

const names2LabelShort = {
    value: "AT",
    top3: "Top 3",
    eu: "EU",
    inno: "IL",
    // il_old: "Innovation Leaders (ALT)",
    us: 'US',
	cn: 'CN',
	jp: 'JP',
	kr: 'KR',
}
export default {
    props: ['id', 'width', 'topic', 'settings'],
    data: () => ({
        margin: {top: 2, right: 70, bottom: 50, left: 70},
        height: 300
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
        settings: {
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
    methods: {
        doit() {
            if (!this.dataValues || !this.width)
                return;
            const nf = d3.format(",.3r")

            const svg = d3.select(".lines-chart svg.lines-chart");
            const leg = d3.select(".lines-chart div.legend");

            // this.width = this.$refs.container.clientWidth
            // this.width = 600;
            // console.log(this.$refs.container.clientWidth)
            svg.attr("width", this.width)

            // console.log(this.dataValues)
            const lines = ["value", ...this.topic.comp]
            // console.log(lines)
            const svgI = svg.select("g");
            let data = this.dataValues.reduce((d, r) => {
                let f = 1
                if (r.type == 'a') {
                    // console.log(this.settings.compGroup)
                    // console.log(r)
                    f = 1/r[this.settings.compGroup]*100
                }
                for (const a of lines)
                    d.push({
                        year: r.year,
                        value: r[a]*f,
                        group: a,
                    })
                return d;
            }, [])
            data = data.filter(e => Number.isFinite(e.value))

            names2Label['value'] = "Österreich"
            names2LabelShort['value'] = "AT"

            if (this.topic.id == "C6") {
                names2Label['value'] = "EU27"
                names2LabelShort['value'] = "EU"
            }

            // console.log(data)

            const years = [...new Set(data.map(d => d.year))];

            // Construct scales and axes.
            const xScale = d3.scaleLinear()
                .domain(d3.extent(data, d => d.year))
                .range([0, this.innerWidth]);

            const yScale = d3.scaleLinear()
                // .domain([0, 100])
                .domain([0, d3.max(data, d => d.value)*1.1])
                .range([this.innerHeight, 0]);

            const xAxis = d3.axisBottom(xScale)
                .tickFormat(n => n)
                .tickPadding(10)
                // .ticks(years.length < 6 ? years.length : years.length/2)
                // .ticks(Math.min(data.length, 6))
            const tickStep = Math.ceil(years.length/7);
            xAxis.tickValues(years.filter((y, i) => i%tickStep == 0))

            const yAxis = d3.axisLeft(yScale)
                .tickFormat(n => nf(n))
                .ticks(5)

            svgI.select("g.x-axis")
                .call(xAxis);

            svgI.select("g.y-axis")
                .call(yAxis)

            let dataGrouped = data.reduce((groups, item) => {
                const group = (groups[item.group] || []);
                // delete item.id;
                group.push(item);
                groups[item.group] = group;
                return groups;
            }, {});

            const gp = svgI.select("g.data")

            const strokeDasharray = {
                value: "1 0", 

                inno:  "3 2", 
                eu:    "1 0", 
                top3:  "3 2",

                us:    "3 2", 
                cn:    "1 0", 
                jp:    "3 2", 
                kr:    "2 1",
            }

            gp.selectAll("*").remove()
            gp.selectAll("g")
                .data(Object.entries(dataGrouped))
                .enter()
                .append("g")
                .attr("class", d => `${d[0]}`)
                .call(d => d.append("path")
                    .attr("class", d => `stroke-${d[0]}`)
                    .attr("fill", "none")
                    .attr("stroke-dasharray", d => strokeDasharray[d[0]])
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
                    .attr("class", d => `fill-${d.group}`)
                    .attr("r", 3)
                    .attr("cx", d => xScale(d.year))
                    .attr("cy", d => yScale(d.value))
                )

            leg.selectAll("*").remove()
            leg.selectAll("div")
                .data(Object.entries(dataGrouped))
                .enter()
                .append("div")
                .attr("class", d => `${d[0]}`)
                .call(d => d.append("svg")
                    .attr("width", 14).attr("height", 13)
                    .append("line")
                    .attr("x1", 0).attr("x2", 14).attr("y1", 5).attr("y2", 5)
                    .attr("class", d => `stroke-${d[0]}`)
                    .attr("stroke-width", 4)
                    .attr("stroke-dasharray", d => strokeDasharray[d[0]])
                )
                .call(d => d.append("span")
                    .text(d => `${names2Label[d[0]]}`)
                )

            


            svgI.select("rect.h").on('mousemove', (e, i) => {
                const tx = xScale.invert(d3.pointer(e)[0])
                const ty = yScale.invert(d3.pointer(e)[1])
                // console.log(t)
                const year = years[d3.bisectCenter(years, tx)]
                const dataYear = data.filter(d => d.year == year).sort((a, b) => a.value - b.value)
                const d = dataYear[d3.bisectCenter(dataYear.map(d => d.value), ty)]

                svgI.select("g.s").style("visibility", "visible")
                // console.log(d)
                svgI.select('g.s circle')
                    .attr("cx", xScale(d.year))
                    .attr("cy", yScale(d.value))
                    .attr("r", 4)
                    .attr("class", `fill-${d.group}`)

                svgI.select('g.s text')
                    .attr("transform", `translate(${xScale(d.year)}, ${yScale(d.value) - 15})`)
                    .text(`${names2LabelShort[d.group]}: ${nf(d.value)}`)
                    // .text(`${names2Label[d.group]}: ${d.value}`)

            }).on('mousenter', (e, i) => {

            }).on('mouseleave', (e, i) => {
                svgI.select("g.s").style("visibility", "hidden")
            })
        }
    }
}
</script>
