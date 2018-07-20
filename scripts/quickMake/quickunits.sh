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

for i in `ls -d ./units/*-text/` ; do
echo $i
./getMyLaTeX $i/input &>/dev/null
read input < .lasttimestamp
#echo $input
./quickTest $input $i
rm -r $input
sleep 2
done
