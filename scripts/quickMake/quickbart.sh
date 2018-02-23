#!/bin/bash
usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Call getFiles first. This will produce a timestamped directory."
echo "Call $0 giving the timestamped directory as input."
echo "That is, if the new directory is called file-180129-1151"
echo "you would call $0 file-180129-1151"
echo "You can edit files in your directory and call ./quickMake again"
echo "However, we would recommend that you edit your originals"
echo "and then call getFiles again to get a new version."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

echo "By-hand: Non-directional delimiters"
echo "==================================="
./scripts/vert/vert.sh $1
echo "-----------------------------------------------------------------"
echo "The rest of this process is automatic - though it can fail or"
echo "error for many reasons. Please leave it to run and then follow"
echo "instructions regarding errors or failure to produce output."
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
make clearbart name=$name > .quickMake-clearbart.out
echo "-----------------------------------------------------------------"
echo "Making large print format"
echo "============================="
make largebart name=$name > .quickMake-largebart.out
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
echo "The conversions are finished"
echo "============================="
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find standard, clear, large, web and word formats."
echo "-----------------------------------------------------------------"
echo "Note that the clear, large, web and word formats are based on "
echo "a handout or article version of your Beamer slides."
echo "-----------------------------------------------------------------"
echo "If there were segmentation faults during image conversion then one"
echo "or more of your images will be missing or faulty in the web and "
echo "word formats. There is probably not much we can do about this "
echo "without reproducing your original image in a different way but "
echo "please do contact ma-largeprintnotes@bath.ac.uk for advice."
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
echo "You can try ./quickSloppyMake to see if that produces output. "
echo "If it does you can use it but you should check the document output"
echo "thoroughly yourself. You should also be aware that some content "
echo "will not be read aloud correctly - you should contact us for advice." 
echo "-----------------------------------------------------------------"
echo "If a format is missing or broken then contact "
echo "ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "============================================================="
echo "Please scroll back, check for errors and read the above text."
echo "============================================================="
