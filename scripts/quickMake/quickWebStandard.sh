#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Call getFiles first. This will produce a timestamped directory."
echo "Call $0 giving the timestamped directory as input."
echo "That is, if the new directory is called file-180129-1151"
echo "you would call $0 file-180129-1151"
echo "-----------------------------------------------------------------"
echo "If you are trying to make alternative formats you should use"
echo "./quickMake or ./quickBeamerMake instead."
echo "The web standard format is only to be used to gain clean html"
echo "for further human processing."
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
echo "-----------------------------------------------------------------"
#echo "Add disclaimer?"
#echo "==============="
cd $1
#echo "Do you need to add the Bath Maths department disclaimer to the" 
#echo "file? [y/n then enter]"
#read decision
#if [ $decision == "y" ]; then
#    echo "bathmathsdisclaimer" > .disclaimer
#else
echo "" > .disclaimer
#fi
#echo "-----------------------------------------------------------------"
echo "Section breaking for web version"
echo "================================"
echo "It is recommended that the web version has each section on a new "
echo "page. For most documents this balances page load time (which "
echo "increases for each pieces of mathematics) and fragmentation of the"
echo "document. Please select your break level now:"
echo "[1] No breaks"
echo "[2] Break on section (chapter in report format)"
echo "[3] Break on subsection (section in report format)"
echo "Please input 1, 2 or 3 followed by enter:"
read level
if [ $level == "1" ]; then
    echo "1" > .level
elif [ $level == "2" ]; then
    echo "2" > .level
elif [ $level == "3" ]; then
    echo "3" > .level
else
    echo "You did not pick 1, 2 or 3. Using 2 as the default."
    echo "2" > .level
fi
cd ..
echo "-----------------------------------------------------------------"
echo "Checking lexers are compiled"
echo "============================="
cd scripts/flowfix/
make
cd ..
cd preambleExtractions
make
cd ..
cd dedollar
make
cd ..
cd graphicx
make
cd ..
cd vert
make
cd ../../
echo "-----------------------------------------------------------------"
echo "Non-directional delimiters"
echo "==================================="
./scripts/dedollar/dedollar.sh $1
./scripts/match_parens_ht/match_parens_ht.sh $1
./scripts/vert/vert.sh $1
echo "You should go away and fix the problems described above."
echo "Do you want to continue anyway? y for yes and n for no"
read decision
if [ $decision != "y" ]; then
    exit 1
fi
echo "-----------------------------------------------------------------"
echo "The rest of this process is automatic - though it can fail or"
echo "error for many reasons. Please leave it to run and then follow"
echo "instructions regarding errors or failure to produce output."
echo "-----------------------------------------------------------------"
echo "Depending on the number of images in your document it might take"
echo "some time to make the files. You might like to make a cup of tea!"
echo "-----------------------------------------------------------------"
cd $1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "-----------------------------------------------------------------"
echo "The name of the main LaTeX file found is: $name"
echo "-----------------------------------------------------------------"
echo "Making standard print format"
echo "============================="
make standard name=$name > .quickMake-standard.out
echo "-----------------------------------------------------------------"
echo "Making standard web format for human processing"
echo "==============================================="
make webstandard name=$name > .quickMake-web-standard.out
echo "-----------------------------------------------------------------"
make clean
make cleaner
echo "-----------------------------------------------------------------"
echo "The conversions are finished"
echo "============================="
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find standard and standard web formats."
echo "-----------------------------------------------------------------"
echo "If a format failed with error code 124 then the document could "
echo "not be compiled in the time limit. This usually means there was"
echo "an infinite loop. Contact ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "If there were segmentation faults during image conversion then one"
echo "or more of your images will be missing or faulty in the web and "
echo "word formats. There is probably not much we can do about this "
echo "without reproducing your original image in a different way but "
echo "please do contact ma-largeprintnotes@bath.ac.uk for advice."
echo "-----------------------------------------------------------------"
echo "If the standard web compilation failed with an xtpipes error"
echo "then the most usual reason is that you have delimiters which do not"
echo "match in their immediate context. You might have ignored a warning"
echo "about this earlier! If you did then you will find helpful files"
echo "called filename.parens and filename.pre-vert in the timestamped" 
echo "directory. If you did NOT see such a warning ask "
echo "ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "If a format is missing or broken then contact "
echo "ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "============================================================="
echo "Please scroll back, check for errors and read the above text."
echo "============================================================="
