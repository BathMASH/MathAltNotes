#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" -type f`; do
$home/bin/LPstage0 < $i > $(basename "$i" .tex)-lp0
$home/bin/LPstage1 < $(basename "$i" .tex)-lp0 > $(basename "$i" .tex)-lp1
$home/bin/LPstage2 < $(basename "$i" .tex)-lp1 > $(basename "$i" .tex)-lp.tex
done
