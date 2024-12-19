#!/usr/bin/env node

const fs = require('fs');

const docsJsonFile = 'assets/data/docs.json';
const docsFolder = 'assets/docs/pdf';

fs.readFile(docsJsonFile, 'utf8', (err, jsonString) => {
    if (err) {
        console.error("Failed to read file", err);
        return;
    }
    try {
        const data = JSON.parse(jsonString);
        filePaths = data.map(e => e.file);
        filePaths.forEach((filePath) => {
            fs.access(`${docsFolder}/${filePath}`, fs.constants.F_OK, (err) => {
                if (err) {
                    console.log(`${filePath} does not exist`);
                } else {
                    // console.log(`${filePath} exists`);
                }
            });
        });

    } catch(err) {
        console.error("Failed to parse JSON string:", err);
    }
});


