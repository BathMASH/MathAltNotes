#!/bin/sh

cd $1

for i in $(ls *.html); do
cp $i $i.tmp
java -classpath /usr/share/tex4ht/tex4ht.jar xtpipes -i /usr/share/texmf/tex4ht/xtpipes/ -s ./scripts/TeX4htPostprocessing/groupmn.4xt -o $i $i.tmp
rm $i.tmp
done 
