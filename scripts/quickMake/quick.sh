#!/bin/bash
usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Call getFiles first. This will produce a timestamped directory."
echo "Call $0 giving the timestamped directory as input."
echo "That is, if the new directory is called file-180129-1151"
echo "you would call $0 file-180129-1151"
echo "-----------------------------------------------------------------"
echo "If your LaTeX is a beamer slideshow we recommend that you use"
echo "quickBeamerMake instead."
echo "-----------------------------------------------------------------"
echo "You can edit files in your directory and call quickMake again"
echo "However, we would recommend that you edit your originals"
echo "and then call getFiles again to get a new version."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

cd scripts/flowfix/
make
cd ..
cd preambleExtractions
make
cd ../../$1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "The name of the main LaTeX file found is: $name"
make standard name=$name
make clear name=$name
make large name=$name
make web name=$name
make word name=$name
make clean
make cleaner
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find standard, clear, large, web and word formats."
echo "-----------------------------------------------------------------"
echo "If you are compiling beamer slides then the clear and large print"
echo "will be identical (print slides on A4). You may also find that"
echo "your standard slides are the same depending on your font settings."
echo "We recommend that you use quickBeamerMake for beamer!"
echo "-----------------------------------------------------------------"
echo "If the web and/or word compilation failed with an xtpipes error"
echo "then the most usual reason is that you have brackets which do not"
echo "match in their immediate context. You can try quickSloppyMake to"
echo "see if that produces output. If it does you can use this but some"
echo "content will not be read aloud correctly - you should contact us"
echo "for advice." 
echo "-----------------------------------------------------------------"
echo "If a format is missing or broken then contact "
echo "ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
