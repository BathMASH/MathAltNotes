#!/bin/bash

usage() {
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "THIS IS THE TEST SCRIPT. It takes two arguments!"
echo "This is a test script, you should not be running it unless you"
echo "are checking you haven't changed anything by altering code."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
exit
}

if [ -z $1 ] || [ -z $2 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

# echo "Checking lexers are compiled"
# echo "============================="
# cd scripts/flowfix/
# make
# cd ..
# cd preambleExtractions
# make
# cd ..
# cd dedollar
# make
# cd ../../
echo "============================="
echo "Delimiters"
echo "============================="
./scripts/dedollar/dedollar.sh $1 &>/dev/null
./scripts/match_parens_ht/match_parens_ht.sh $1 &>/dev/null
#./scripts/vert/vert.sh $1
cd $1
file=`find . -name "*.fls" -type f`
name=$(basename "$file" .fls)
echo "Making standard print format"
echo "============================="
make standardtest name=$name > .quickMake-standard.out
echo "Making clear print format"
echo "============================="
make cleartest name=$name > .quickMake-clear.out
echo "Making large print format"
echo "============================="
make largetest name=$name > .quickMake-large.out
#echo "Making accessible web format"
#echo "============================="
#make web name=$name > .quickMake-web.out
echo "Making accessible word format"
echo "============================="
make wordtest name=$name > .quickMake-word.out
#make clean
#make cleaner
echo "The conversions are finished"
echo "============================="
echo "Tests for $2"
echo "============================="
cd ..
#if cmp $1/input.fls $2/output/input.fls; then
#echo "PASSED: input.fls"
#else
#echo -e "\e[91mFAILED\e[0m: input.fls"
#fi
if cmp -s $1/input.tex $2/output/input.tex; then
echo "PASSED: input.tex"
else
echo "\e[91mFAILED\e[0m: input.tex"
fi
if cmp -s $1/input.parens $2/output/input.parens; then
echo "PASSED: input.parens"
else
echo "\e[91mFAILED\e[0m: input.parens"
fi
if cmp -s $1/input-co $2/output/input-co; then
echo "PASSED: input-co"
else
echo "\e[91mFAILED\e[0m: input-co"
fi
if cmp -s $1/choices.tex $2/output/choices.tex; then
echo "PASSED: choices.tex"
else
echo "\e[91mFAILED\e[0m: choices.tex"
fi
if cmp -s $1/macros.tex $2/output/macros.tex; then
echo "PASSED: macros.tex"
else
echo "\e[91mFAILED\e[0m: macros.tex"
fi
if cmp -s $1/input-cont.tex $2/output/input-cont.tex; then
echo "PASSED: input-cont.tex"
else
echo "\e[91mFAILED\e[0m: input-cont.tex"
fi
if cmp -s $1/input-cont-clean.tex $2/output/input-cont-clean.tex; then
echo "PASSED: input-cont-clean.tex"
else
echo "\e[91mFAILED\e[0m: input-cont-clean.tex"
fi
if cmp -s $1/input-cont-clean-lp.tex $2/output/input-cont-clean-lp.tex; then
echo "PASSED: input-cont-clean-lp.tex"
else
echo "\e[91mFAILED\e[0m: input-cont-clean-lp.tex"
fi
if cmp -s $1/input-word.html $2/output/input-word.html; then
echo "PASSED: input-word.html"
else
echo "\e[91mFAILED\e[0m: input-word.html"
fi
if cmp -s $1/input-word.html.tmp $2/output/input-word.html.tmp; then
echo "PASSED: input-word.html.tmp"
else
echo "\e[91mFAILED\e[0m: input-word.html.tmp"
fi
if cmp -s $1/input-word.html.tmp2 $2/output/input-word.html.tmp2; then
echo "PASSED: input-word.html.tmp2"
else
echo "\e[91mFAILED\e[0m: input-word.html.tmp2"
fi
if cmp -s $1/input-word.css $2/output/input-word.css; then
echo "PASSED: input-word.css"
else
echo "\e[91mFAILED\e[0m: input-word.css"
fi
echo "============================="
