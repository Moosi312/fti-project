<template>
    <div ref="container">
        <svg class='bar-chart'  id='system-bar-chart' :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='x-100'></g>
                <g class='bars'></g>

                <g class='barsPrev prev'></g>

                <g class='s'>
                    <rect class="value"/>
                    <rect class="valueP"/>
                    <text class="value"></text>
                    <text class="valueP"></text>
                    <text class="year"></text>
                    <text class="yearP"></text>
                </g>
                <g class='circles'></g>
                <g class='circlesPrev prev'></g>
                <g class='x-axis'></g>
                <g class='y-axis' :transform='`translate(-55, -6)`'></g>
                <g class='y-axis-lines'></g>
                <g class='areas'></g>
                <g class='icons'>
                    <g v-for='e in data.i' :key='e.id' :class='`icon${($store.state.highlightTopics.includes(e.nr) || hover == e.nr) ? " activated" : ""}`' :transform='`translate(${-65 + iconRadius}, ${y(e) - iconRadius + 1} )`'>
                        <circle :r="iconRadius" :cx="iconRadius" :cy="iconRadius"/>
                        <g :transform='`translate(${iconRadius - iconSize/2}, ${iconRadius - iconSize/2})`'>
                            <icon :id='e.icon' :height='`${iconSize}px`' :width='`${iconSize}px`'/>
                        </g>
                    </g>
                </g>
                <g class='h'></g>
            </g>

        </svg>

    </div>
</template>

<script>
import * as d3 from "d3";

import Icon from '../icon/Icon.vue';
import IconCircle from '../icon/IconCircle.vue';

export default {
    data: () => ({
        margin: {top: 20, right: 90, bottom: 60, left: 240},
        height: 800,
        width: undefined,
        iconSize: 28,
        iconRadius: 19,
        barHeight: 14,
        barSpace: 12,
        spacing: 0.8,
        groupSpace: 30,
        offsetTop: 20,
        y: null,
        data: { i: null },
        hover: null,
    }),
    components: {
        Icon, IconCircle
    },
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
        innerWidth: function() { return this.width - this.margin.left - this.margin.right; },
        // innerHeight: function() { return this.height - this.margin.top - this.margin.bottom; },
    },
    mounted() {
        this.width = this.$refs.container.clientWidth
        d3.select("#system-bar-chart").attr("width", this.width)
        this.plot()
    },
    methods: {
        plot: function() {
            const self = this;
            const svg = d3.select("#system-bar-chart")
            const svgI = svg.select("g")

            const ids = Object.keys(this.$store.getters.topics)

            const data = this.data.i = ids.map(x => {
                const t = this.$store.getters.topics[x];
                const d = this.$store.state.data.values[x];
                const c = t.comp[0];
                let n = t.name;
                
                if (c == 'us') {
                    // console.log(d)
                    n = `${n}*`
                }
                    

                return {
                    id: x, nr: t.nr, icon: t.icon,
                    area: t.area.code, label: n,
                    value: d[`rel.${c}`], year: d['year'],
                    valuePrev: d[`rel.inno.p`],
                    // valuePrev: d[`rel.${c}.p`],
                    yearPrev: d['year.p']
                }
            });

            

            const groupData = Object.assign({}, ...Object.keys(this.$store.state.info.areas).map((a, i) => ({[a]: {
                id: a,
                c: data.filter(d => d.area == a).length,
                i: i + 1,
                name: this.$store.state.info.areas[a].name,
            }})));

            let t = 0;
            for (const v of Object.values(groupData)) {
                v.o = t;
                t += v.c;
                //console.log(v)
            }

            const x = d3.scaleLinear()
                .domain([0, d3.max(data, d => d.value)])
                .range([0, this.innerWidth]);

            const barHeight = data.length * this.barHeight * 2 + (data.length - 1) * this.barHeight * this.spacing;
            const innerHeight = barHeight + Object.keys(groupData).length * this.groupSpace;
            this.height = innerHeight + this.margin.top + this.margin.bottom;

            const y = d3.scaleBand()
                .domain(data.map(e => e.id))
                .range([0, barHeight])
                .paddingInner(this.spacing)
                .paddingOuter(0)

            const groupOffset = g => groupData[g].i * this.groupSpace;

            const yg = this.y = e => y(e.id) + groupOffset(e.area) + this.offsetTop;


            svgI.select('.bars').selectAll("rect")
                .data(data)
                .enter()
                .append("rect")
                .attr("x", 0)
                .attr("y", d => yg(d) - this.barHeight)
                .attr("width", d => x(d.value))
                .attr("height", this.barHeight)


            svgI.select('.circles').selectAll("circle")
                .data(data)
                .enter()
                .append("circle")
                .attr("cx", d => x(d.value))
                .attr("cy", d => yg(d) - this.barHeight/2)
                .attr("r", this.barHeight/2)
                .attr("class", d => `color-c${this.toColorNr(d.value)}`)


            svgI.select('.barsPrev').selectAll("rect")
                .data(data.filter(d => typeof(d.valuePrev) == "number"))
                .enter()
                .append("rect")
                .attr("x", 0)
                .attr("y", d => yg(d))
                .attr("width", d => x(d.valuePrev))
                .attr("height", this.barHeight)


            svgI.select('.circlesPrev').selectAll("circle")
                .data(data.filter(d => typeof(d.valuePrev) == "number"))
                .enter()
                .append("circle")
                .attr("cx", d => x(d.valuePrev))
                .attr("cy", d => yg(d) + this.barHeight/2)
                .attr("r", this.barHeight/2)
                .attr("class", d => `color-b-c${this.toColorNr(d.valuePrev)}`)




            svgI.select('.x-axis')
                .call(d3.axisTop(x).ticks(5))

            svgI.select('.x-axis')
                .attr('font-weight', 'bold')
                .attr('font-size', 8)
                .attr('font-family', null)
                .selectAll('line, path').remove()

            svgI.select('.x-100').selectAll("line").remove();
            svgI.select('.x-100')
                .append("line")
                .attr('x1', x(100))
                .attr('x2', x(100))
                .attr('y1', this.offsetTop + this.groupSpace - this.barHeight - 25)
                .attr('y2', innerHeight +  this.offsetTop + this.barHeight/2)

            svgI.select('.y-axis').selectAll("text")
                .data(data)
                .enter()
                .append("text")
                .text(d => d.label.length < 32 ? d.label : d.label.slice(0, 32) + ".") //d.label)
                .attr('y', d => yg(d) + 12)
                .attr('text-anchor', 'end')


            // console.log(groupData)
            svgI.select('.areas').selectAll("text")
                .data(Object.values(groupData))
                .enter()
                .append("text")
                .text(d => d.name)
                .attr('y', d => groupOffset(d.id) + y.step() * d.o  + this.offsetTop - 25)
                .attr('text-anchor', 'start')
                .style('font-weight', 'bold')


            svgI.select('.y-axis-lines').selectAll("line.group")
                .data(Object.values(groupData))
                .enter()
                .append("line")
                .attr('class', 'group')
                .attr('stroke', 'black')
                .attr('stroke-width', 1)
                .attr('x1', 0)
                .attr('x2', 0)
                .attr('y1', d => groupOffset(d.id) + y.step() * d.o  + this.offsetTop - this.barHeight)
                .attr('y2', d => groupOffset(d.id) + y.step() * (d.o + d.c - 1)  + this.offsetTop + this.barHeight)



            svgI.select('.bars').selectAll("rect")
                .data(data)
                .enter()
                .append("rect")
                .attr("x", 0)
                .attr("y", d => yg(d) - this.barHeight)
                .attr("width", d => x(d.value))
                .attr("height", this.barHeight)

            svgI.select('.h').selectAll(".bar")
                .data(data)
                .enter()
                .append("rect")
                .attr("x", -this.margin.left)
                .attr("y", d => yg(d) - this.barHeight)
                .attr("height", this.barHeight *2)
                .attr("width", this.width)
                .attr("opacity", 0)
                .style("cursor", "pointer")
                .on('click', function(e, i) {
                    const d = d3.select(this).data()[0];
                    self.$router.push({name: 'topic', params: {nr: d.nr}})
                })
                .on('mouseenter', function(e, i) {
                    const d = d3.select(this).data()[0];
                    self.hover = d.nr;
                    self.$store.dispatch('highlightTargetsOfTopic', d.id)

                    const s = svgI.select('.s')
                    s.attr("visibility", "visible");

                    // .attr("cx", d => x(d.value))
                    // .attr("cy", d => yg(d) - this.barHeight/2)

                    s.select('text.value')
                        .attr("transform", `translate(${x(d.value) + 15}, ${yg(d) - self.barHeight/2})`)
                        .text(`${Math.round(d.value)}%`)

                    if (typeof(d.valuePrev) == "number") {
                        s.select('text.valueP')
                            .attr("transform", `translate(${x(d.valuePrev) + 15}, ${yg(d) + self.barHeight/2 + 3})`)
                            .text(`${Math.round(d.valuePrev)}%`)

                        s.select('text.yearP')
                            .attr("transform", `translate(5, ${yg(d) + self.barHeight/2 + 1})`)
                            // .style("font-weight", "normal")
                            .style("font-size", "10px")
                            .text(d.yearPrev)
                    } else {
                        s.select('text.valueP')
                            .attr("transform", `translate(${x(d.valuePrev) + 15}, ${yg(d) + self.barHeight/2 + 3})`)
                            .text("")

                        s.select('text.yearP')
                            .attr("transform", `translate(5, ${yg(d) + self.barHeight/2 + 1})`)
                            // .style("font-weight", "normal")
                            .style("font-size", "10px")
                            .text("")
                    }

                    s.select('text.year')
                        .attr("transform", `translate(5, ${yg(d) - self.barHeight/2 + 1})`)
                        // .style("font-weight", "normal")
                        .style("font-size", "10px")
                        .text(d.year)




                        // .attr("y", d => yg(d) - this.barHeight)
                        // .attr("width", d => x(d.value))
                        // .attr("height", this.barHeight)


                    s.select('rect.value')
                        .attr("x", 0)
                        .attr("y", yg(d) - self.barHeight)
                        .style("fill", "#b5b5b590")
                        .attr("width", x(d.value))
                        .attr("height", self.barHeight)

                    s.select('rect.valueP')
                        .attr("x", 0)
                        .attr("y", yg(d))
                        .style("fill", "#b5b5b550")
                        .attr("width", x(d.valuePrev))
                        .attr("height", self.barHeight)

                    // s.select('rect.valueP')
                    //     .attr("x", 0)
                    //     .attr("y", y(i))
                    //     .attr("width", x(id2useValue[d]))
                    //     .attr("height", y.bandwidth())
                    //
                    // s.select('circle')
                    //     .attr("cx", x(id2useValue[d]))
                    //     .attr("cy", y(i) + y.bandwidth()/2)
                    //     .attr("r", 11)
                    //     .attr("class", `color-c${this.toColorNr(id2value[d])}`)
                })
                .on('mouseleave', function(e, i) {
                    self.hover = null;
                    self.$store.dispatch('highlightTargetsOfTopic')
                })
        }
    },
    watch: {
        options: {
            handler (val, oldVal) {
                this.plot()
            }
        }
    }
}
</script>
