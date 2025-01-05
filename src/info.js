const base = require('./info.json');
const indicatorDocs = require('./docsForIndicator.json');

const topics = base.topics;
const areas = base.areas;
Object.values(areas).map(a => {
	a.topicIds = [];
	return a;
});
const targets = base.targets;

const topicsToTargets = {};
const topicIdByNr = {};

Object.keys(topics).forEach(k => {
    const topic = topics[k];
	topic.nr = `${k[0]}.${k[1]}`
	topicsToTargets[topic.nr] = [];
	topicIdByNr[topic.nr] = k;
	topic.id = k;
	if (!topic.comp)
		topic.comp = ['inno', 'top3', 'eu']
	if (!topic.mapDefault)
		topic.mapDefault = 'europe'
    areas[topic.nr.substring(0, 1)].topicIds.push(k)
});

const targetById = {};
targets.forEach(pt => {
	targetById[pt.nr] = pt;
	pt.children.forEach(ct => {
		ct.topics.forEach(topicId => { topicsToTargets[topics[topicId].nr].push(`${pt.nr}.${ct.nr}`)})
		ct.type = pt.type
		targetById[`${pt.nr}.${ct.nr}`] = ct;
	});
});

const colorClasses = [
    { id: 5, nr: 109.5},
    { id: 4, nr:  99.5},
    { id: 3, nr:  89.5},
    { id: 2, nr:  74.5},
    { id: 1, nr:   0.0},
];

const nameForCompareGroup = {
	inno: 'Innovation Leaders',
    top3:'Top 3',
    eu: 'EU-Durchschnitt',
    us: 'USA',
	cn: 'China',
	jp: 'Japan',
	kr: 'Südkorea',
}

const year = 2024

export default {
	year,
    topics,
	topicIdByNr,
    areas,
	targets,
	targetById,
	topicsToTargets,
    colorClasses,
	innovationLeaders: base.innovationLeaders,
	nameForCompareGroup,
	dev: false,
	indicatorDocs,
};
