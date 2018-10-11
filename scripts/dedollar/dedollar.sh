echo "-----------------------------------------------------------------"
echo "Dollars are TeX primitives and not LaTeX and make our job harder. "
echo "Autoswitching is a risky strategy - try not to use $'s if possible."
echo "Place you do need to use them are in chapter and section titles "
echo "and similar; in captions and within figures."
echo "Please comfirm that automatic dedollaring is suitable for this file"
echo "y for yes and no for no then press enter"
read decision
if [ $decision != "y" ]; then
    exit 1
fi
echo "Switching $...$ to \(...\) and \$\$...\$\$ to \[...\]"
echo "-----------------------------------------------------------------"

home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" ! -name master*.tex ! -name macros*.tex ! -name empty*.tex ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" ! -name "choices.tex" -type f`; do
    $home/dedollar < $i > $(basename "$i" .tex)-d
    if ! diff -q $i $(basename "$i" .tex)-d &> /dev/null; then
	echo "$i contains $'s"
	mv $i $(basename "$i" .tex).origin
	mv $(basename "$i" .tex)-d $i
    else
	echo "$i does not contain $'s - good for you"
	rm $(basename "$i" .tex)-d
    fi
done
echo "-----------------------------------------------------------------"
