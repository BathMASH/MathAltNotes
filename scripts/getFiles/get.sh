#!/bin/bash

usage() {
echo "Call $0 giving the main file of your LaTeX project as input."
echo "That is, if I would compile using pdflatex file.tex"
echo "you would call $0 file.tex"
echo "This will produce a timestamped directory on which you can"
echo "call quickMake"
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

home=$(dirname $(readlink -f $0))
name=$(basename "$1" .tex)
tmpname="$(basename "$1" .tex)-`date +%y%m%d-%H%M`"
mkdir $home/../../$tmpname
mkdir $home/../../$tmpname/figures
mkdir $home/../../$tmpname/figures/latexpdf
mkdir $home/../../$tmpname/figures/latexpdfsvg
mkdir $home/../../$tmpname/figures/eps/
mkdir $home/../../$tmpname/figures/pdf/
mkdir $home/../../$tmpname/figures/png/
mkdir $home/../../$tmpname/figures/svg/
cp $home/../../assets/makefile $home/../../$tmpname/
cp $home/../../assets/empty.tex $home/../../$tmpname/
cp $home/../../master/master.tex $home/../../$tmpname/
echo $home > $home/../../$tmpname/.home
dir=$(dirname "$1")
cd $dir
mkjobtexmf --jobname $name --destdir=files --copy --exclude-ext aux,log,toc
mv $name.fls $home/../../$tmpname/
cd files
rm -r texmf
for i in `find . -name "*.tex" -type f`; do
mv $i $home/../../$tmpname/
done
for i in `find . -name "*.sty" -type f`; do
mv $i $home/../../$tmpname/
echo "Your project includes a style file $i. It is possible that the transformations will fail. Please ask ma-largeprintnotes@bath.ac.uk for help.";
done
for i in `find . -name "*_tex" -type f`; do
mv $i $home/../../$tmpname/
mv $(basename "$i" .pdf_tex).pdf $home/../../$tmpname/figures/latexpdf/
done
for i in `find . -name "*.eps" -type f`; do
mv $i $home/../../$tmpname/figures/eps/
done
for i in `find . -name "*-eps-converted-to.pdf" -type f`; do
rm $i
done
for i in `find . -name "*.pdf" -type f`; do
mv $i $home/../../$tmpname/figures/pdf/
done
for i in `find . -name "*.png" -type f`; do
mv $i $home/../../$tmpname/figures/png/
done
for i in `find . -name "*.svg" -type f`; do
mv $i $home/../../$tmpname/figures/svg/
done
for i in `find . -type f`; do
echo "I don't know what to do with $i. Please ask ma-largeprintnotes@bath.ac.uk for help.";
done
cd ..
rm -r files
