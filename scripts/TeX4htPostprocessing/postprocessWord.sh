#!/bin/sh
home=$(dirname $(readlink -f $0))
cd $1

for i in $(ls *.html); do
cp $i $i.tmp
java -classpath /usr/share/tex4ht/tex4ht.jar xtpipes -i /usr/share/texmf/tex4ht/xtpipes/ -s $home/groupmn.4xt -o $i.tmp2 $i.tmp
java -classpath /usr/share/tex4ht/tex4ht.jar xtpipes -i /usr/share/texmf/tex4ht/xtpipes/ -s $home/word.4xt -o $i $i.tmp2 
rm $i.tmp $i.tmp2
done 
