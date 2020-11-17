.PHONY: clean standard clear large web word
#Change the name to the main tex file without the file extension.
name=empty
#The below is the break level for the web version
level=$(shell cat .level)
LATEX=timeout 1m pdflatex -interaction=nonstopmode -halt-on-error
HOME=$(shell cat .home)
HTLATEX=timeout 2m $(HOME)/../../scripts/htlatex
BIBTEX=timeout 1m bibtex
# Original class
TYPE=$(shell cat .documentclass 2> /dev/null)
# Alternative class
ALTT=$(shell cat .alternativeclass 2> /dev/null)
# Are we in trouble and have no alternative class?
UNKN=$(shell cat .unknownclass 2> /dev/null)
SIZE=$(shell cat .fontsize 2> /dev/null)
PAPER=$(shell cat .papersize 2> /dev/null)
FLEQN=$(shell cat .fleqn 2> /dev/null)
BEAMERFIX=$(shell cat .beamerfix 2> /dev/full)
COLORHERE=$(shell cat .colorhere 2> /dev/full)
DIS=$(shell cat .disclaimer 2> /dev/null)

pdflatexfigures:
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	[ ! -f $(name)-figures.tex ] || rm -f $(name)-figures.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{color}\\\\thispagestyle{empty}\\\\togglefalse{frontmatter}\\\\togglefalse{contents}\\\\begin{document}\\\\input{$(name)}\\\\end{document}" > $(name)-figures.tex
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{word}\\\\togglefalse{large}" > toggle.tex
	$(LATEX) --shell-escape $(name)-figures.tex 
	$(LATEX) --shell-escape $(name)-figures.tex
	$(LATEX) --shell-escape $(name)-figures.tex
	mv $(name)-figures.pdf built/

$(name)-cont-clean.tex:
	cp $(HOME)/../../assets/macros.tex .
	$(HOME)/../preambleExtractions/extract.sh ./
	$(HOME)/../graphicx/buildfigure.sh ./	
	$(HOME)/../graphicx/swaptopdf.sh ./	
	cp $(name)-cont.tex $(name)-cont-clean.tex
	de-macro $(name)-cont.tex

$(name)-cont-web-clean.tex: $(name)-cont-clean.tex
	$(HOME)/../graphicx/swaptoweb.sh ./
	cp $(name)-cont.tex $(name)-cont-web.tex
	cp $(name)-cont-web.tex $(name)-cont-web-clean.tex
	de-macro $(name)-cont-web.tex

#At this point everything should be in one file due to de-macro
$(name)-cont-clean-lp.tex: $(name)-cont-clean.tex
	$(HOME)/../graphicx/swaptopdf.sh ./
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
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\emphasis{standard}\\\\def\\\\papersize{$(PAPER)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{$(BEAMERFIX)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-standard.tex
#https://tex.stackexchange.com/questions/611/setting-class-options-after-documentclass/617
	$(LATEX) --shell-escape $(name)-standard.tex
	$(BIBTEX) $(name)-standard || true
	$(LATEX) --shell-escape $(name)-standard.tex
	$(LATEX) --shell-escape $(name)-standard.tex
#We can't change the jobname to get different filenames that way as this does not work with some packages
#we will need to use for graphics in this set up. 
	mv $(name)-standard.pdf built/
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*

standardtest: clean $(name)-cont-clean.tex

#This will be the same except for the toggles and name.
clear: clean $(name)-cont-clean.tex
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-clear.tex ] || rm -f $(name)-clear.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
endif
ifeq ($(TYPE),beamer)	
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\beamerhandout{handout}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{$(BEAMERFIX)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
endif
	$(LATEX) --shell-escape $(name)-clear.tex
	$(BIBTEX) $(name)-clear || true
	$(LATEX) --shell-escape $(name)-clear.tex
	$(LATEX) --shell-escape $(name)-clear.tex
	mv $(name)-clear.pdf built/
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*

cleartest: clean $(name)-cont-clean.tex

#This will be the same except for the toggles and name.
clearbart: clean $(name)-cont-clean.tex
ifeq ($(TYPE),beamer)	
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-clear.tex ] || rm -f $(name)-clear.tex
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	$(LATEX) $(name)-clear.tex
	mv $(name)-clear.pdf built/
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
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
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{ext$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean-lp}" > $(name)-large.tex
else
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean-lp}" > $(name)-large.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{$(SIZE)pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\beamerhandout{handout}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{$(BEAMERFIX)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-large.tex
endif
	$(LATEX) --shell-escape $(name)-large.tex
	$(BIBTEX) $(name)-large || true
	$(LATEX) --shell-escape $(name)-large.tex
	$(LATEX) --shell-escape $(name)-large.tex
	mv $(name)-large.pdf built/
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*

largetest: clean $(name)-cont-clean-lp.tex

#This will be the same except for the toggles and name.
largebart: clean $(name)-cont-clean-lp.tex
ifeq ($(TYPE),beamer)
	mkdir -p built
	cp $(HOME)/../../styles/* . 
	cd figures/svg/; $(HOME)/../graphicx/svgtopdf.sh ./; cd ../..
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-large.tex ] || rm -f $(name)-large.tex
	echo "\\\\def\\\\pointsize{17pt}\\\\def\\\\class{ext$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean-lp}" > $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	$(LATEX) $(name)-large.tex
	mv $(name)-large.pdf built/
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
else
	@echo "---------------------------------------------------";
	@echo "You cannot make large beamer article format for documents which are not beamer slides.";
	@echo "---------------------------------------------------";
endif

#We require some additional files for everything to work. 
web: clean $(name)-cont-web-clean.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
#	cp $(HOME)/../../assets/longtable.4ht . Do not use this, use, I removed the old-longtable from here (see makefile-fb) as I am not yet sure what we want to do about this in general.
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
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
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
endif
	$(HTLATEX)  $(name)-web.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(BIBTEX) $(name)-web || true
	$(HTLATEX)  $(name)-web.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
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
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

#We require some additional files for everything to work. 
websingle: clean $(name)-cont-web-clean.tex
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
#	cp $(HOME)/../../assets/longtable.4ht . Do not use this, use, I removed the old-longtable from here (see makefile-fb) as I am not yet sure what we want to do about this in general.
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web-single.tex ] || rm -f $(name)-web-single.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-single.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-single.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-single.tex
endif
	$(LATEX) -shell-escape $(name)-web-single.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
#Convert the rest of the figures
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-web-single.*
#Set up for the web version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	[ ! -f $(name)-web-single.tex ] || rm -f $(name)-web-single.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-single.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-single.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-single.tex
endif
	$(HTLATEX)  $(name)-web-single.tex "mathjaxMMLWord.cfg,1,sections+,fonts-,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(BIBTEX) $(name)-web-single || true
	$(HTLATEX)  $(name)-web-single.tex "mathjaxMMLWord.cfg,1,sections+,fonts-,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error and can put
#up with digits instead of numbers then comment out the next line as the web browser and mathjax are less fussy.
	$(HOME)/../TeX4htPostprocessing/postprocess.sh ./
#Creating a zip for ease of upload or sending
	[ ! -d built/$(name)-web-single/ ] || rm -r built/$(name)-web-single/
	mkdir built/$(name)-web-single/
	mkdir built/$(name)-web-single/figures/
	mkdir built/$(name)-web-single/figures/eps/
	mkdir built/$(name)-web-single/figures/latexpdfsvg/
	mkdir built/$(name)-web-single/figures/pdf/
	mkdir built/$(name)-web-single/figures/png/
	mkdir built/$(name)-web-single/figures/jpg/
	mkdir built/$(name)-web-single/figures/svg/
	mv *.html built/$(name)-web-single/
	cp $(HOME)/../../assets/additional.css built/$(name)-web-single/
	mv *.css built/$(name)-web-single/
	if ls ./figures/eps/*.svg 1> /dev/null 2>&1; then cp ./figures/eps/*.svg built/$(name)-web-single/figures/eps/; fi
	if ls ./figures/latexpdfsvg/*.svg 1> /dev/null 2>&1; then cp ./figures/latexpdfsvg/*.svg built/$(name)-web-single/figures/latexpdfsvg/; fi
	if ls ./figures/pdf/*.svg 1> /dev/null 2>&1; then cp ./figures/pdf/*.svg built/$(name)-web-single/figures/pdf/; fi
	if ls ./figures/png/*.png 1> /dev/null 2>&1; then cp ./figures/png/*.png built/$(name)-web-single/figures/png/; fi
	if ls ./figures/jpg/*.jpg 1> /dev/null 2>&1; then cp ./figures/jpg/*.jpg built/$(name)-web-single/figures/jpg/; fi
	if ls ./figures/svg/*.svg 1> /dev/null 2>&1; then cp ./figures/svg/*.svg built/$(name)-web-single/figures/svg/; fi
#	[ ! -e ./$(name)-web0x.interim.png ] || mv $(name)-web*.png built/$(name)-web/
	[ ! -e ./$(name)*svg ] || mv $(name)*svg built/$(name)-web-single/
	cd built; [ ! -f $(name)-web-single.zip ] || rm -f $(name)-web-single.zip; zip -r $(name)-web-single.zip $(name)-web-single; cd ..
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf


#We require some additional files for everything to work. 
websloppy: clean $(name)-cont-web-clean.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web.tex
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
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web.tex
endif
	$(HTLATEX)  $(name)-web.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HTLATEX)  $(name)-web.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
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
#I am not really sure if this is necessary. It was on ONE example - doctoral writing thing written by EHC. Should explore further.
	cp $(HOME)/../../assets/additionalfix.css built/$(name)-web/additional.css
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
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

#We require some additional files for everything to work. 
webstandard: clean $(name)-cont-web-clean.tex 
	mkdir -p built
#Copy required files to where they are needed
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
	cp $(HOME)/../../assets/mathml.4ht .
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
	[ ! -f $(name)-web.tex ] || rm -f $(name)-web-standard.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\emphasis{standard}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-standard.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\emphasis{standard}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-standard.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\emphasis{standard}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-web-standard.tex
endif
	$(LATEX) -shell-escape $(name)-web-standard.tex
#Fix any figures that were produced in png incorrectly
#	$(HOME)/../graphicx/svg-fix.sh ./
#Convert the rest of the figures
	cd figures/eps/; $(HOME)/../graphicx/eps-converted2svg.sh ./; cd ../..
	cd figures/pdf/; $(HOME)/../graphicx/pdftosvg.sh ./; cd ../..
	rm $(name)-web-standard.*
#Set up for the web version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\togglefalse{word}" > toggle.tex
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	[ ! -f $(name)-web-standard.tex ] || rm -f $(name)-web-standard.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\emphasis{standard}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-standard.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\emphasis{standard}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-standard.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\emphasis{standard}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-web-standard.tex
endif
	$(HTLATEX)  $(name)-web-standard.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
	$(HTLATEX)  $(name)-web-standard.tex "mathjaxMMLWord.cfg,$(level),sections+,fonts-,early_,early^,charset=utf-8" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error and can put
#up with digits instead of numbers then comment out the next line as the web browser and mathjax are less fussy.
	$(HOME)/../TeX4htPostprocessing/postprocess.sh ./
#Creating a zip for ease of upload or sending
	[ ! -d built/$(name)-web-standard/ ] || rm -r built/$(name)-web-standard/
	mkdir built/$(name)-web-standard/
	mkdir built/$(name)-web-standard/figures/
	mkdir built/$(name)-web-standard/figures/eps/
	mkdir built/$(name)-web-standard/figures/latexpdfsvg/
	mkdir built/$(name)-web-standard/figures/pdf/
	mkdir built/$(name)-web-standard/figures/png/
	mkdir built/$(name)-web-standard/figures/jpg/
	mkdir built/$(name)-web-standard/figures/svg/
	mv *.html built/$(name)-web-standard/
#Tidy up the html a litte for human processing (in web standard only). 
#	tidy --indent auto --indent-spaces 1 --quiet yes --show-body-only auto --show-errors 0 --wrap 0 -m built/$(name)-web-standard/*.html
#	-utf8 ?
#Use a serif font in the standard web format
	cp $(HOME)/../../assets/additionalstandard.css built/$(name)-web-standard/
	mv *.css built/$(name)-web-standard/
	if ls ./figures/eps/*.svg 1> /dev/null 2>&1; then cp ./figures/eps/*.svg built/$(name)-web-standard/figures/eps/; fi
	if ls ./figures/latexpdfsvg/*.svg 1> /dev/null 2>&1; then cp ./figures/latexpdfsvg/*.svg built/$(name)-web-standard/figures/latexpdfsvg/; fi
	if ls ./figures/pdf/*.svg 1> /dev/null 2>&1; then cp ./figures/pdf/*.svg built/$(name)-web-standard/figures/pdf/; fi
	if ls ./figures/png/*.png 1> /dev/null 2>&1; then cp ./figures/png/*.png built/$(name)-web-standard/figures/png/; fi
	if ls ./figures/jpg/*.jpg 1> /dev/null 2>&1; then cp ./figures/jpg/*.jpg built/$(name)-web-standard/figures/jpg/; fi
	if ls ./figures/svg/*.svg 1> /dev/null 2>&1; then cp ./figures/svg/*.svg built/$(name)-web-standard/figures/svg/; fi
#	[ ! -e ./$(name)-web0x.interim.png ] || mv $(name)-web*.png built/$(name)-web/
	[ ! -e ./$(name)*svg ] || mv $(name)*svg built/$(name)-web-standard/
	cd built; [ ! -f $(name)-web-standard.zip ] || rm -f $(name)-web-standard.zip; zip -r $(name)-web-standard.zip $(name)-web-standard; cd ..
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf


#To transform to Word we need to use the web transform but without breaking into sections and then use Pandoc 19+
word: clean $(name)-cont-web-clean.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
ifeq ($(FLEQN),fleqn)
	cp $(HOME)/../../assets/mathml-fleqn.4ht ./mathml.4ht
else
	cp $(HOME)/../../assets/mathml.4ht .
endif
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
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
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(BIBTEX) $(name)-word || true
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
	$(HOME)/../TeX4htPostprocessing/postprocessWordFB.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.docx --reference-doc=$(HOME)/../../assets/reference.docx
	mv $(name)-word.docx built/
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

wordtest: clean $(name)-cont-web-clean.tex
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
ifeq ($(FLEQN),fleqn)
	cp $(HOME)/../../assets/mathml-fleqn.4ht ./mathml.4ht
else
	cp $(HOME)/../../assets/mathml.4ht .
endif
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Set up for the word version
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\togglefalse{clearprint}\\\\toggletrue{web}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(HOME)/../TeX4htPostprocessing/postprocessWordFB.sh ./
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

#To transform to Word we need to use the web transform but without breaking into sections and then use Pandoc 19+
wordsloppy: clean $(name)-cont-web-clean.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
ifeq ($(FLEQN),fleqn)
	cp $(HOME)/../../assets/mathml-fleqn.4ht ./mathml.4ht
else
	cp $(HOME)/../../assets/mathml.4ht .
endif
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
#Not sure if this is necessary. It was on ONE example, doctoral writing thing by EHC. This should be investigated.
	cp $(HOME)/../../assets/additionalfix.css additional.css
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
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
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
#	$(HOME)/../TeX4htPostprocessing/postprocessWordFB.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.docx --reference-doc=$(HOME)/../../assets/reference.docx
	mv $(name)-word.docx built/
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

#This is an experiment
#To transform to markdown we need to use the web transform but without breaking into sections and then use Pandoc 19+
markdown: clean $(name)-cont-web-clean.tex
	mkdir -p built 
#Copy some files to where we need them
	cp $(HOME)/../../styles/* . 
	cp $(HOME)/../../fonts/* .
ifeq ($(FLEQN),fleqn)
	cp $(HOME)/../../assets/mathml-fleqn.4ht ./mathml.4ht
else
	cp $(HOME)/../../assets/mathml.4ht .
endif
	cp $(HOME)/../../assets/listings.4ht .
	cp $(HOME)/../../assets/unicode.4hf .
	cp $(HOME)/../../assets/mathjaxMMLWord.cfg .
	cp $(HOME)/../../assets/additional.css .
#Make any pdf_tex figures
#	$(HOME)/../graphicx/buildfigure.sh ./
#Make any tikz figures etc.
	[ ! -f toggle.tex ] || rm -f toggle.tex
	echo "\\\\toggletrue{clearprint}\\\\togglefalse{web}\\\\toggletrue{figures}\\\\togglefalse{large}\\\\toggletrue{word}" > toggle.tex
	[ ! -f $(name)-word.tex ] || rm -f $(name)-word.tex
ifeq ($(UNKN),false)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-clean}" > $(name)-word.tex
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
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
else
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(TYPE)}\\\\def\\\\unknownclass{$(UNKN)}\\\\def\\\\originalclass{$(TYPE)}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
ifeq ($(TYPE),beamer)
	echo "\\\\def\\\\pointsize{12pt}\\\\def\\\\class{$(ALTT)}\\\\def\\\\beamerslides{true}\\\\def\\\\fleqn{$(FLEQN)}\\\\def\\\\colorhere{$(COLORHERE)}\\\\def\\\\beamerfix{unknownkeysallowed}\\\\input{master}\\\\usepackage{$(DIS)}\\\\input{$(name)-cont-web-clean}" > $(name)-word.tex
endif
#htlatex needs to run twice to prevent disruption to the sectioning tree caused by e.g. footnotes
#Note, yes this does run latex 6 times! It is a reported bug: https://puszcza.gnu.org.ua/bugs/index.php?197
#Note that we are not breaking into sections for the Word transform
#fn-in stops us from losing the footnotes in the Word format: https://tex.stackexchange.com/questions/195551/how-to-add-footnotes-in-htlatex-via-fn-in
#We need to use early_ and early^ so that the author doesn't need to do anything special for macros
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
	$(BIBTEX) $(name)-word || true
	$(HTLATEX) $(name)-word.tex "mathjaxMMLWord.cfg,sections+,fonts-,fn-in,early_,early^,charset=utf-8,old-longtable" " -cunihtf -utf8"
#Change the endings from interim to svg - this should not be doing anything any more after fix via .env
#	sed -i "s/x.interim.png/x.svg/" *.html
#The postprocess is slow, required to produce numbers rather than digits when spoken aloud but requires correct
#html output. Such things as unmatched brackets can cause problems. If you can't locate the error or the 
#Word document does not come out as expected then please report to Emma Cliffe
	$(HOME)/../TeX4htPostprocessing/postprocessWordFB.sh ./
#To get styled theorems we are going to need to do something like http://pandoc.org/MANUAL.html#custom-styles-in-docx-output but this will require us to do some nasty poking.
	pandoc -s -f html -t docx $(name)-word.html -o $(name)-word.md 
	mv $(name)-word.md built/
#Tidy up a bit
	@rm mathml.4ht
	@rm unicode.4hf
	@rm mathjaxMMLWord.cfg
	@rm additional.css
	@rm bbmone.* fakeframed.* figurefix.sty fontfix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* parfix.* stmaryrd.4ht beamerfix.* colorfix.* tuftefix.sty *disclaimer.sty algorithmicfix.*
	@rm *.htf

deliver: 
#Creating a zip for ease of upload or sending
	[ ! -d built/$(name)-all/ ] || rm -r built/$(name)-all/
	cp -r built/$(name)-web/ built/$(name)-all/
	cp -r built/$(name)-web-single/ built/$(name)-all/
	cp built/$(name)-standard.pdf built/$(name)-all/
	cp built/$(name)-clear.pdf built/$(name)-all/
	cp built/$(name)-large.pdf built/$(name)-all/
	cp built/$(name)-word.docx built/$(name)-all/
	cp $(HOME)/../../assets/index.html built/$(name)-all/
	sed -i "s/NOTESNAME/$(name)/" built/$(name)-all/index.html
	cd built; [ ! -f $(name)-all.zip ] || rm -f $(name)-all.zip; zip -r $(name)-all.zip $(name)-all; cd ..

deliverhandout: 
#Creating a zip for ease of upload or sending
	[ ! -d built/$(name)-handout/ ] || rm -r built/$(name)-handout/
	cp -r built/$(name)-web/ built/$(name)-handout/
	cp built/$(name)-standard.pdf built/$(name)-handout/
	cp built/$(name)-clear.pdf built/$(name)-handout/
	cp built/$(name)-large.pdf built/$(name)-handout/
	cp built/$(name)-word.docx built/$(name)-handout/
	cp $(HOME)/../../assets/index-handout.html built/$(name)-handout/index.html
	sed -i "s/NOTESNAME/$(name)/" built/$(name)-handout/index.html
	cd built; [ ! -f $(name)-handout.zip ] || rm -f $(name)-handout.zip; zip -r $(name)-handout.zip $(name)-handout; cd ..


clean:
	@rm -f  *.css *.aux *.log *.toc *~ *.out *.html *.4ct *.4tc *.dvi *.idv *.tmp* *.xref *.lg *.lof *.lot *x.interim.png *x.svg *.4ht *-lp1 *-lp0 bbmone.* fakeframed.sty figurefix.sty largeprevent.sty MnArrowsWeb.* notsoclever.sty notitlesec.sty webfix.* webprevent.sty displayoperators.* *.nav *.snm colorfix.sty fontfix.sty parfix.sty beamerfix.sty *-pics*.pdf tuftefix.sty *.htf algorithmicfix.* *.bbl

cleaner:
	@rm -f *-cont.tex *-standard.tex *-clear.tex *-large.tex *-web.tex *-word.tex toggle.tex choices.tex *-lp*.tex *-figures.tex *_tex-lp macros.tex demacro-private.sty *-cont* *-co *.pre zz*-web* *.pdf_tex.tex *.pdf_tex-clean.tex *.web.tex *-web-standard.tex

revert:
	@[ ! -f *.origin ] || rename -f 's/origin/tex/' *.origin
	@rm -f *.parens

cleanfigures: 
	@rm -f ./figures/svg/*.pdf
	@rm -f ./figures/eps/*.svg
	@rm -f ./figures/pdf/*.svg
