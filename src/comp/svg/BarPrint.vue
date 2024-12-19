<template>
    <div ref="container">
        <div>
            Width: <input v-model="width">
            <select v-model="nr" >
                <option v-for="(d, id) in this.$store.getters.topics" >{{ d.nr }}</option>
            </select>
            <select v-model="scale" >
                <option>lin</option>
                <option>log</option>
            </select>
            <a id='download'>Download</a>
        </div>
        <svg id="svg" :height='height' :width='width'>
            <g class='x-axis'></g>
            <g class='inner' :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='x-100'><line stroke-width='0.25' stroke='black'/></g>
                <g class='bars'></g>
                <g class='circles'></g>
                <g class='y-axis' transform='translate(1, 0)'></g>
                <g class='x-0'><line stroke-width='0.5' stroke='black'/></g>
                <text class='il' font-weight="bold" text-anchor="middle" font-size="8">Innovation Leaders</text>
                <g class='arrow'>
                    <polygon points="0,0 -5,6 5,6" />
                </g>
            </g>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
    data: () => ({
        margin: {top: 20, right: 80, bottom: 40, left: 270},
        width: 595.3,
        height: 0,
        barHeight: 8,
        barSpace: 6,
        nr: 'A.1',
        scale: 'lin',
    }),
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
    },
    mounted() {
        this.svg = d3.select("svg")
        // this.svg.attr('font-family', 'TT Norms Pro')
        this.svg.attr('font-size', 7)
        this.plot()
    },
    methods: {
        plot: function() {
            this.topic = this.$store.getters.topicByNr(this.nr);

            const svgI = this.svg.select("g.inner")

            svgI.select('.bars').selectAll("*").remove();
            svgI.select('.circles').selectAll("circle").remove();

            let data = this.$store.getters.topicData(this.topic.id);
            console.log(data)

            const ids = [
                ...Object.keys(data.subtop).map(id => [...[id], ...data.subtop[id]]).flat()
            ];
            // const ids = data.values.map(d => d.id);
            // console.log(ids)
            const no_bold = Object.keys(data.subtop).length == data.values.length;

            const id2info = this.$store.state.data.labels;

            const id2label = Object.fromEntries(Object.entries(id2info).map(([k, e]) => [k, e.short]))
            const id2type = Object.fromEntries(Object.entries(id2info).map(([k, e]) => [k, e.io]))

            if (this.topic.id == 'D2')
                id2type['Uniabs_isced5_8'] = 'i'
            // console.log(this.topic.id)
            // console.log(id2type)

            this.innerHeight = ids.length * (this.barHeight + this.barSpace) - this.barSpace;
            this.height = this.innerHeight + this.margin.bottom + this.margin.top;

            const idx = Array.from(Array(ids.length).keys());

            const y = d3.scaleBand()
                .range([0, this.innerHeight])
                .domain(idx)
                // .domain(data.map((d) => d.label.substring(0, 35)))
                .paddingInner(6/14)
                .paddingOuter(0)

            const cutCount = 45;
            const idToLabel = id => {
                const l = id2label[id]
                if (l.length > cutCount)
                    return l.substring(0, cutCount - 3) + '...';
                return l;
            }

            // console.log(data)

            svgI.select('.y-axis').selectAll("text").remove();
            svgI.select('.y-axis').selectAll("text")
                .data(idx)
                .enter()
                .append("text")
                .text(d => idToLabel(ids[d]))
                .attr('y', d => y(d) + this.barHeight - 2)
                .attr('dx', -14)
                .attr('text-anchor', 'end')
                .attr('dominant-baseline', 'middle')
                .attr('font-weight', d => (ids[d] in data.subtop && !no_bold) ? 'bold' : 'normal' )


            svgI.select('.y-axis').selectAll("circle").remove();
            svgI.select('.y-axis').selectAll("circle")
                .data(idx.filter(i => id2type[ids[i]] != ""))
                .enter()
                .append("circle")
                .attr("fill", i => id2type[ids[i]] == 'i' ? "white" : "black")
                // .text(d => idToLabel(ids[d]))
                .attr('cy', d => y(d) + 5)
                .attr('cx', -7)
                .attr('r', 2)
                .attr('stroke', "black")

            svgI.select('.y-axis').selectAll("line").remove();
            svgI.select('.y-axis').selectAll(`line.group`)
                .data(Object.keys(data.subtop))
                .enter()
                .append("line")
                .attr('class', 'group')
                .attr('stroke', 'black')
                .attr('stroke-width', 1)
                .attr('x1', 0)
                .attr('x2', 0)
                .attr('y1', d => y(ids.indexOf(d)))
                .attr('y2', d => y(ids.indexOf(d) + data.subtop[d].length) + this.barHeight)



            let vc = `rel.inno`

            if (this.topic.id == 'C6')
                vc = `rel.us`

            data.values = data.values.map(d => ({
                id: d.id,
                year: d.year,
                value: d[vc]
            }))
            // console.log(data)
            let x = null;
            let xa = null;
            let compLine = null;
            if (this.scale == 'log') {
                data.values.forEach(d => {
                    d.useValue = d.value/100;
                });
                let domain = d3.extent([d3.min(data.values, d => d.useValue)*0.95, d3.max(data.values, d => d.useValue), 1, 0.75, 1/0.75]);
                x = d3.scaleLog()
                   .domain(domain)
                   .range([ 0, this.width - this.margin.left - this.margin.right]);

                compLine = 1;
                xa = d3.axisTop(x).tickValues([0.5, 0.8,1,1/0.8, 2].filter(i => i > domain[0] && i < domain[1])).tickFormat(i => i*100)

            } else {
                data.values.forEach(d => {
                    d.useValue = d.value;
                });

                x = d3.scaleLinear()
                   .domain([0, Math.max(d3.max(data.values, d => d.useValue), 110)])
                   .range([0, this.width - this.margin.left - this.margin.right]);

                compLine = 100;
                xa = d3.axisTop(x).ticks(4)
            }

            // const id2label = this.$store.state.data.labels;
            const id2value = Object.assign({}, ...data.values.map(d => ({[d.id]: d.value})));
            const id2useValue = Object.assign({}, ...data.values.map(d => ({[d.id]: d.useValue})));

            let cmpFkt = null;

            // svgI.select('.bars').selectAll("rect").remove();
            svgI.select('.bars').selectAll("rect")
                .data(idx.filter(d => !!id2useValue[ids[d]]))
                .enter()
                .append("rect")
                .attr("y", y)
                .attr("height", y.bandwidth())
                .attr("x", x(0))
                .attr("width", d => x(id2useValue[ids[d]]))
                .attr("fill", "#e2e3e3")

            const colors = {
                "c1": "#ea4b55", // rot
                "c2": "#f59036", // orange
                "c3": "#f9eb00", // gelb
                "c4": "#afd24b", // hellgruen
                "c5": "#3caf55", // gruen
            }

            // svgI.select('.circles').selectAll("circle").remove();
            svgI.select('.circles').selectAll("circle")
                .data(idx)
                .enter()
                .append("circle")
                .attr("cx", d => x(id2useValue[ids[d]]))
                .attr("cy", d => y(d) + y.bandwidth()/2)
                .attr("r", 4)
                .attr("fill", (d) => colors[`c${this.toColorNr(id2value[ids[d]])}`])

            const xScale = this.svg.select('.x-axis')
                .attr("transform", `translate(${this.margin.left}, ${this.margin.top})`)
                // .call(d3.axisBottom(x))
                .call(xa)

            this.svg.select('.x-axis')
                .attr('font-weight', 'bold')
                .attr('font-size', 8)
                .attr('font-family', null)
                .selectAll('line, path').remove()

            svgI.select('.x-100 line')
                .attr('x1', x(compLine))
                .attr('x2', x(compLine))
                .attr('y1', 0)
                .attr('y2', this.innerHeight + 2)


            svgI.select('text.il')
                .attr('x', x(compLine))
                .attr('y', this.innerHeight + 18)

            svgI.select('g.arrow')
                .attr('transform', `translate(${x(compLine)}, ${this.innerHeight + 2})`)

            const svg = document.getElementById('svg').outerHTML;
            const blob = new Blob([svg.toString()]);

            const element = document.getElementById('download');
            element.download = `${this.nr}.svg`;
            element.href = window.URL.createObjectURL(blob);
        }
    },
    watch: {
        // barHeight() { this.plot() },
        nr() { this.plot() },
        scale() { this.plot() },
        width() { this.plot() },
    }
}
</script>
