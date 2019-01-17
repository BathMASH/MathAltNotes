#!/bin/bash

home=$(dirname $(readlink -f $0))

$home/bin/vert1 < $1 > $(basename "$1" .tex)-v1
$home/bin/vert2 < $(basename "$1" .tex)-v1 > $(basename "$1" .tex)-vert.tex
