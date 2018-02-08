#!/bin/bash

cd $1

for file in `find . -maxdepth 1 -name "*w*-pics.pdf" -type f`; do
    echo "Processing $file";
    pdfcrop $file
    pdfseparate $(basename "$file" .pdf)-crop.pdf $(basename "$file" -pics.pdf)%dx.pdf

    declare -i new=0
    declare -i count=1
    for i in $( ls *x.pdf ); do
	mv $i ${i/$count\x/$new\x}
	count=$((count+1))
	new=$((new+1))
    done

    for i in $( ls *x.pdf ); do
	inkscape --without-gui --file=$i --export-plain-svg=$(basename "$i" .pdf).svg
    done

    rm *x.pdf
done
