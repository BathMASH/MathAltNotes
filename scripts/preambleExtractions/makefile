
all: extract macro extract-sty

extract: extract.lex
	flex extract.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c

macro: macro.lex
	flex macro.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c

extract-sty: extract-sty.lex
	flex extract-sty.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c
