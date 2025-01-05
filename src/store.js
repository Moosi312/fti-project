import Vue from 'vue';
import Vuex from 'vuex';
import axios from 'axios';
import * as d3 from "d3";

Vue.use(Vuex)

import info from './info.js';

const prep = {
    labels: (d) => {
        // const labels = {}
        // Object.keys(d).forEach(e => {
        //     const v = d[e].short === null ? '???????????' : d[e].short
        //     labels[e] = v
        // });
        // // console.log(labels)
        // return labels;
        return d;
    },
    // topics: (d) => d,
    str: (d) => d,
    values: (d) => Object.assign({}, ...d.map((x) => ({[x.id]: x}))),
    minus: (d) => {
        const dn = {}
        for (const [key, value] of Object.entries(d)) {
            dn[key] = Object.assign({}, ...value.map((x) => ({[x.id]: x})))
        }
        // console.log(dn)
        return dn;
    },
    sdg: (d) => d,
    egd: (d) => d,
    countries: (d) => d,
    docs: (d) => d,
    wirkungsziele: (d) => d,
    worldmap: (d) => d,
    targetValues: d => { 
        const c = Object.entries(d).map(([k, d]) => {
            const t = d.filter(d => d.type == "a")
            return [k, t[t.length - 1].per]
        })
        return {
            current: Object.fromEntries(c),
            series: d,
        }
    },
    mapValues: d => d,
    series: {
        format: 'csv',
        prepare: d => {
            let t = d3.csvParse(d, (d) => {
                const e = {
                    id: d.id,
                    type: d.type,
                    year: +d.year,
                    value: +d.value //* (d.type == "a" ? 100 : 1)
                }
                for (const [key, value] of Object.entries(d)) {
                    if (key.startsWith("value.")) {
                        e[key.substring(6)] = +value //* (d.type == "a" ? 100 : 1)
                    }
                }
                return e;
            });

            let tt = t.reduce((groups, item) => {
                const group = (groups[item.id] || []);
                // delete item.id;
                group.push(item);
                groups[item.id] = group;
                return groups;
            }, {});
            return tt;
        }
    },
};

export const store = new Vuex.Store({
    state: {
        data: {},
        names: [],
        info: info,
        highlightTopics: [],
        highlightTargets: [],
        connectionArrows: [],
    },
    getters: {
        data: (s) => (id) => s.data[id],
        loaded: (s) => Object.keys(prep).filter(d => !s.names.includes(d)) == 0,
        value: (s) => (id, value = undefined) => value ? s.data.values[id][value] : s.data.values[id],
        seriesData: (s) => (id) => s.data.series[id],
        topicData: (s, g) => (topicId) => {
            const topics = s.data.str[topicId].wt
            const ids = new Set([...s.data.str[topicId].i, ...Object.keys(topics)])
            return {
                // direct: [],
                subtop: topics,
                values: [...ids].map(id => g.value(id)),
            };
        },

        minusData: (s, g) => (l) => s.data.minus[l],

        docs: (s) => (topicIds, type) => {
            // console.log(topicIds)
            const docs = s.data.docs.filter(e => e.type == type && topicIds.some(topicId => e.topicIds.includes(topicId)));
            // console.log(docs)
            docs.sort((a, b) => { 
                if (a.year != b.year)
                    return  b.year - a.year
                if (a.authors && b.authors && a.authors[0].short != b.authors[0].short)
                    return a.authors[0].short.localeCompare(b.authors[0].short);
                return a.name.localeCompare(b.name);
            })

            return docs.map(d => {
                d['fileUrl'] = `/docs/pdf/${d['file']}`;
                d['imgUrl'] = `/docs/img/${d['file'] + ".png"}`;
                return d;
            });
        },

        wirkungsziele: (s) => (topicId) => {
            const wz = s.data.wirkungsziele.filter(e => e.topicIds.includes(topicId))
            return wz.map(d => {
                if (!('url' in d))
                    d['url'] = `https://www.wirkungsmonitoring.gv.at/${d.year}-${d.org.short}-UG-${d.ug.nr}-W000${d.nr}.html`;
                return d;
            });
        },

        topics2sdg: (s) => {
            const t = {}
            s.data.sdg.forEach(e => {

            })
            return t;
        },

        sdg: s => (topicId) => s.data.sdg.filter(e => e.bereiche.includes(topicId)),
        egd: s => (topicId) => s.data.egd.filter(e => e.bereiche.includes(topicId)),

        isDev: (s) => s.info.dev,

        topics: (s) => s.info.topics,

        topic: (s, g) => (id) => {
            const t = g.topics[id]
            const a = t.nr.substring(0, 1);
            t.area = {
                code: a,
                name: s.info.areas[a].name
            }
            return t
        },

        getMdFile: (s, g) => (name) => {
            return `/md/${name}.md`;
        },
        topicByNr: (s, g) => (nr) => g.topic(s.info.topicIdByNr[nr]),

        target: (s) => (id) => {
            // console.log(id);
            const info = s.info.targetById[id];
            // console.log(id)
            // console.log(info)
            info.id = id
            info.parentName = s.info.targetById[id.substring(0, 1)].name;
            info.parentNameShort = s.info.targetById[id.substring(0, 1)].nameShort;
            return info;
        },

        targets: (s) => (type = undefined) => {
            if (type)
                return s.info.targets.filter(g => g.type == type)
            else
                return s.info.targets
        },

        targetValues: (s) => (id, type = "current") => s.data.targetValues[type][id],
        mapValues: (s) => (id) => s.data.mapValues[id],

        topCountries: (s, g) => (id, comp, count = 3) => {
            const d = [...g.mapValues(id)];
            d.sort((a, b) => b[`rel.${comp}`] - a[`rel.${comp}`])
            const top = [];
            while (top.length < 3) {
                const i = top.length + 1;
                const t = d.shift();
                const c = [t.iso2];
                while (t[`rel.${comp}`] == d[0][`rel.${comp}`])
                    c.push(d.shift().iso2)
                top.push(c)
            }
            // console.log(top)
            return top;
        },

        targetsForTopic: (s, g) => (topic, type = undefined) => {
            const ids = s.info.topicsToTargets[topic.nr];
            const targets = ids.map(id => g.target(id));

            // console.log(type)
            if (type)
                return targets.filter(g => g.type == type)
            
            return targets
        },

        toColorNr: s => v => {
            for (const e of  s.info.colorClasses) {
                if (v > e.nr)
                    return (e.id)
            }
        },
        nameForCompareGroup: s => g => s.info.nameForCompareGroup[g],

        topicIndicatorMap: (s) => () => {
            const map = new Map();
            Object.entries(s.data.str).forEach(topic => {
                const topicId = topic[0];
                topic[1]['i'].forEach(indic => {
                    if (!map.has(topicId)) {
                        map.set(topicId, []);
                    }
                    map.set(topicId, map.get(topicId).concat(indic));
                })
            })
            return map;
        },
        
        getShortname: (s) => (id) => (s.data.labels[id] ?? {})['short'] ?? '',
    },



    mutations: {
        loaded(state, content) {
            state.data[content.name] = content.data
            state.names = state.names.concat([content.name])
        },
        highlightTopics(state, highlight) {
            state.highlightTopics = highlight
        },
        highlightTargets(state, highlight) {
            state.highlightTargets = highlight
        },
        connectionArrows(state, connectionArrows) {
            state.connectionArrows = connectionArrows;
        }
    },
    actions: {
        init(context) {
            Object.keys(prep).forEach((d) => {
                let format = 'json';
                let prepare = d => d;
                if (prep[d].format != undefined)
                    format = prep[d].format;

                if(prep[d] instanceof Function) {
                    prepare = prep[d]
                } else if (prep[d].prepare) {
                    prepare = prep[d].prepare
                }
                axios
                    .get(`/data/${d}.${format}`)
                    .then(response => context.commit('loaded', {
                        name: d,
                        data: prepare(response.data)
                    }))
            });
        },
        highlightTopicsOfTarget(context, targetId = undefined) {
            let topicNrs = [];
            if (targetId) {
                const target = context.getters.target(targetId);
                topicNrs = target.topics.map(id => context.getters.topic(id).nr);
            }
            context.commit('highlightTopics', topicNrs);
        },
        highlightTargetsOfTopic(context, topicId = undefined) {
            let targetNrs = [];
            if (topicId) {
                const targets = context.getters.targetsForTopic(context.getters.topic(topicId));
                targetNrs = targets.map(t => t.id);
                // console.log(targetNrs)
            }
            context.commit('highlightTargets', targetNrs);
        },
        showConnectionArrowsOfTopic(context, topicId = undefined) {
            context.commit('connectionArrows', topicId);
        },
        clearHighlighted(context) {
            context.commit('highlightTopics', []);
            context.commit('highlightTargets', []);
        },
    }
})
