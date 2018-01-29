# Instructions

Run the script ./getMyLaTeX on the main LaTeX file in your project. 
E.g. if to make your output from this directory you would run
> pdflatex ../notes/filename.tex
then run
> ./getMyLaTeX ../notes/filename.tex

This will find all the files needed and put them in a timestamped
directory. That is, if I ran the above command at 11:51 on 29th 
January 2018 it could create the folder filename-180129-1151

To make all the formats you would then run:
> ./quickMake filename-180129-1151

Once this has finished you will find the outputs in the folder
filename-180129-1151/built

This is a work in progress! If you have problems email ma-largeprintnotes@bath.ac.uk 
