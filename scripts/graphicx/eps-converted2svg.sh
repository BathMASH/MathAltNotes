#!/bin/bash

cd $1

for i in `find . -name "*to.pdf" -type f`; do
cp $i ${i/-eps-converted-to/}
inkscape --without-gui --file=${i/-eps-converted-to/} --export-plain-svg=$(basename "${i/-eps-converted-to/}" .pdf).svg
done

