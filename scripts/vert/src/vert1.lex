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

%x COMMENT VERBATIM MATHS
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
<MATHS>"\\vert" printf("|");
<MATHS>"\\Vert" printf("\\|");
<MATHS>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); yy_pop_state();
<MATHS>{mathsend} ECHO; commentcheck(1); yy_pop_state();

%%

int commentcheck(int newline){
  if(check == 1){
    printf("%%%%%%%% (v|V)ert should be | or \\|");
    check = 0;
    if(newline == 1)
      printf("\n");
  }
  return 0;
}



