#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "THIS IS A TEST SCRIPT. Run it on a directory." 
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

echo "Checking lexers are compiled"
echo "============================="
make

echo $1
./revert.sh $1
./vert.sh $1
cd $1
for i in `find . -maxdepth 1 -name "*.tex" -type f`; do
    echo "Processing $i"
    if cmp -s $i $(basename "$i" .tex)-vert.check; then
	echo "PASSED"
    else
	echo -e "\e[91mFAILED\e[0m"
    fi
done
cd ..
#./revert.sh $1
