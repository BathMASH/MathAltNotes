%option stack
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
mathstart "\\begin"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}
mathsend "\\end"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}

%x COMMENT VERBATIM MATHS
%%

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
<MATHS>("%")[^\n]* //yy_push_state(COMMENT);
<MATHS>(\r?\n) printf(" ");
<MATHS>{mathsend} ECHO; yy_pop_state();

 /*Just in case*/
\r?\n printf("\n"); 

