#!/bin/bash

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*-cont.tex" -type f`; do
    cp $i $i.tmp
    $home/swaptopdf < $i.tmp > $i
    rm $i.tmp
    echo "Processing $i"
done

