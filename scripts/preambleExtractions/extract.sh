#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" ! -name master*.tex ! -name macros*.tex ! -name empty*.tex ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" ! -name "choices.tex" -type f`; do
    echo "\n" >> $i
    $home/macro < $i > $(basename "$i" .tex)-co
    $home/extract < $(basename "$i" .tex)-co > $(basename "$i" .tex)-cont.tex
    echo "Processing $i"
done

for i in `find . -maxdepth 1 -name "*.pdf_tex" -type f`; do
#    cp $i $i-cont.tex
#We need to do this because de-macro expects all inputs to end in .tex 
    cp $i $i.tex
#    $home/macro < $i > $i-co
#    $home/extract < $i > $i-cont.tex
    echo "Processing $i"
done

