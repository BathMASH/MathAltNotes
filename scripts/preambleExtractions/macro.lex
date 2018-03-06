%option stack
%{
int brackets = 0;
%}
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
ls ([[:blank:]])*"["([[:blank:]])*
rs ([[:blank:]])*"]"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
newcommand ("\\newcommand"|"\\renewcommand")

%x COMMENT VERBATIM NEWCOMMAND
%%

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();

 /*We need to ensure that comments are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) ECHO; yy_pop_state();

{newcommand}{lb}([^"{""}"]*){rb}("["(.*)"]")*{lb} ECHO; brackets=1; yy_push_state(NEWCOMMAND);
<NEWCOMMAND>{rb} ECHO; brackets=brackets-1; if(brackets == 0) yy_pop_state();
<NEWCOMMAND>{lb} ECHO; brackets=brackets+1;
<NEWCOMMAND>("%")[^\n]* 
<NEWCOMMAND>(\r?\n) printf(" ");

 /*Just in case*/
\r?\n printf("\n"); 
