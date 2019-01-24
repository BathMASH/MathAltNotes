echo "Testing to see if you have unmatched brackets in a context. This "
echo "will often cause transforms to web and word to fail. We can't fix"
echo "this for you and we can't even spot them all e.g. between & in a"
echo "table. We will do our best and then tell you what to do if we spot"
echo "an issue."
echo "-----------------------------------------------------------------"
home=$(dirname $(readlink -f $0))
cd $1

for i in `find . -maxdepth 1 -name "*.tex" ! -name master*.tex ! -name macros*.tex ! -name empty*.tex ! -name "*standard.tex" ! -name "*large.tex" ! -name "*clear.tex" ! -name "*web.tex" ! -name "*word.tex" ! -name "*-cont.tex" ! -name "choices.tex" -type f`; do
    echo "Checking $i"
    $home/match_parens_ht --htlatex $i > $(basename "$i" .tex).parens && echo "No non-matching delimiters were found in $i - good for you" || echo "$i has non-matching delimiters described in $(basename "$i" .tex).parens";
done
echo "-----------------------------------------------------------------"

