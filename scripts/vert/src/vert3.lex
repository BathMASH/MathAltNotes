%option stack
%{
int check = 0;
int lone = 0;
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

%x COMMENT VERBATIM MATHS BAR BARBAR MATCH TOOMANY BAIL
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
{mathstart} ECHO; yy_push_state(MATHS);
<MATHS>("%")[^\n]* ECHO;
<MATHS>{protect} ECHO;
<MATHS>"\\|"[^&\n]*"\\|"[^&\n]*"\\|"[^\\&]* /*printf("TBB");*/ ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS>"|"[^&\n]*"|"[^&\n]*"|"[^\\&]* /*printf("TB");*/ ECHO; check = 2; yy_push_state(TOOMANY);
<MATHS>"|"[^|\n]*{mathsend}[^|\n]*/"|" ECHO; if(check != 2) check = 1; yy_push_state(BAIL);
<MATHS>"\\|"[^|\n\]\)\}]*/"\\|" yy_push_state(MATCH); /*printf("BB");*/ printf("\\left"); ECHO; 
<MATHS>"|"[^|\n\]\)\}]*/"|" yy_push_state(MATCH); /*printf("B");*/ printf("\\left"); ECHO;
<MATHS>"|"[^|\n]*\n ECHO; if(check != 2) check = 3;
<MATHS>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); yy_pop_state();
<MATHS>{mathsend} ECHO; commentcheck(1); yy_pop_state();

<TOOMANY>"\\\\" ECHO; yy_pop_state();
<TOOMANY>"&" ECHO; yy_pop_state();
<TOOMANY>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); yy_pop_state(); yy_pop_state();
<TOOMANY>{mathsend} ECHO; commentcheck(1); yy_pop_state(); yy_pop_state();

<BAIL>\n commentcheck(1); yy_pop_state(); yy_pop_state();

<MATCH>("|"|"\\|") printf("\\right"); ECHO; if(check == 0) check = 1; yy_pop_state(); /*printf("M");*/

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
