#!/bin/bash

cd $1

for i in `find . -maxdepth 1 -name "*.tex" -type f`; do
./scripts/flowfix/bin/LPstage1 < $i > $(basename "$i" .tex)-lp1.tex
./scripts/flowfix/bin/LPstage2 < $(basename "$i" .tex)-lp1.tex > $(basename "$i" .tex)-lp.tex
done
