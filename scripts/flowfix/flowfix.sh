#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" -type f`; do
$home/bin/LPstage1 < $i > $(basename "$i" .tex)-lp1.tex
$home/bin/LPstage2 < $(basename "$i" .tex)-lp1.tex > $(basename "$i" .tex)-lp.tex
done
