#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" -type f`; do
if [ $(basename "$i" .tex) != "master" ] && [ $(basename "$i" .tex) != "empty" ]  && [ $(basename "$i" .tex) != "empty-lp" ] && [ $(basename "$i" .tex) != "empty-lp1" ] && [ $(basename "$i" .tex) != "master-lp" ] && [ $(basename "$i" .tex) != "master-lp1" ];  
then
    $home/extract < $i > $(basename "$i" .tex)-cont.tex
    echo "Processing $i"
fi
done
