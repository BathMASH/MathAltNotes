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
ls ([[:blank:]])*"["([[:blank:]])*
rs ([[:blank:]])*"]"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
mathstart ("\\("|"\\["|"\\begin"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb})
mathsend ("\\)"|"\\]"|"\\end"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb})
protect ("\\left"|"\\right"|"\\big"|"\\Big"|"\\bigg"|"\\Bigg"|"\\bigr"|"\\bigl"|"\\Bigl"|"\\Bigr"|"\\biggl"|"\\biggr"|"\\Biggl"|"\\Biggr")("|"|"\\|"|"\\vert"|"\\Vert")
tables ("\\begin"{lb}("tabular"){rb}{ls}[^\]]{rs})

%x COMMENT VERBATIM MATHS BAR BARBAR MATCH TOOMANY BAIL PAREN SQUARE BRACE TABLES
%%

"\\\\[" ECHO;
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
{mathstart} ECHO; yy_push_state(MATHS); if(debug) printf("MS");
<MATHS,PAREN,SQUARE,BRACE>{tables} ECHO; BEGIN(INITIAL); /* Some people put tables in maths... */
<MATHS,PAREN,SQUARE,BRACE>("%")[^\n]* ECHO;
<MATHS,PAREN,SQUARE,BRACE>{protect} ECHO;
<MATHS>"\\|"[^&\n]*"\\|"[^&\n]*"\\|"[^\\&]* if(debug) printf("TBB"); ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS>"|"[^&\n]*"|"[^&\n]*"|"[^\\&]* if(debug) printf("TB"); ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS>"|"[^|\n]*{mathsend}[^|\n]*/"|" if(debug) printf("BAIL"); ECHO; if(check != 2) check = 1; yy_push_state(BAIL);
<MATHS>"\\|"[^|\n]*/"\\|" yy_push_state(MATCH); if(debug) printf("BB"); printf("\\left"); ECHO; 
<MATHS>"|"[^|\n]*/"|" yy_push_state(MATCH); if(debug) printf("B"); printf("\\left"); ECHO;
<MATHS>"(" if(debug) printf("P"); ECHO; yy_push_state(PAREN);
<MATHS>"[" if(debug) printf("P"); ECHO; yy_push_state(SQUARE);
<MATHS>"{" if(debug) printf("P"); ECHO; yy_push_state(BRACE);
<MATHS>"|"[^|\n]*\n ECHO; if(debug) printf("NEW"); if(check == 1) check = 3;
<MATHS>{mathsend}/(" ")*{newline} ECHO; if(debug) printf("ME"); commentcheck(0); yy_pop_state();
<MATHS>{mathsend} ECHO; if(debug) printf("ME"); commentcheck(1); yy_pop_state();

 /* In maths, brackets don't have to 'match' e.g. semiopen interval, will this breack things? */
<PAREN,SQUARE>")" if(debug) printf("C"); ECHO; yy_pop_state();
<SQUARE,PAREN>"]" if(debug) printf("C"); ECHO; yy_pop_state();
<BRACE>"}" if(debug) printf("C"); ECHO; yy_pop_state();
<PAREN,SQUARE,BRACE>"\\|"[^&\n\)\]\}\(\[\{]*"\\|"[^&\n\)\]\}\(\[\{]*"\\|"[^\\&]* if(debug) printf("PTBB"); ECHO; check = 2; yy_push_state(TOOMANY);
<PAREN,SQUARE,BRACE>"|"[^&\n\)\]\}\(\[\{]*"|"[^&\n\)\]\}\(\[\{]*"|"[^\\&]* if(debug) printf("PTB"); ECHO; check = 2; yy_push_state(TOOMANY);
<PAREN,SQUARE,BRACE>"\\|"[^|\n\)\]\}\(\[\{]*/"\\|" yy_push_state(MATCH); if(debug) printf("PBB"); printf("\\left"); ECHO; 
<PAREN,SQUARE,BRACE>"|"[^|\n\)\]\}\(\[\{]*/"|" yy_push_state(MATCH); if(debug) printf("PB"); printf("\\left"); ECHO;
<PAREN,SQUARE,BRACE>"|"[^|\n\)\]\}\(\[\{]* ECHO; if(check == 0) check = 5;
<PAREN,SQUARE,BRACE>"\\right." ECHO; yy_pop_state();
<PAREN,SQUARE,BRACE>"(" ECHO; if(debug) printf("PP"); if(check != 0) check = 4; yy_push_state(PAREN); 
<PAREN,SQUARE,BRACE>"[" ECHO; if(debug) printf("PP"); if(check != 0) check = 4; yy_push_state(SQUARE);
<PAREN,SQUARE,BRACE>"{" ECHO; if(debug) printf("PP"); if(check != 0) check = 4; yy_push_state(BRACE);

<TOOMANY>"\\\\" ECHO; yy_pop_state();
<TOOMANY>"&" ECHO; yy_pop_state();
<TOOMANY>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); BEGIN(INITIAL); /*yy_pop_state(); yy_pop_state();*/
<TOOMANY>{mathsend} ECHO; commentcheck(1); BEGIN(INITIAL); /*yy_pop_state(); yy_pop_state();*/

<BAIL>\n commentcheck(1); yy_pop_state(); yy_pop_state();

<MATCH>("|"|"\\|") printf("\\right"); ECHO; if(check == 0) check = 1; yy_pop_state(); if(debug) printf("M");

%%

int commentcheck(int newline){
  if(check == 1)
    printf("%%%%%%%% Check syntactic interpretation of verticals");
  if(check == 2)
    printf("%%%%%%%% Please add \\left and \\right to all verticals, this is probably a syntactically ambiguous case");
  if(check == 3)
    printf("%%%%%%%% Please add \\left and \\right to all verticals, this is syntactically ambiguous due to linebreaks");
  if(check == 4)
    printf("%%%%%%%% Please add \\left and \\right to all verticals, this may be syntactically ambiguous and was abandoned due to bracketing depth");
  if(newline == 1 && check != 0)
    printf("\n");
  check = 0;
  return 0;
}
