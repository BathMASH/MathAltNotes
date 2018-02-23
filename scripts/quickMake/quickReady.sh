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
cd ../../
echo "-----------------------------------------------------------------"
echo "By-hand: Non-directional delimiters"
echo "==================================="
./scripts/dedollar/dedollar.sh $1
./scripts/match_parens_ht/match_parens_ht.sh $1
echo "You should go away and fix the problems described above."
echo "Do you want to continue? y for yes and n for no"
read decision
if [ $decision != "y" ]; then
    exit 1
fi
./scripts/vert/vert.sh $1
cd ../..
