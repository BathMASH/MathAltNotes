#!/bin/sh
home=$(dirname $(readlink -f $0))
xtpipeloc=$(dirname $(locate -n 1 xtpipes.dtd))
jarloc=$(dirname $(locate -n 1 tex4ht.jar))
cd $1

for i in $(ls *.html); do
cp $i $i.tmp
java -classpath $jarloc/tex4ht.jar xtpipes -i $xtpipeloc -s $home/groupmn.4xt -o $i $i.tmp
#Just commented out for the public version as tidy isn't installed on the docker setup
#tidy -m -q -w --preserve-entities yes --show-warnings no -ashtml -access -i $i
#sed -i '/^$/d' $i
sed -i '/^[[:space:]]*$/d' $i
#rm $i.tmp
done 
