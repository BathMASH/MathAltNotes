#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" ! -name master*.tex ! -name macros*.tex ! -name empty*.tex ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" ! -name "choices.tex" -type f`; do
    $home/macro < $i > $(basename "$i" .tex)-co
    $home/extract < $(basename "$i" .tex)-co > $(basename "$i" .tex)-cont.tex
    echo "Processing $i"
done
