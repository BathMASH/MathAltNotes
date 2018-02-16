.PHONY: clean standard clear large web word
#Change the name to the main tex file without the file extension.
name=empty
LATEX=pdflatex
HOME=$(shell cat .home)
# Original class
TYPE=$(shell cat .documentclass)
# Alternative class
ALTT=$(shell cat .alternativeclass)
# Are we in trouble and have no alternative class?
UNKN=$(shell cat .unknownclass)
SIZE=$(shell cat .fontsize)
PAPER=$(shell cat .papersize)

pdflatexfigures:
	mkdir -p built
	[ ! -f $(name)-figures.tex ] || rm -f $(name)-figures.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\input{master}\\\\usepackage{color}\\\\thispagestyle{empty}\\\\togglefalse{frontmatter}\\\\togglefalse{contents}\\\\begin{document}\\\\input{$(name)}\\\\end{document}" > $(name)-figures.tex
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{word}\\\\togglefalse{large}" > toggle.tex
	$(LATEX) --shell-escape $(name)-figures.tex 
	$(LATEX) --shell-escape $(name)-figures.tex
	$(LATEX) --shell-escape $(name)-figures.tex
	mv $(name)-figures.pdf built/

$(name)-cont-clean.tex:
	cp $(HOME)/../../assets/macros.tex .
	$(HOME)/../preambleExtractions/extract.sh ./
	cp $(name)-cont.tex $(name)-cont-clean.tex
	de-macro $(name)-cont.tex

#At this point everything should be in one file due to de-macro
$(name)-cont-clean-lp.tex: $(name)-cont-clean.tex
	$(HOME)/../flowfix/flowfix.sh $(name)-cont-clean.tex

#Note that we make clean as a prerequisite in each case as the toggles cause different setups. 
#Leaving the job output in the directory can cause issues in some cases. 
standard: clean $(name)-cont-clean.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
#Setting the LaTeX toggles to control how the document is created. 
	[ ! -f toggle.tex ] || rm -f toggle.tex
#In this example we have a SVG but need a PDF for the LaTeX to work with.
	echo "\\\\togglefalse{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-standard.tex ] || rm -f $(name)-standard.tex
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\papersize{$(PAPER)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-standard.tex
#https://tex.stackexchange.com/questions/611/setting-class-options-after-documentclass/617
	$(LATEX) --shell-escape $(name)-standard.tex
	$(LATEX) --shell-escape $(name)-standard.tex
	$(LATEX) --shell-escape $(name)-standard.tex
#We can't change the jobname to get different filenames that way as this does not work with some packages
#we will need to use for graphics in this set up. 
	mv $(name)-standard.pdf built/
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty

#This will be the same except for the toggles and name.
clear: clean $(name)-cont-clean.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-clear.tex ] || rm -f $(name)-clear.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
endif
ifeq ($(TYPE),beamer)	
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\beamerhandout{handout}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
endif
	$(LATEX) --shell-escape $(name)-clear.tex
	$(LATEX) --shell-escape $(name)-clear.tex
	$(LATEX) --shell-escape $(name)-clear.tex
	mv $(name)-clear.pdf built/
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty

#This will be the same except for the toggles and name.
clearbart: clean $(name)-cont-clean.tex
ifeq ($(TYPE),beamer)	
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-clear.tex ] || rm -f $(name)-clear.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	mv $(name)-clear.pdf built/
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty
else
	@echo "---------------------------------------------------";
	@echo "You cannot make clear beamer article format for documents which are not beamer slides.";
	@echo "---------------------------------------------------";
endif



#This will be the same except for the toggles and name.
large: clean $(name)-cont-clean-lp.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-large.tex ] || rm -f $(name)-large.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{ext$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean-lp}" > $(name)-large.tex
else
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean-lp}" > $(name)-large.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\beamerhandout{handout}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-large.tex
endif
	$(LATEX) --shell-escape $(name)-large.tex
	$(LATEX) --shell-escape $(name)-large.tex
	$(LATEX) --shell-escape $(name)-large.tex
	mv $(name)-large.pdf built/
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty

#This will be the same except for the toggles and name.
largebart: clean $(name)-cont-clean-lp.tex
ifeq ($(TYPE),beamer)
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-large.tex ] || rm -f $(name)-large.tex
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{ext$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	mv $(name)-large.pdf built/
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty
else
	@echo "---------------------------------------------------";
	@echo "You cannot make large beamer article format for documents which are not beamer slides.";
	@echo "---------------------------------------------------";
endif

#We require some additional files for everything to work. 
web: clean $(name)-cont-clean.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
	$(LATEX) -shell-escape $(name)-web.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
#Convert the rest of the figures
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-web.*
#Set up for the web version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
	$(HOME)/../../scripts/htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HOME)/../../scripts/htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
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
	if ls ./figures/png/*.png 1> /dev/null 2>&1; then cp ./figures/png/*.png built/$(name)-web/figures/png/; fi
	if ls ./figures/jpg/*.jpg 1> /dev/null 2>&1; then cp ./figures/jpg/*.jpg built/$(name)-web/figures/jpg/; fi
	if ls ./figures/svg/*.svg 1> /dev/null 2>&1; then cp ./figures/svg/*.svg built/$(name)-web/figures/svg/; fi
#	[ ! -e ./$(name)-web0x.interim.png ] || mv $(name)-web*.png built/$(name)-web/
	[ ! -e ./$(name)*svg ] || mv $(name)*svg built/$(name)-web/
	cd built; [ ! -f $(name)-web.zip ] || rm -f $(name)-web.zip; zip -r $(name)-web.zip $(name)-web; cd ..
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty
	@rm *.htf

#We require some additional files for everything to work. 
websloppy: clean $(name)-cont-clean.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
	$(LATEX) -shell-escape $(name)-web.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
#Convert the rest of the figures
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-web.*
#Set up for the web version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
	$(HOME)/../../scripts/htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HOME)/../../scripts/htlatex  $(name)-web.tex "mathjaxMMLWord.cfg,2,sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error and can put
#up with digits instead of numbers then comment out the next line as the web browser and mathjax are less fussy.
#	$(HOME)/../TeX4htPostprocessing/postprocess.sh ./
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
	if ls ./figures/png/*.png 1> /dev/null 2>&1; then cp ./figures/png/*.png built/$(name)-web/figures/png/; fi
	if ls ./figures/jpg/*.jpg 1> /dev/null 2>&1; then cp ./figures/jpg/*.jpg built/$(name)-web/figures/jpg/; fi
	if ls ./figures/svg/*.svg 1> /dev/null 2>&1; then cp ./figures/svg/*.svg built/$(name)-web/figures/svg/; fi
#	[ ! -e ./$(name)-web0x.interim.png ] || mv $(name)-web*.png built/$(name)-web/
	[ ! -e ./$(name)*svg ] || mv $(name)*svg built/$(name)-web/
	cd built; [ ! -f $(name)-web.zip ] || rm -f $(name)-web.zip; zip -r $(name)-web.zip $(name)-web; cd ..
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty
	@rm *.htf


#To transform to Word we need to use the web transform but without breaking into sections and then use Pandoc 19+
word: clean $(name)-cont-clean.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
	$(LATEX) -shell-escape $(name)-word.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-word.*
#Set up for the word version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	$(HOME)/../../scripts/htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HOME)/../../scripts/htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
	$(HOME)/../TeX4htPostprocessing/postprocessWord.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.docx --reference-doc=$(HOME)/../../assets/reference.docx
	mv $(name)-word.docx built/
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty
	@rm *.htf

#To transform to Word we need to use the web transform but without breaking into sections and then use Pandoc 19+
wordsloppy: clean $(name)-cont-clean.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Make any pdf_tex figures
	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
	$(LATEX) -shell-escape $(name)-word.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-word.*
#Set up for the word version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\input{master}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	$(HOME)/../../scripts/htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HOME)/../../scripts/htlatex $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
#	$(HOME)/../TeX4htPostprocessing/postprocessWord.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.docx --reference-doc=$(HOME)/../../assets/reference.docx
	mv $(name)-word.docx built/
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty
	@rm *.htf


clean:
	@rm -f  *.css *.aux *.log *.toc *~ *.out *.html *.4ct *.4tc *.dvi *.idv *.tmp *.xref *.lg *.lof *.lot *x.interim.png *x.svg *.4ht *-lp1 *-lp0 fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty webfix.* webprevent.sty displayoperators.* *.tmp2 *.nav *.snm colorfix.sty fontfix.sty parfix.sty beamerfix.sty *-pics*.pdf tuftefix.sty

cleaner:
	@rm -f *-cont.tex *-standard.tex *-clear.tex *-large.tex *-web.tex *-word.tex toggle.tex choices.tex *-lp*.tex *-figures.tex *_tex-lp macros.tex demacro-private.sty *-cont* 

cleanfigures: 
	@rm -f ./figures/svg/*.pdf
	@rm -f ./figures/eps/*.svg
	@rm -f ./figures/pdf/*.svg
