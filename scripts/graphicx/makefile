
all: swaptoweb swaptopdf

swaptoweb: swaptoweb.lex
	flex swaptoweb.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c

swaptopdf: swaptopdf.lex
	flex swaptopdf.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c

