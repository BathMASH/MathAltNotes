#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Call getFiles first. This will produce a timestamped directory."
echo "Call $0 giving the timestamped directory as input."
echo "That is, if the new directory is called file-180129-1151"
echo "you would call $0 file-180129-1151"
echo "-----------------------------------------------------------------"
echo "You should only run ./quickReady if you intend to compile each"
echo "alternative format separately for debugging. Generally you should"
echo "use ./quickMake or ./quickBeamerMake instead."
echo "-----------------------------------------------------------------"
echo "You can edit files in your directory and call quickReady again"
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
echo "-----------------------------------------------------------------"
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
echo "Do you want to continue? y for yes and n for no"
read decision
if [ $decision != "y" ]; then
    exit 1
fi
cd ../..
