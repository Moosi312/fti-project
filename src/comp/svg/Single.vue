<template>
    <div ref="container">
        <!-- {{ time }} -->
        <svg class='single-chart' :height='height' :width='width'>
            <g :transform='`translate(${margin.left}, ${margin.top})`' style="cursor: pointer">
                <g class='x-100'></g>
                <g class='bar'></g>
                <g class='circle'></g>
                <g class='x-axis'></g>
                <g class='y-axis'></g>
            </g>
        </svg>
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
    props: ['topic', 'group', 'small'],
    data: () => ({
        margin: {top: 20, right: 80, bottom: 20, left: 270},
        height: 65,
        width: undefined,
        barHeight: 15,
    }),
    components: {
    },
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
        colorClasses: function() { return this.$store.state.info.colorClasses; },
    },
    mounted() {
        this.plot()
    },
    methods: {
        plot() {
            const self = this;
            this.width = this.$refs.container.clientWidth
            if (this.width < 500) {
                this.margin.left = 100;
            }

            const svg = d3.select("svg.single-chart")
            svg.attr("width", this.width)

            const innerHeight = this.barHeight;

            const svgI = svg.select("g")
            svgI.on("click", () => {
                self.$emit('modal', self.topic.id)
            });

            const value = this.$store.getters.value(this.topic.id, `rel.${this.group}`);
            const label = 'Aggregiert';

            const x = d3.scaleLinear()
                .domain([0, Math.max(value, 110)])
                .range([ 0, this.width - this.margin.left - this.margin.right]);

            const y = d3.scaleBand()
                .range([ 0, innerHeight ])
                .domain([label])
                .padding(0);

            svgI.select('.bar').selectAll('*').remove()
            svgI.select('.bar')
                .append("rect")
                .attr("x", x(0))
                .attr("y", y(label))
                .attr("width", (d) => x(value))
                .attr("height", this.barHeight)
                .attr("fill", "url(#barGradient)")

            svgI.select('.circle').selectAll('*').remove()
            svgI.select('.circle')
                .append('circle')
                // .attr("class", "")
                .attr("cx", x(value))
                .attr("cy", y(label) + 8)
                .attr("r", 18)
                .attr("class", `color-c${this.toColorNr(value)}`)

            svgI.select('.circle')
                .append('text')
                // .attr("class", "")
                .attr("x", x(value))
                .attr("y", y(label) + 8)
                .text(`${Math.round(value)}%`)

            // svgI.select('.circle')
            //     .append('circle')
            //     .attr("class", "inner")
            //     .attr("cx", x(value))
            //     .attr("cy", y(label) + 8)
            //     .attr("r", 16)
            //     .attr("class", (d) => `color-c${this.toColorNr(value)}`)

            svgI.select('.x-axis').selectAll('*').remove()
            svgI.select('.x-axis')
                .attr("transform", `translate(0, ${innerHeight})`)
                .call(
                    d3.axisBottom(x)
                        .tickValues([0, 100])
                        .tickSizeOuter(0)
                        .tickSizeInner(0)
                        .tickPadding(18)
                )

            svgI.select('.x-100').selectAll('*').remove()
            const os = 14;
            svgI.select('.x-100')
                .append("line")
                .attr('x1', x(100))
                .attr('x2', x(100))
                .attr('y1', -os)
                .attr('y2', this.barHeight + os)

            svgI.select('.x-100')
                .append("line")
                .attr('x1', x(0))
                .attr('x2', x(0))
                .attr('y1', -os)
                .attr('y2', this.barHeight + os)

            svgI.select('.y-axis').selectAll('*').remove()
            svgI.select('.y-axis')
                .call(
                    d3.axisLeft(y)
                        .tickValues([label])
                        .tickSizeOuter(0)
                        .tickSizeInner(0)
                        .tickPadding(8)
                )

            svg.select('defs').remove()
            const svgDefs = svg.append("defs");
            const grad = svgDefs.append('linearGradient')
                .attr('id', 'barGradient')
                // .attr('x1', '0%')
                // .attr('x2', '100%')
                // .attr('y1', '0%')
                // .attr('y2', '100%');

            for (const e of [...this.colorClasses].reverse()) {
                // console.log(e.nr)
                grad.append('stop')
                    .attr('offset', `${e.nr/value}`)
                    .attr('class', `stop-c${e.id}`)
            }

            // // image data hackery based on http://bl.ocks.org/mbostock/048d21cf747371b11884f75ad896e5a5
            //     var image = ctx.createImageData(1, options.height);
            //     d3.range(options.height).forEach(function(i) {
            //         var c = d3.rgb(options.scale(scale.invert(i)));
            //         image.data[4*i] = c.r;
            //         image.data[4*i + 1] = c.g;
            //         image.data[4*i + 2] = c.b;
            //         image.data[4*i + 3] = 180;
            //     });
            //     ctx.putImageData(image, 0, 0);
        },
    },
    watch: {
        topic: {
            handler () {
                this.plot()
            }
        },
        group: {
            handler () {
                this.plot()
            }
        },
        time: {
            handler () {
                this.plot()
            }
        }
    }
}
</script>
