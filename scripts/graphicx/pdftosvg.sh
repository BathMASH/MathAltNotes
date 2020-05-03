#!/bin/sh 

cd $1

for i in `find . -name "*.pdf" -type f`; do
if [ ! -f $(basename "$i" .pdf).svg ] 
then
     if pdffonts $i | grep Custom; then
	echo "$i has custom fonts, converting using pdf2svg, all fonts will be vectorised";
	pdf2svg $i $(basename "$i" .pdf).svg
    else
	echo "$i has no custom fonts, converting using inkscape";
	inkscape --without-gui --file=$i --export-plain-svg=$(basename "$i" .pdf).svg
    fi
else
    echo "$i diagram already exists in SVG format"
fi
done
