#!/bin/bash
usage() {
echo "Call getFiles first. This will produce a timestamped directory."
echo "Call $0 giving the timestamped directory as input."
echo "That is, if the new directory is called file-180129-1151"
echo "you would call $0 file-180129-1151"
echo "You can edit files in your directory and call quickMake again"
echo "However, we would recommend that you edit your originals"
echo "and then call getFiles again to get a new version."
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

make scripts/flowfix/
make scripts/preambleExtractions
cd $1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "The name of the main LaTeX file found is: $name"
make standard name=$name
make clean
make cleanlatex
make clear name=$name
make clean
make cleanlatex
make large name=$name
make clean
make cleanlatex
make web name=$name
make clean
make cleanlatex
make word name=$name
make clean
make cleanlatex
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find standard, clear, large, web and word formats."
echo "If you are compiling beamer slides then the clear and large print"
echo "will be identical (print slides on A4). You may also find that"
echo "your standard slides are the same depending on your font settings."
echo "If a format is missing or broken then contact ma-largeprintnotes@bath.ac.uk for help."
