#!/bin/bash
usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Only call this if quickMake resulted in an xtpipes error!"
echo "Ideally you should check your bracket matching first!"
echo "See the output from quickMake!"
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

echo "-----------------------------------------------------------------"
echo "Depending on the number of images in your document it might take"
echo "some time to make the files. You might like to make a cup of tea!"
echo "-----------------------------------------------------------------"
echo "Checking lexers are compiled"
echo "============================="
cd scripts/flowfix/
make
cd ..
cd preambleExtractions
make
cd ../../$1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "-----------------------------------------------------------------"
echo "The name of the main LaTeX file found is: $name"
echo "-----------------------------------------------------------------"
echo "Making SLOPPY web format"
echo "============================="
make websloppy name=$name > .quickMake-websloppy.out
echo "-----------------------------------------------------------------"
echo "Making SLOPPY word format"
echo "============================="
make wordsloppy name=$name > .quickMake-wordsloppy.out
make clean
make cleaner
echo "Look BACK - check for errors"
echo "============================="
echo "Assuming no errors the completed outputs can be found in $1built."
echo "You should find web and word formats."
echo "-----------------------------------------------------------------"
echo "REMEMBER: You may have immediately usable files but you should "
echo "check these thoroughly yourself and they WILL BE broken in ways"
echo "you CANNOT SEE! So you should also contact us for advice"
echo "on ma-largeprintnotes@bath.ac.uk"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
