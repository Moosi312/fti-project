#!/bin/env bash
epsFiles=`cd eps && find *.eps`
#echo $epsFiles
for f in ${epsFiles}
do
    echo "Processing eps/$f file..."
    inkscape "eps/${f}" --export-type="svg" --export-filename="svg/${f%.eps}.svg"
    sed -i -E -e '/^   (width)|(height)=/d' svg/${f%.eps}.svg
done
