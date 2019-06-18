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
mathmiddle ("&"|"\\\\")
protect ("\\left"|"\\right"|"\\big"|"\\Big"|"\\bigg"|"\\Bigg"|"\\bigr"|"\\bigl"|"\\Bigl"|"\\Bigr"|"\\biggl"|"\\biggr"|"\\Biggl"|"\\Biggr")("|"|"\\|"|"\\vert"|"\\Vert")

%x COMMENT VERBATIM MATHS BAR VBAR BARBAR VBARBAR MATCH CHECK TOOMANY
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
<MATHS>"\\|" yy_push_state(BARBAR);
<MATHS>"|" yy_push_state(BAR);
<MATHS>"\\vert" yy_push_state(VBAR);
<MATHS>"\\Vert" yy_push_state(VBARBAR);
<MATHS,TOOMANY>{mathsend}/(" ")*{newline} ECHO; commentcheck(0); yy_pop_state();
<MATHS,TOOMANY>{mathsend} ECHO; commentcheck(1); yy_pop_state();

 /* Not sure whether this is context safe when there is no match */
<BARBAR>[^|]*{mathsend} printf("\\|"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<BARBAR>(.*)"\\|"(.*)"\\|"[^\\]* printf("\\|"); ECHO; yy_pop_state(); check = 1; yy_pop_state(); yy_push_state(TOOMANY);
<BARBAR>(.*)/"\\|" printf("\\left\\|"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<BARBAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERTS");

<BAR>[^|]*{mathsend} printf("|"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<BAR>[^|\\]*[^\\]"|"[^|\\]*[^\\]"|"[^\\]* printf("|"); ECHO; yy_pop_state(); check = 1; yy_pop_state(); yy_push_state(TOOMANY); 
<BAR>[^|\\]*/"|" printf("\\left|"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<BAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERTS");

<VBAR>([^v]|v([^e]|e([^r]|r[^t])))*{mathsend} printf("\\vertHERE"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<VBAR>(.*)"\\vert"(.*)"\\vert"[^\\]* printf("\\vert"); ECHO; yy_pop_state(); check = 1; yy_pop_state(); yy_push_state(TOOMANY); 
<VBAR>(.*)/"\\vert" printf("\\left\\vert"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<VBAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERTS");

<VBARBAR>[^Vert]*{mathsend} printf("\\Vert"); ECHO; yy_pop_state(); check = 1; commentcheck(0); yy_pop_state();
<VBARBAR>(.*)"\\Vert"(.*)"\\Vert"[^\\]* printf("\\Vert"); ECHO; yy_pop_state(); check = 1; yy_pop_state(); yy_push_state(TOOMANY); 
<VBARBAR>(.*)/"\\Vert" printf("\\left\\Vert"); ECHO; printf("\\right"); yy_pop_state(); check = 1; yy_push_state(MATCH);
<VBARBAR>{mathsend} ECHO; printf("%%%%%%%% SOMETHING HAS GONE WRONG WITH VERTS");

<MATCH>("|"|"\\|"|"\\vert"|"\\Vert") ECHO; check = 1; yy_pop_state(); 

%%

int commentcheck(int newline){
  if(check == 1){
    printf("%%%%%%%% check the verticals");
    check = 0;
    if(newline == 1)
      printf("\n");
  }
  return 0;
}



