<template>
    <div ref="container">
        <!-- {{ rel }} -->
        <svg class='bar-chart' ref="bar-chart" :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`'>
                <g class='x-100'></g>
                <g class='bars'></g>
                <g class='circles'></g>
                <g class='x-axis'></g>
                <g class='y-axis'></g>
                <g class='h'></g>
            </g>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
    props: ['indicator', 'options'],
    data: () => ({
        margin: {top: 40, right: 80, bottom: 50, left: 55},
        height: 800,
        innerHeight: 800,
        width: undefined,
        barHeight: 16,
        barSpace: 7,
        between: 15,
    }),
    components: {
    },
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
        data: function() { return this.$store.getters.indicatorData(this.indicator); },
        no_bold: function() { return Object.keys(this.data.subtop).length == this.data.values.length; },
        ids: function() { return [
            ...Object.keys(this.data.subtop).map(id => [...this.data.subtop[id]]).flat()
        ]},
        is_agg: function() {
            return d => (this.ids[d] in this.data.subtop && !this.no_bold)
        }
    },
    mounted() {
        this.width = this.$refs.container.clientWidth
        const svg = d3.select("svg.bar-chart")
        svg.attr("width", this.width)
        this.plot()
    },
    methods: {
        plot: function() {
            const self = this

            const svgI = d3.select(this.$refs["bar-chart"]).select("g")

            svgI.select('.bars').selectAll("*").remove();
            svgI.select('.circles').selectAll("circle").remove();

            const ids = this.ids

            const innerHeightBase = ids.length * (this.barHeight + this.barSpace) - this.barSpace;
            this.innerHeight = this.no_bold ? innerHeightBase : innerHeightBase + (Object.keys(this.data.subtop).length - 1) * this.between
            this.height = this.innerHeight + this.margin.bottom + this.margin.top;

            const idx = Array.from(Array(ids.length).keys());

            const y = d3.scaleBand()
                .range([0, innerHeightBase])
                .domain(idx)
                .paddingInner(6/14)
                .paddingOuter(0)

            let added = 0;
            const yy = idx.map(i => {
                let s = y(i);
                if (i > 0 && this.is_agg(i))
                    added += this.between;
                return s + added;
            })

            const cutCount = 45;
            const idToLabel = id => {
                const l = ids[id]
                if (l.length > cutCount)
                    return l.substring(0, cutCount - 3) + '...';
                return l;
            }

            svgI.select('.y-axis').selectAll("text").remove();
            svgI.select('.y-axis').selectAll("text")
                .data(idx)
                .enter()
                .append("text")
                .text(d => idToLabel(d))
                // .text(d => this.is_agg(d))
                .attr('y', d => yy[d] + 12)
                .attr('dx', -22)
                .attr('text-anchor', 'end')
                .attr('font-weight', d => this.is_agg(d) ? 'bold' : 'normal' )

            svgI.select('.y-axis').selectAll("line").remove();
            svgI.select('.y-axis').selectAll(`line.group`)
                .data(Object.keys(this.data.subtop))
                .enter()
                .append("line")
                .attr('class', 'group')
                .attr('stroke', 'black')
                .attr('stroke-width', 1)
                .attr('x1', 0)
                .attr('x2', 0)
                .attr('y1', d => yy[ids.indexOf(d)])
                .attr('y2', d => yy[ids.indexOf(d) + this.data.subtop[d].length] + 12.5)

          this.plotLevels(JSON.parse(JSON.stringify(this.data)), svgI, idx, yy, y, ids)
        },
        plotLevels: function(data, svgI, idx, yy, y, ids) {
            const self = this

            const vc = `rel.${this.options.group}`
            data.values = data.values.map(d => ({
                id: d.id,
                year: d.year,
                value: d[vc]
            }))
            
            let x = null;
            let xa = null;
            let compLine = null;
            if (this.options.scale == 'log') {
                data.values.forEach(d => {
                    d.useValue = d.value/100;
                });
                let domain = d3.extent([d3.min(data.values, d => d.useValue)*0.95, d3.max(data.values, d => d.useValue), 1, 0.75, 1/0.75]);
                x = d3.scaleLog()
                   .domain(domain)
                   .range([ 0, this.width - this.margin.left - this.margin.right]);

                compLine = 1;
                xa = d3.axisTop(x).tickValues([0.5, 0.8, 1, 1/0.8, 2].filter(i => i > domain[0] && i < domain[1])).tickFormat(i => i*100)

            } else {
                data.values.forEach(d => {
                    d.useValue = d.value;
                });
                x = d3.scaleLinear();

                x.domain([0, Math.max(d3.max(data.values, d => d.useValue), 110)])
                compLine = 100;

                x.range([ 0, this.width - this.margin.left - this.margin.right]);

                
                xa = d3.axisTop(x).ticks(5)
            }

            const id2value = Object.assign({}, ...data.values.map((d, i) => ({[i]: d.value})));
            const id2useValue = Object.assign({}, ...data.values.map((d, i) => ({[i]: d.useValue})));

            svgI.select('.s').attr("visibility", "hidden");

            
            svgI.select('.bars').selectAll("rect")
                .data(idx.filter(d => !!id2useValue[d]))
                .enter()
                .append("rect")
                .attr("y", d => yy[d])
                .attr("height", y.bandwidth())
                .attr("x", x(0))
                .attr("width", d => x(id2useValue[d]))
                .attr('class', d => this.is_agg(d) ? 'major' : 'minor')

            
            svgI.select('.circles').selectAll("circle")
                .data(idx)
                .enter()
                .append("circle")
                .attr("cx", d => x(id2useValue[d]))
                .attr("cy", d => yy[d] + y.bandwidth()/2)
                .attr("r", 7)
                .attr("class", d => `color-c${this.toColorNr(id2value[d])}`)
                .each(function(d) {
                    if (self.is_agg(d)) {
                        d3.select(this.parentNode).append('circle')
                            .attr("cx", x(id2useValue[d]))
                            .attr("cy", yy[d] + y.bandwidth()/2)
                            .attr("r", 4)
                            .style("fill", "white")
                    }
                })

            svgI.select('.x-axis')
                .call(xa)

            svgI.select('.x-axis')
                .attr('font-weight', 'bold')
                .attr('font-size', 8)
                .attr('font-family', null)
                .selectAll('line, path').remove()

            svgI.select('.x-100').selectAll("line").remove();

            svgI.select('.x-100')
                .append("line")
                .attr('x1', x(compLine))
                .attr('x2', x(compLine))
                .attr('y1', 0)
                .attr('y2', this.innerHeight)

            const s = svgI.select('.s')
            svgI.select('.h').selectAll("rect").remove();
            svgI.select('.h').selectAll(".bar")
                .data(idx)
                .enter()
                .append("rect")
                .attr("x", -this.margin.left)
                .attr("y", d => yy[d] - this.barHeight/2/2)
                .attr("width", this.width)
                .attr("opacity", 0)
                .style("cursor", "pointer")
                .attr("height", this.barHeight + 8)
                .on('mouseleave', (e, i) => {
                    s.attr("visibility", "hidden");
                    s.select('circle')
                        .attr("visibility", "hidden")
                })
                .on('mouseenter', (e, i) => {
                    const d = ids[i]
                    const uv = id2useValue[d];

                    if (uv == null)
                        return;

                    s.attr("visibility", "visible");

                    s.select('text')
                        .attr("transform", `translate(${x(uv) + 15}, ${yy[i] + y.bandwidth()/2 + 1})`)
                        .text(`${d3.format(".0f")(id2value[d])}%`)
                        .attr("text-anchor", uv < 0 ? "end" : "start")


                    let rs = s.select('rect')
                        .attr("x", x(0))
                        .attr("y", yy[i])
                        .attr("width", x(uv))
                        .attr("height", y.bandwidth())

                    s.select('circle')
                        .attr("cx", x(uv))
                        .attr("cy", yy[i] + y.bandwidth()/2)
                        .attr("r", 11)
                        .attr("class", `color-c${this.toColorNr(id2value[d])}`)
                        .attr("visibility", "visible")

                })
                .on('click', (e, i) => {
                    // console.log(`click: ${ids[i]}`)
                    self.$emit('modal', ids[i])
                })
        },
        plotChange: function(data, svgI, idx, yy, y, ids) {
            const self = this

            const t = this.$store.getters.minusData(this.options.time)
            // console.log(t)
            data.values.forEach(d => {
                d.value = null;
                if (d.id in t) {
                    // console.log(t[d.id])
                    d.value = t[d.id][this.options.group];
                }
            })


            // console.log(data)
            let x = null;
            let xa = null;
            let compLine = 0;

            data.values.forEach(d => {
                d.useValue = d.value;
            });
            x = d3.scaleLinear();
             console.log(data.values)
            const ta = data.values.map(d => d.useValue)
            ta.push(0)
            const extent = d3.extent(ta);
            const width = extent[1] - extent[0];
            x.domain([extent[0] - width*0.15, extent[1] + width*0.15])
            x.range([ 0, this.width - this.margin.left - this.margin.right]);

            
            xa = d3.axisTop(x).ticks(5)

            const id2value = Object.assign({}, ...data.values.map(d => ({[d.id]: d.value})));
            const id2useValue = Object.assign({}, ...data.values.map(d => ({[d.id]: d.useValue})));


            svgI.select('.s').attr("visibility", "hidden");
            //
            svgI.select('.bars').selectAll("*").remove();

            const correctRect = function(d, i, e, v) {
                // console.log(this)
                if (!v)
                    v = x(id2useValue[ids[d]])
                
                let w = v - x(0);

                d3.select(this)
                    .attr("x", w < 0 ? v : x(0))
                    .attr("width", Math.abs(w))
            }
            
            svgI.select('.bars').selectAll("rect")
                .data(idx.filter(d => id2useValue[ids[d]] != null))
                .enter()
                .append("rect")
                .attr("y", d => yy[d])
                .attr("height", y.bandwidth())
                .attr('class', d => this.is_agg(d) ? 'major' : 'minor')
                .each(correctRect)


            svgI.select('.bars').selectAll("text.wo")
                .data(idx.filter(d => id2useValue[ids[d]] == null))
                .enter()
                .append("text")
                .attr("class", "wo")
                .attr("x", 10)
                .attr("y", d => yy[d] + y.bandwidth()/2 + 4)
                .text('nicht verfügbar')


            svgI.select('.x-axis')
                .call(xa)

            svgI.select('.x-axis')
                .attr('font-weight', 'bold')
                .attr('font-size', 8)
                .attr('font-family', null)
                .selectAll('line, path').remove()

            svgI.select('.x-100').selectAll("line").remove();

            svgI.select('.x-100')
                .append("line")
                .attr('x1', x(compLine))
                .attr('x2', x(compLine))
                .attr('y1', 0)
                .attr('y2', this.innerHeight)
            

            const s = svgI.select('.s')
            svgI.select('.h').selectAll("rect").remove();
            svgI.select('.h').selectAll(".bar")
                .data(idx)
                .enter()
                .append("rect")
                .attr("x", -this.margin.left)
                .attr("y", d => yy[d] - this.barHeight/2/2)
                .attr("width", this.width)
                .attr("opacity", 0)
                .style("cursor", "pointer")
                .attr("height", this.barHeight + 8)
                .on('mouseleave', (e, i) => {
                    s.attr("visibility", "hidden");
                    s.select('circle')
                        .attr("visibility", "hidden")
                })
                .on('mouseenter', (e, i) => {
                    const d = ids[i]
                    const uv = id2useValue[d];

                    if (uv == null)
                        return;

                    s.attr("visibility", "visible");

                    s.select('text')
                        .attr("transform", `translate(${x(uv) + (uv < 0 ? -1 : 1) * 3 }, ${yy[i] + y.bandwidth()/2 + 2})`)
                        .text(`${d3.format("+.1f")(id2value[d])}%`)
                        .attr("text-anchor", uv < 0 ? "end" : "start")


                    let rs = s.select('rect')
                        // .attr("x", x(0))
                        .attr("y", yy[i])
                        // .attr("width", x(uv))
                        .attr("height", y.bandwidth())

                    correctRect.call(rs.node(), null, null, null, x(uv))

                    s.select('circle')
                        .attr("visibility", "hidden")
                })
                .on('click', (e, i) => {
                    // console.log(`click: ${ids[i]}`)
                    self.$emit('modal', ids[i])
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
