class COLOR {
    static GRAY = '#777';
    static GREEN = '#3caf55';
    static LIME = '#afd24b';
    static YELLOW = '#f9eb00';
    static ORANGE = '#f59036';
    static RED = '#ea4b55';
}

const availableArrows = {
    'D2': [
        'B1'
    ],
    'C4': [
        'B1',
        'B2',
        'D2',
    ],
}

const locations = {
    'B1': [710, 315],
    'B2': [843, 412],
    'D2': [360, 690],
    'C4': [1222, 213],
}

const color = {
    'B1': {
        'B1': COLOR.GRAY,
        'B2': COLOR.GRAY,
        'D2': COLOR.GRAY,
        'C4': COLOR.GRAY,
    },
    'B2': {
        'B1': COLOR.GRAY,
        'B2': COLOR.GRAY,
        'D2': COLOR.GRAY,
        'C4': COLOR.GRAY,
    },
    'D2': {
        'B1': COLOR.ORANGE,
        'B2': COLOR.GRAY,
        'D2': COLOR.GRAY,
        'C4': COLOR.GRAY,
    },
    'C4': {
        'B1': COLOR.LIME,
        'B2': COLOR.ORANGE,
        'D2': COLOR.ORANGE,
        'C4': COLOR.GRAY,
    },
}

// const color = {
//     'Uniabs_isced5_8': 'orange',
//     'MINT_Absolv_58': 'green',
//     'MINT_Absolv_68': 'orange',
//     'publications_10pct': 'orange',
// }

function getLocation(id) {
    return locations[id] ?? [0, 0];
}

function getColor(from, to) {
    return (color[from] ?? {})[to] ?? 'green';
}

export default function getConnectionArrows(ids) {
    if (!ids || !ids.length) {
        return [];
    }
    const id = ids[0];

    console.log(id, availableArrows);

    let connections = [];
    Object.entries(availableArrows).forEach(([from, to]) => {
        if (from === id) {
            connections = connections.concat(to.map(t => ({
                from: id,
                fromLoc: getLocation(id),
                to: t,
                toLoc: getLocation(t),
                color: getColor(id, t),
            })));
        }
        if (to.includes(id)) {
            connections.push({
                from: from,
                fromLoc: getLocation(from),
                to: id,
                toLoc: getLocation(id),
                color: getColor(from, id),
            });
        }
    })

    return connections;
}