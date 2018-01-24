#!/bin/sh 

cd $1

for i in `find . -name "*.pdf" -type f`; do
if [ ! -f $(basename "$i" .pdf).svg ] 
then
inkscape --without-gui --file=$i --export-plain-svg=$(basename "$i" .pdf).svg
else
echo "$i diagram already exists in SVG format"
fi
done
