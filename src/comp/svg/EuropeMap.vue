<template>
    <div ref="container" style="position: relative;">
        <svg class='europe-map' ref="europe-map" :height='height' :width='width'>
        </svg>
        <div class='europe-map-info' ref="europe-map-info" style="position: absolute; width: 200px;"></div>
    </div>
</template>

<script>
import * as d3 from "d3";
import * as d3_p from "d3-geo-projection";
import * as topojson from "topojson-client";


export default {
    props: ['topic', 'comp', 'type'],
    data: () => ({
        margin: {top: 20, right: 20, bottom: 20, left: 20},
        height: 400,
        width: null
    }),
    computed: {
        toColorNr: function() { return this.$store.getters.toColorNr; },
        mapValues: function() { return this.$store.getters.mapValues(this.topic.id); },
        countries: function() { return this.$store.state.data.countries; },
    },
    mounted() {
            this.plot();
    },
    methods: {
        getMap() {
            const data = topojson.feature(this.$store.state.data.worldmap, this.$store.state.data.worldmap.objects.countries);

            let ig = ["EU27_2020"]
            if (this.topic.id == "C6") {
                ig = ['SE', 'ES', 'SK', 'SI', 'RO', 'PT', 'PL', 'NL', 'LU', 'LT', 'LV', 'IT', 
                'IE', 'HU', 'GR', 'DE', 'FR', 'FI', 'EE', 'DK', 'CZ', 'CY', 'HR', 'BG', 'BE', 'AT', 'MT']
            }

            let projection = null;
            if (this.type == "europe") {
                ig.push("GL")
                const bbox = [
                    [  0, 34],
                    [ 40, 71],
                ];
                
                projection = d3.geoAzimuthalEqualArea()
                    .rotate([-10, -52])
                    // .scale(80)
                    // .center([54.5, 15.2])
                    // .translate([this.width / 2, this.height / 2]);
                    .fitSize([this.width, this.height], {
                        "type": "Polygon", "coordinates": [bbox.concat([bbox[0]])]
                    })
            } else {
                projection = d3_p.geoVanDerGrinten2()
                    .rotate([-9, 0])
                    .scale(100)
                    .center([0, 0])
                    .translate([this.width / 2 - 20, this.height / 2 + 45])
                    // .fitSize([this.width, this.height], data)
                    // .fitSize([this.width, this.height], {
                    //     "type": "Polygon", "coordinates": [[[-120, 80], [+120, 80], [+120, -0], [-120, -0]]]
                    // })
            }

            data.features = data.features.filter(d => !ig.includes(d.properties.iso_a2))

            const path = d3.geoPath()
                .projection(projection);

            return {data, path}
        },
        plot() {
            const self = this;
            this.width = this.$refs.container.clientWidth;

            const svg = d3.select(this.$refs['europe-map'])
            const info = d3.select(this.$refs['europe-map-info'])


            const {data, path} = this.getMap()
            
            // data.features.forEach((item, i) => {
            //     console.log(item.properties.iso_a2)
            // });
            
            let values = Object.fromEntries(this.mapValues.map(d => [d.iso2, d[`rel.${this.comp}`]]).filter(d => d[1]))
            values = Object.fromEntries(Object.entries(values).filter(([key, val]) => val >= 0));
            // console.log(values)

            svg.selectAll("path").remove()
            svg.selectAll("path")
                .data(data.features)
                .enter().append("path")
                .attr("data-iso2", d => d.properties.iso_a2)
                .attr("d", path)
                .attr("class", d => {
                    const iso2 = d.properties.iso_a2;
                    if (iso2 in values)
                        return `fill-c${this.toColorNr(values[iso2])}`
                    else
                        return 'fill-g2'
                })
                // .attr("fill", "#FFFFFF00")
                // .attr("fill", "none")
                // .attr("stroke", "#333")
                .attr("stroke", "#EEE")
                .attr("stroke-width", "0.8px")
                .on('mouseover', function(e, d) {
                    const iso2 = d.properties.iso_a2;
                    // console.log(iso2)
                    if (iso2 in values) {
                        const p = d3.pointer(e)
                        // console.log(p);

                        d3.select(this).transition()
                            .duration('50')
                            .attr('opacity', '.7');
                        info.html(`${self.countries[iso2]}: ${Math.round(values[iso2])} %`)
                            .style("visibility", 'visible')
                            .style("left", `${p[0] - 100}px`)
                            .style("top", `${p[1] - 30}px`);
                    }
                    // div.transition()
                    //      .duration(50)
                    //      .style("opacity", 1);
                    // let num = (Math.round((d.value / d.data.all) * 100)).toString() + '%';

                    //      .style("left", (d3.event.pageX + 10) + "px")
                    //      .style("top", (d3.event.pageY - 15) + "px");
                })
                .on('mouseout', function(e, d) {
                    d3.select(this).transition()
                        .duration('50')
                        .attr('opacity', '1');
                    info.style("visibility", 'hidden')
                    // div.transition()
                    //      .duration('50')
                    //      .style("opacity", 0);
                });
        }
    },
    watch: {
        topic: {
            // the callback will be called immediately after the start of the observation
            // immediate: true,
            handler () {
                // console.log(val)
                this.plot()
            }
        },
        comp: {
            // the callback will be called immediately after the start of the observation
            // immediate: true,
            handler () {
                // console.log(val)
                this.plot()
            }
        },
        type: {
            // the callback will be called immediately after the start of the observation
            // immediate: true,
            handler () {
                // console.log(val)
                this.plot()
            }
        }
    }
}
</script>
