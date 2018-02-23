#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Call $0 giving the main file of your LaTeX project as input."
echo "That is, if I would compile using pdflatex file.tex"
echo "you would call $0 file.tex"
echo "This will produce a timestamped directory on which you can"
echo "call quickMake"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
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
mkdir $home/../../$tmpname/figures/jpg/
mkdir $home/../../$tmpname/figures/svg/
cp $home/../../assets/makefile $home/../../$tmpname/
cp $home/../../assets/empty.tex $home/../../$tmpname/
cp $home/../../master/master.tex $home/../../$tmpname/
echo $home > $home/../../$tmpname/.home
dir=$(dirname "$1")
cd $dir
mkjobtexmf --jobname $name --destdir=files --copy --exclude-ext aux,log,toc --texopt="--shell-escape"
mv $name.fls $home/../../$tmpname/
if [ -d files ]; then
    cd files
    rm -r texmf
    for i in `find . -name "*.tex" -type f`; do
	mv $i $home/../../$tmpname/
    done
    for i in `find . -name "*.cls" -type f`; do
	mv $i $home/../../$tmpname/
	echo "Your project includes a class file $i. It is possible that the transformations will fail. Please ask ma-largeprintnotes@bath.ac.uk for help.";
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
    for i in `find . -name "*.jpg" -type f`; do
	mv $i $home/../../$tmpname/figures/jpg/
    done
    for i in `find . -name "*.svg" -type f`; do
	mv $i $home/../../$tmpname/figures/svg/
    done
    for i in `find . -type f`; do
	echo "-----------------------------------------------------------------"
	echo "I don't know what to do with $i. Please ask ma-largeprintnotes@bath.ac.uk";
	echo "for help if this seems to prevent the alternative formats compiling.";
	echo "-----------------------------------------------------------------"
    done
    cd ..
    rm -r files
    echo "-----------------------------------------------------------------"
    echo "-----------------------------------------------------------------"
    echo "This now have a timestamped directory. You can call: "
    echo "> ./quickMake directoryname"
    echo "or"
    echo "> ./quickBeamerMake directoryname"
    echo "You can also enter the directory and use make commands directly."
    echo "You can edit files in your directory and make again"
    echo "However, we would recommend that unless debugging you edit your"
    echo "originals and then call getFiles again to get a new version."
    echo "-----------------------------------------------------------------"
    echo "-----------------------------------------------------------------"

else
    echo "-----------------------------------------------------------------"
    echo "-----------------------------------------------------------------"
    echo "I was unable to extract the files used by $name.tex."
    echo "Make sure that this is the LaTeX file which contains the documentclass command."
    echo "Make sure that you can compile the document using pdflatex $name.tex"
    echo "If you don't know what is wrong contact ma-largeprintnotes@bath.ac.uk for help."
    echo "-----------------------------------------------------------------"
    echo "-----------------------------------------------------------------"
fi
