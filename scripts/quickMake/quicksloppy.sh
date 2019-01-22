#!/bin/bash
usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Only call this if ./quickMake resulted in an xtpipes error!"
echo "Ideally you should check your delimiter matching first!"
echo "See the output from ./quickMake!"
echo "In some cases $0 will result in immediately usable files however"
echo "they are broken in ways you CANNOT SEE! So you should also"
echo "contact us for advice on ma-largeprintnotes@bath.ac.uk "
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Add disclaimer?"
echo "==============="
cd $1
echo "Do you need to add the Bath Maths department disclaimer to the" 
echo "file? [y/n then enter]"
read decision
if [ $decision == "y" ]; then
    echo "bathmathsdisclaimer" > .disclaimer
else
    echo "" > .disclaimer
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
echo "Since you have chosen to make sloppy versions of web and word we"
echo "assume you have a delimiter matching problem you prefer not to fix"
echo "or a vert problem you prefer not to fix. So, we won't make you do"
echo "these. There could be other problems too and these won't be avoided"
echo "by making sloppy versions. SO you should check your output!"
echo "If there is a vert problem you may see some inappropriately sized"
echo "| and \| in the web and word output. If there are other problems "
echo "but there was still output they may or may not affect the visual"
echo "rendering. You really should contact ma-largeprintnotes@bath.ac.uk"
echo "for help at some point!"
# ./scripts/dedollar/dedollar.sh $1
# echo "-----------------------------------------------------------------"
# echo "Since you are making sloppy versions of web and word you should"
# echo "already have sorted out your bracket matching in context as this"
# echo "is the most likely cause of problems. If you haven't you need to"
# echo "answer n to the next question and do that."
# ./scripts/match_parens_ht/match_parens_ht.sh $1
# echo "You _really_ should go away and fix the problems described above."
# echo "Do you want to continue anyway? y for yes and n for no"
# read decision
# if [ $decision != "y" ]; then
#     exit 1
# fi
# echo "-----------------------------------------------------------------"
# echo "Since you are making sloppy versions of web and word you might "
# echo "decide to answer no to the next request. However, be aware that"
# echo "failure to fix non-directional delimiters WILL result in some"
# echo "poorly presented mathematics - this does not direct only speech"
# echo "output but also visual output"
# echo "-----------------------------------------------------------------"
# ./scripts/vert/vert.sh $1
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
echo "Making SLOPPY web format"
echo "============================="
make websloppy name=$name > .quickMake-websloppy.out
echo "-----------------------------------------------------------------"
echo "Making SLOPPY word format"
echo "============================="
make wordsloppy name=$name > .quickMake-wordsloppy.out
make clean
make cleaner
echo "-----------------------------------------------------------------"
echo "The conversions are finished"
echo "============================="
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find web and word formats. If this is the first attempt"
echo "to make the alternative formats then you have run the wrong script."
echo "You should always use either ./quickMake or ./quickBeamerMaker first."
echo "-----------------------------------------------------------------"
echo "If a format failed with error code 124 then the document could "
echo "not be compiled in the time limit. This usually means there was"
echo "an infinite loop. Contact ma-largeprintnotes@bath.ac.uk for help."
echo "-----------------------------------------------------------------"
echo "This script is a FALL BACK to a sloppier version of the web and "
echo "word format and should only be used if you have xtpipes errors"
echo "from one of the other two scripts."
echo "-----------------------------------------------------------------"
echo "REMEMBER: You may have immediately usable files but you should "
echo "check these thoroughly yourself and they WILL BE broken in ways"
echo "you CANNOT SEE! So you should also contact us for advice"
echo "on ma-largeprintnotes@bath.ac.uk"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "============================================================="
echo "Please scroll back, check for errors and read the above text."
echo "============================================================="



