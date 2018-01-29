
SDIR=./src/
BDIR=./bin/

SOURCES=$(wildcard $(SDIR)*.lex)
OBJECTS=$(patsubst $(SDIR)%,$(BDIR)%,$(patsubst %.lex,%,$(SOURCES)))

.PHONEY: all clean

all: $(BDIR) $(OBJECTS)

$(BDIR):
	mkdir $(BDIR)

$(BDIR)%: $(SDIR)%.lex
	flex $<
	gcc lex.yy.c -lfl -o $@
	@rm lex.yy.c

clean: 
	-rm $(OBJECTS) tests/*.out 
	-rm $(BDIR)/*stage*

tidy:
	rm *.aux *.toc *.log 
