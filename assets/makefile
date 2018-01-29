.PHONY: clean standard clear large web word
#Change the name to the main tex file without the file extension.
name=empty
LATEX=pdflatex
HOME=$(shell cat .home)

all: standard clear figures large web word

pdflatexfigures:
	mkdir -p built
	[ ! -f $(name)-figures.tex ] || rm -f $(name)-figures.tex
	echo "\\\\def\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\usepackage{color}\\\\thispagestyle{empty}\\\\togglefalse{frontmatter}\\\\togglefalse{contents}\\\\begin{document}\\\\input{$(name)}\\\\end{document}" > $(name)-figures.tex
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}" > toggle.tex
	$(LATEX) $(name)-figures.tex 
	$(LATEX) $(name)-figures.tex
	$(LATEX) $(name)-figures.tex
	mv $(name)-figures.pdf built/

$(name)-cont.tex:
	cp $(HOME)/../../assets/macros.tex .
	$(HOME)/../preambleExtractions/extract < $(name).tex > $@

$(name)-lp-cont.tex:
	$(HOME)/../flowfix/flowfix.sh ./
	$(HOME)/../preambleExtractions/extract < $(name)-lp.tex > $@

#Note that we make clean as a prerequisite in each case as the toggles cause different setups. 
#Leaving the job output in the directory can cause issues in some cases. 
standard: clean $(name)-cont.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
#Setting the LaTeX toggles to control how the document is created. 
	[ ! -f toggle.tex ] || rm -f toggle.tex
#In this example we have a SVG but need a PDF for the LaTeX to work with.
	echo "\\\\togglefalse{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}" > toggle.tex
	[ ! -f $(name)-standard.tex ] || rm -f $(name)-standard.tex
	echo "\\\\input{master}\\\\input{$(name)-cont}" > $(name)-standard.tex
#https://tex.stackexchange.com/questions/611/setting-class-options-after-documentclass/617
	$(LATEX) $(name)-standard.tex
	$(LATEX) $(name)-standard.tex
	$(LATEX) $(name)-standard.tex
#We can't change the jobname to get different filenames that way as this does not work with some packages
#we will need to use for graphics in this set up. 
	mv $(name)-standard.pdf built/
	rm fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.*

#This will be the same except for the toggles and name.
clear: clean $(name)-cont.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}" > toggle.tex
	[ ! -f $(name)-clear.tex ] || rm -f $(name)-clear.tex
	echo "\\\\def\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\input{$(name)-cont}" > $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	mv $(name)-clear.pdf built/
	rm fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.*

#This will be the same except for the toggles and name.
large: clean $(name)-lp-cont.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{large}" > toggle.tex
	[ ! -f $(name)-large.tex ] || rm -f $(name)-large.tex
	echo "\\\\def\pointsize{17pt}\\\\def\\\\class{extarticle}\\\\input{master}\\\\input{$(name)-lp-cont}" > $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	mv $(name)-large.pdf built/
	rm fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.*

#We require some additional files for everything to work. 
web: clean $(name)-cont.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\input{$(name)-cont}" > $(name)-web.tex
	$(LATEX) -shell-escape $(name)-web.tex
#Convert the rest of the figures
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-web.*
#Set up for the web version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}" > toggle.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\input{$(name)-cont}" > $(name)-web.tex
	htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
	htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error and can put
#up with digits instead of numbers then comment out the next line as the web browser and mathjax are less fussy.
	$(HOME)/../TeX4htPostprocessing/postprocess.sh ./
#Creating a zip for ease of upload or sending
	[ ! -d built/$(name)-web/ ] || rm -r built/$(name)-web/
	mkdir built/$(name)-web/
	mkdir built/$(name)-web/figures/
	mkdir built/$(name)-web/figures/eps/
	mkdir built/$(name)-web/figures/latexpdfsvg/
	mkdir built/$(name)-web/figures/pdf/
	mkdir built/$(name)-web/figures/png/
	mkdir built/$(name)-web/figures/jpg/
	mkdir built/$(name)-web/figures/svg/
	mv *.html built/$(name)-web/
	cp $(HOME)/../../assets/additional.css built/$(name)-web/
	mv *.css built/$(name)-web/
	if ls ./figures/eps/*.svg 1> /dev/null 2>&1; then cp ./figures/eps/*.svg built/$(name)-web/figures/eps/; fi
	if ls ./figures/latexpdfsvg/*.svg 1> /dev/null 2>&1; then cp ./figures/latexpdfsvg/*.svg built/$(name)-web/figures/latexpdfsvg/; fi
	if ls ./figures/pdf/*.svg 1> /dev/null 2>&1; then cp ./figures/pdf/*.svg built/$(name)-web/figures/pdf/; fi
	if ls ./figures/png/*.png 1> /dev/null 2>&1; then cp ./figures/png/*.svg built/$(name)-web/figures/png/; fi
	if ls ./figures/jpg/*.jpg 1> /dev/null 2>&1; then cp ./figures/jpg/*.svg built/$(name)-web/figures/jpg/; fi
	if ls ./figures/svg/*.svg 1> /dev/null 2>&1; then cp ./figures/svg/*.svg built/$(name)-web/figures/svg/; fi
	cd built; [ ! -f $(name)-web.zip ] || rm -f $(name)-web.zip; zip -r $(name)-web.zip $(name)-web; cd ..
#Tidy up a bit
	rm mathml.4ht
	rm unicode.4hf
	rm mathjaxMMLWord.cfg
	rm fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.*

#To transform to Word we need to use the web transform but without breaking into sections and then use Pandoc 19+
word: clean $(name)-cont.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\input{$(name)-cont}" > $(name)-word.tex
	$(LATEX) -shell-escape $(name)-word.tex
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-word.*
#Set up for the word version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{article}\\\\input{master}\\\\input{$(name)-cont}" > $(name)-word.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
	htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
	$(HOME)/../TeX4htPostprocessing/postprocessWord.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.docx --reference-doc=$(HOME)/../../assets/reference.docx
	mv $(name)-word.docx built/
#Tidy up a bit
	rm mathml.4ht
	rm unicode.4hf
	rm mathjaxMMLWord.cfg
	rm additional.css
	rm fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.*

clean:
	rm -f  *.css *.aux *.log *.toc *~ *.out *.html *.4ct *.4tc *.dvi *.idv *.tmp *.xref *.lg *.lof *.lot $(name)*x.png *.4ht *-lp1.tex fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.sty webprevent.sty displayoperators.* 

cleanlatex:
	rm *-cont.tex *-standard.tex *-clear.tex *-large.tex *-web.tex *-word.tex toggle.tex choices.tex *-lp.tex *-figures.tex *_tex-lp

cleanfigures: 
	rm -f ./figures/svg/*.pdf
	rm -f ./figures/eps/*.svg
	rm -f ./figures/pdf/*.svg
