
all: extract macro

extract: extract.lex
	flex extract.lex
	gcc lex.yy.c -lfl -o $@
	rm lex.yy.c

macro: macro.lex
	flex macro.lex
	gcc lex.yy.c -lfl -o $@
	rm lex.yy.c
