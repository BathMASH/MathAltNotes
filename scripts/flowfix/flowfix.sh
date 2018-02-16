#!/bin/bash

home=$(dirname $(readlink -f $0))

$home/bin/LPstage0 < $1 > $(basename "$1" .tex)-lp0
$home/bin/LPstage1 < $(basename "$1" .tex)-lp0 > $(basename "$1" .tex)-lp1
$home/bin/LPstage2 < $(basename "$1" .tex)-lp1 > $(basename "$1" .tex)-lp.tex
