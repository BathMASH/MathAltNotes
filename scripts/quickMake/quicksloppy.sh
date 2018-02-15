#!/bin/bash
usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Only call this if quickMake resulted in an xtpipes error!"
echo "In some cases $0 will result in immediately usable files however"
echo "they are broken in ways you CANNOT SEE! So you should also"
echo "contact us for advice on ma-largeprintnotes@bath.ac.uk "
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

cd scripts/flowfix/
make
cd ..
cd preambleExtractions
make
cd ../../$1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "The name of the main LaTeX file found is: $name"
make websloppy name=$name
make wordsloppy name=$name
make clean
make cleaner
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find web and word formats."
echo "-----------------------------------------------------------------"
echo "REMEMBER: You may have immediately usable files but they are"
echo "broken in ways you CANNOT SEE! So you should also contact us for"
echo "advice on ma-largeprintnotes@bath.ac.uk"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
