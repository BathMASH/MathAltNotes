#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" -type f`; do
if [ $(basename "$i" .tex) != "master" ] && [ $(basename "$i" .tex) != "empty" ]  && [ $(basename "$i" .tex) != "empty-lp" ] && [ $(basename "$i" .tex) != "empty-lp1" ];  then
$home/extract < $i > $(basename "$i" .tex)-cont.tex
echo "Processing $i"
fi
done
