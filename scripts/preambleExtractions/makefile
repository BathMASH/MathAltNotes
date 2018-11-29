
all: extract macro

extract: extract.lex
	flex extract.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c

macro: macro.lex
	flex macro.lex
	gcc lex.yy.c -lfl -Wno-implicit-function-declaration -o $@
	rm lex.yy.c
