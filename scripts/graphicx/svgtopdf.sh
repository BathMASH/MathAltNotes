#!/bin/sh 

cd $1

for i in `find . -name "*.svg" -type f`; do
if [ ! -f $(basename "$i" .svg).pdf ] 
then
inkscape --without-gui --file=$i --export-pdf=$(basename "$i" .svg).pdf
else
echo "$i diagram already exists in PDF format"
fi
done
