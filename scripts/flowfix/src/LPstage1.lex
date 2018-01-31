%option stack
%{
int here = 0;
%}
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
mathstart "\\begin"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}
mathsend "\\end"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}

%x COMMENT VERBATIM INTER KEEP MATHS
%%

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();

 /* We need to alter some ordering so that we can process the below elements on the next run */
  /* http://flex.sourceforge.net/manual/Actions.html#Actions */ 

  /* We need this to work on maths lines not between newlines */
{mathstart} ECHO; yy_push_state(MATHS);
<MATHS>(.*)({whitespace})*("\\label"{lb}(.*){rb})/({whitespace})*("\\\\"|"\\end") switchtag(); 
<MATHS>(.*)("\\tag"{lb}(.*){rb})/({whitespace})*("\\\\"|"\\end") switchtag();
<MATHS>(.*)("\\notag")/({whitespace})*("\\\\"|"\\end") switchtag();
<MATHS>(.*)("\\nonumber")/({whitespace})*("\\\\"|"\\end") switchtag();
<MATHS>"\\\\"/(({whitespace})*"\\intertext")
<MATHS>("\\intertext"){lb} ECHO; yy_push_state(INTER);
<MATHS>("\\\\")/({whitespace})*(\r?\n) ECHO; printf("\n");
<MATHS,INTER,KEEP>(\r?\n) printf(" ");
<MATHS>{mathsend} ECHO; yy_pop_state();

 /* Have newline, intertext, no new line; need no newline, intertext, endmarker */
<INTER,KEEP>{lb} ECHO; yy_push_state(KEEP);
<KEEP>{rb} ECHO; yy_pop_state();
<INTER>{rb} ECHO; printf("\\intertextend"); yy_pop_state();

 /*Just in case*/
\r?\n printf("\n"); 

%%
 /* from http://flex.sourceforge.net/manual/Actions.html#Actions */

#include <string.h>

int switchtag(){
  int pivot =0;
  int i=yyleng;
  char *yycopy = strdup( yytext );
  while(pivot == 0){
    /*printf("%c", yycopy[i] );*/
    if(i+2<yyleng-1 && yycopy[i-1] == '\\' && yycopy[i] == 't' && yycopy[i+1] == 'a' && yycopy[i+2] == 'g')
      pivot = i-1;
    if(i+2<yyleng-1 && yycopy[i-1] == '\\' && yycopy[i] == 'l' && yycopy[i+1] == 'a' && yycopy[i+2] == 'b' && yycopy[i+3] == 'e' && yycopy[i+4] == 'l'){
      pivot = i-1;
    }
    if(i+2<yyleng-1 && yycopy[i-1] == '\\' && yycopy[i] == 'n' && yycopy[i+1] == 'o' && (yycopy[i+2] == 'n' || yycopy[i+2] == 't') && (yycopy[i+3] == 'u' || yycopy[i+3] == 'a'))
      pivot = i-1;
    i--;
  }
  for(i=pivot; i<yyleng;i++)
    printf("%c", yycopy[i] );
  printf(" ");
  for(i=0; i < pivot; i++)
    printf("%c", yycopy[i] );
  free( yycopy );
  return 1;
}
