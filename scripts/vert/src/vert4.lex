%option stack
%{
int check = 0;
int lone = 0;
int debug = 0;
%}
whitespace (" "|\t|(\r?\n))
newline (\r?\n)
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
mathstart ("\\("|"\\["|"\\begin"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb})
mathsend ("\\)"|"\\]"|"\\end"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb})
protect ("\\left"|"\\right"|"\\big"|"\\Big"|"\\bigg"|"\\Bigg"|"\\bigr"|"\\bigl"|"\\Bigl"|"\\Bigr"|"\\biggl"|"\\biggr"|"\\Biggl"|"\\Biggr")("|"|"\\|"|"\\vert"|"\\Vert")

%x COMMENT VERBATIM MATHS BAR BARBAR MATCH TOOMANY BAIL PAREN SQUARE BRACE
%%

{protect} ECHO;

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();

 /*We need to ensure that comments are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) ECHO; yy_pop_state();

  /* We need this to work on maths lines not between newlines - which is not possible without pulling everything up which is too risky for now*/
<PAREN>")" if(debug) printf("EP"); ECHO; yy_pop_state();
<SQUARE>"]" if(debug) printf("ES"); ECHO; yy_pop_state();
<BRACE>"}" if(debug) printf("EBr"); ECHO; yy_pop_state();
<PAREN,SQUARE,BRACE>"\\right." ECHO; yy_pop_state();
<MATHS,PAREN,SQUARE,BRACE,TOOMANY>"(" if(debug) printf("P"); ECHO; yy_push_state(PAREN); 
<MATHS,PAREN,SQUARE,BRACE,TOOMANY>"[" if(debug) printf("S"); ECHO; yy_push_state(SQUARE);
<MATHS,PAREN,SQUARE,BRACE,TOOMANY>"{" if(debug) printf("Br"); ECHO; yy_push_state(BRACE);

{mathstart} ECHO; yy_push_state(MATHS); if(debug) printf("MS"); 
<MATHS,PAREN,SQUARE,BRACE>("%")[^\n]* ECHO;
<MATHS,PAREN,SQUARE,BRACE>{protect} ECHO;
<MATHS,PAREN,SQUARE,BRACE>"\\|"[^&\n\)\]\}\(\[\{]*"\\|"[^&\n\)\]\}\(\[\{]*"\\|"[^\\&\)\]\}\(\[\{]* if(debug) printf("TBB"); ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS,PAREN,SQUARE,BRACE>"|"[^&\n\)\]\}\(\[\{]*"|"[^&\n\)\]\}\(\[\{]*"|"[^\\&\)\]\}\(\[\{]* if(debug) printf("TB"); ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS,PAREN,SQUARE,BRACE>"|"[^|\n\)\]\}]*{mathsend}[^|\n\)\]\}]*/"|" if(debug) printf("BAIL"); ECHO; if(check != 2) check = 1; yy_push_state(BAIL);
<MATHS,PAREN,SQUARE,BRACE>"\\|"[^|\n\)\]\}]*/"\\|" yy_push_state(MATCH); if(debug) printf("BB"); printf("\\left"); ECHO; 
<MATHS,PAREN,SQUARE,BRACE>"|"[^|\n\)\]\}]*/"|" yy_push_state(MATCH); if(debug) printf("B"); printf("\\left"); ECHO;
<MATHS>"|"[^|\n]*\n ECHO; if(debug) printf("NEW"); if(check != 2) check = 3;
<MATHS>{mathsend}/(" ")*{newline} ECHO; if(debug) printf("ME"); commentcheck(0); yy_pop_state();
<MATHS>{mathsend} ECHO; if(debug) printf("ME"); commentcheck(1); yy_pop_state();

<TOOMANY>"\\\\" ECHO; yy_pop_state();
<TOOMANY>"&" ECHO; yy_pop_state();
<TOOMANY>")" if(debug) printf("TEP"); ECHO; yy_pop_state(); yy_pop_state(); yy_push_state(TOOMANY);
<TOOMANY>"]" if(debug) printf("TES"); ECHO; yy_pop_state(); yy_pop_state(); yy_push_state(TOOMANY);
<TOOMANY>"}" if(debug) printf("TEBr"); ECHO; yy_pop_state(); yy_pop_state(); yy_push_state(TOOMANY);
<TOOMANY>"\\right." ECHO; yy_pop_state(); yy_pop_state(); yy_push_state(TOOMANY);
<TOOMANY>{mathsend}/(" ")*{newline} ECHO; if(debug) printf("TME"); commentcheck(0); BEGIN(INITIAL); /*We can be in nested toomany states yy_pop_state(); yy_pop_state(); */ 
<TOOMANY>{mathsend} ECHO; if(debug) printf("TME"); commentcheck(1); BEGIN(INITIAL); /*We can be in nested toomany states yy_pop_state(); yy_pop_state(); */ 

<BAIL>\n commentcheck(1); yy_pop_state(); yy_pop_state();

<MATCH>("|"|"\\|") printf("\\right"); ECHO; if(check == 0) check = 1; yy_pop_state(); if(debug) printf("M");

%%

int commentcheck(int newline){
  if(check == 1){
    printf("%%%%%%%% Check syntactic interpretation of verticals");
    check = 0;
    if(newline == 1)
      printf("\n");
  }
  if(check == 2){
    printf("%%%%%%%% Please add \\left and \\right to all verticals, this is probably a syntactically ambiguous case");
    check = 0;
    if(newline == 1)
      printf("\n");
  }
  if(check == 3){
    printf("%%%%%%%% Please add \\left and \\right to all verticals, this is syntactically ambiguous due to linebreaks");
    check = 0;
    if(newline == 1)
      printf("\n");
  }
  return 0;
}
