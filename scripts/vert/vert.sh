#!/bin/bash

echo "Verticals including |, \|, \vert and \Vert without either \left "
echo "\right or size specified make our job harder and may lead to "
echo "output which is displayed or spoken incorrectly. "
echo "Without knowledge of the meaning of the context it is not possible"
echo "to completely fix this. We are about to process your files "
echo "syntactically. Your original files will be placed in *.pre-vert"
echo "and we will comment against all lines which contain verts."
echo "If you are warned that a file contains ambiguous verts you "
echo "should fix this by hand before continuing. If you do not "
echo "fix this then transformations may fail or they may proceed "
echo "but the output may be displayed or spoken incorrectly."

home=$(dirname $(readlink -f $0))
cd $1

echo "-----------------------------------------------------------------"

for i in `find . -maxdepth 1 -name "*.tex" ! -name master*.tex ! -name macros*.tex ! -name empty*.tex ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" ! -name "choices.tex" ! -name "*-cont-clean.tex" ! -name "*-cont-clean-lp.tex" -type f`; do
    echo "Processing: $i"
    $home/bin/vert1 < $i > $(basename "$i" .tex)-v1
    $home/bin/vert3 < $(basename "$i" .tex)-v1 > $(basename "$i" .tex)-v2
     if grep -c "syntactically ambiguous" $(basename "$i" .tex)-v2 &> /dev/null; then
	echo "$i contains ambiguous verticals"
	cp -n $i $(basename "$i" .tex).pre-vert
	mv $(basename "$i" .tex)-v2 $i
	rm $(basename "$i" .tex)-v1 
   else
	echo "$i does not contain ambiguous verticals - good for you"
	cp -n $i $(basename "$i" .tex).pre-vert
	mv $(basename "$i" .tex)-v2 $i
	rm $(basename "$i" .tex)-v1 
    fi
done
echo "-----------------------------------------------------------------"

