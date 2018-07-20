#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "THIS IS A TEST SCRIPT. It takes no arguments. It will run all" 
echo "available pipe tests in the directory pipes. That could take a "
echo "substantial amount of time to complete. Tea and biscuits time!"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

for i in `ls -d ./pipes/*-text/` ; do
echo $i
./getMyLaTeX $i/input &>/dev/null
read input < .lasttimestamp
#echo $input
./quickTest $input $i
rm -r $input
sleep 2
done
