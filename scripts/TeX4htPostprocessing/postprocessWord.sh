#!/bin/sh
home=$(dirname $(readlink -f $0))
xtpipeloc=$(dirname $(locate -n 1 xtpipes.dtd))
jarloc=$(dirname $(locate -n 1 tex4ht.jar))
cd $1

for i in $(ls *.html); do
cp $i $i.tmp
java -classpath $jarloc/tex4ht.jar xtpipes -i $xtpipeloc -s $home/groupmn.4xt -o $i.tmp2 $i.tmp
java -classpath $jarloc/tex4ht.jar xtpipes -i $xtpipeloc -s $home/word.4xt -o $i $i.tmp2 
#rm $i.tmp $i.tmp2
done 
