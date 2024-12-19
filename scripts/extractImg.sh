#!/usr/bin/env bash
cd "$(dirname "$0")/.."

(
    cd assets/docs
    IFS=$'\n'
    pdfFiles=`find ./pdf -type f -name '*.pdf'`
    #echo $epsFiles
    for f in ${pdfFiles}
    do
        echo "Processing $f file..."
        pdftoppm $f $f -png -singlefile -r 10
    done
    mv ./pdf/*.png ./img
)