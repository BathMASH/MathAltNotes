#Unit tests

* Each folder is a test document that tests a single structure. 
* We assume that getMyLaTeX followed by quickTest is run
** 
To create a new test place the LaTeX in input.tex. Run quickReady and say no to adding the Bath disclaimer, 2 for sections. You can also run quickMake instead with the same choices and yes to continue. Then make standard, clear, large and word. Assuming this works without problems copy the following file list to the outputs folder:

cp choices.tex input.origin input.tex input.fls input.parens input.pre-vert macros.tex input-co input-cont.tex input-cont-clean.tex input-cont-clean-lp.tex input-word.css input-word.html input-word.html.tmp input-word.html.tmp2 ../units/TESTNAME/output/
