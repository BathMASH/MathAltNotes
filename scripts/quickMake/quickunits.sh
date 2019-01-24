#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "THIS IS A TEST SCRIPT. It takes no arguments. It will run all" 
echo "available unit tests in the directory units. That could take a "
echo "while to complete. Definitely time for tea."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

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

for i in `ls -d ./units/*-text/` ; do
echo $i
./getMyLaTeX $i/input &>/dev/null
read input < .lasttimestamp
#echo $input
./quickTest $input $i
./quickTest $input $i
rm -r $input
sleep 2
done
