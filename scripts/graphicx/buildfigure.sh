#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: ./buildfigures.sh dir
    echo Run $0 help for help
    exit 1
fi

if [ $1 = "help" ]; then
    echo 'Place the .pdf_tex files in the homework directory'
    echo 'Place the .pdf files in the homework/figures/latexpdf/ directory'
    echo 'Then run ./buildfigures.sh ./'
    echo 'Then you can run make web name=file-name-without-.tex'
    exit 1
fi

cd $1

for file in `find . -maxdepth 1 -name "*_tex" -type f`; do
output=$(basename $file .pdf_tex).svg
cp $file $file-lp
sed -i 's/width=\\unitlength/width=\\textwidth,height=\\textheight,keepaspectratio/g' $file-lp

make pdflatexfigures name=$file
mv built/$file-figures.pdf figures/latexpdfsvg/
cd figures/latexpdfsvg/
pdfcrop $file-figures.pdf
inkscape --without-gui --file=$file-figures-crop.pdf --export-plain-svg=$output
cd ../..
grep iftoggle $file || (sed -i "1 i\\\\\iftoggle{web}{\\\includegraphics{$output}}{" $file; sed -i -e '$a\}\' $file)
done
