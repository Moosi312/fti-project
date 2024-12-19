#!/usr/bin/env bash
cd "$(dirname "$0")/.."

(
    cd assets/docs
    mkdir md-pre
    IFS=$'\n'
    FOLDER='docx'
    files=`cd ${FOLDER}; find -type f -name '*.docx'`
    for f in ${files}
    do
        echo "Processing $f file..."
        pandoc -s ${FOLDER}/$f -t markdown -o "md-pre/${f%.*}.md"
    done
)

(
    Rscript scripts/_convertDocs/addSources.r
)