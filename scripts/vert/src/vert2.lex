%option stack
%{
int check = 0;
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

%x COMMENT VERBATIM MATHS BAR BARBAR MATCH TOOMANY 
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

  /* We need this to work on maths lines not between newlines */
{mathstart} ECHO; yy_push_state(MATHS);
<MATHS>("%")[^\n]* ECHO;
<MATHS>{protect} ECHO;
<MATHS>"\\|" yy_push_state(BARBAR); printf("BB"); 
<MATHS>"|" yy_push_state(BAR); printf("B");
<MATHS,TOOMANY>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); yy_pop_state();
<MATHS,TOOMANY>{mathsend} ECHO; commentcheck(1); yy_pop_state();

<TOOMANY>"\\\\" ECHO; yy_pop_state();
<TOOMANY>"&" ECHO; yy_pop_state();

 /* Not sure whether this is context safe when there is no match */
<BARBAR>[^|\n]*"\\n" printf("\\|"); printf("L"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<BARBAR>[^&\n]*"\\|"[^&\n]*"\\|"[^\\&]* printf("\\|"); printf("T"); ECHO; yy_pop_state(); check = 2; yy_pop_state(); yy_push_state(TOOMANY);
<BARBAR>[^|\n]*/"\\|" printf("\\left\\|"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<BARBAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERT");

<BAR>[^|\n]*"\\n" printf("|"); printf("L"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<BAR>[^&\n]*"|"[^&\n]*"|"[^\\&]* printf("|"); printf("T"); ECHO;  yy_pop_state(); check = 2; yy_pop_state(); yy_push_state(TOOMANY); 
<BAR>[^|\n]*/"|" printf("\\left|"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<BAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERT");

<MATCH>("|"|"\\|") ECHO; check = 1; yy_pop_state(); printf("M");

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
  return 0;
}



