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

echo "-----------------------------------------------------------------"
echo "Depending on the number of images in your document it might take"
echo "some time to make the files. You might like to make a cup of tea!"
echo "-----------------------------------------------------------------"
echo "Checking lexers are compiled"
echo "============================="
cd scripts/flowfix/
make
cd ..
cd preambleExtractions
make
cd ../../$1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "-----------------------------------------------------------------"
echo "The name of the main LaTeX file found is: $name"
echo "-----------------------------------------------------------------"
echo "Making standard print format"
echo "============================="
make standard name=$name > .quickMake-standard.out
echo "-----------------------------------------------------------------"
echo "Making clear print format"
echo "============================="
make clear name=$name > .quickMake-clear.out
echo "-----------------------------------------------------------------"
echo "Making large print format"
echo "============================="
make large name=$name > .quickMake-large.out
echo "-----------------------------------------------------------------"
echo "Making accessible web format"
echo "============================="
make web name=$name > .quickMake-web.out
echo "-----------------------------------------------------------------"
echo "Making accessible word format"
echo "============================="
make word name=$name > .quickMake-word.out
make clean
make cleaner
echo "Look BACK - check for errors"
echo "============================="
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
echo "match in their immediate context. To help you fix brackets you" 
echo "should use match_parens on each of your original files. To run this"
echo "on a file called file.tex you would run:"
echo "> match_parens file.tex"
echo "on linux.bath.ac.uk. For help using match_parens see the documentation"
echo "at: http://mirrors.ctan.org/support/match_parens/match_parens.pdf"
echo "-----------------------------------------------------------------"
echo "If the web and word compilation still fails with an xtpipes error"
echo "You can try quickSloppyMake to see if that produces output. "
echo "If it does you can use it but you should check the document output"
echo "thoroughly yourself. You should also be aware that some content "
echo "will not be read aloud correctly - you should contact us for advice." 
echo "-----------------------------------------------------------------"
echo "If a format is missing or broken then contact "
echo "ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
