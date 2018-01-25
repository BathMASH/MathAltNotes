%option stack

whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}

%x COMMENT VERBATIM
%%

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();
 /*We need to ensure that comments are not processed */
"\\\\" ECHO; /* protect */
"\\%" ECHO; /* protect */
(\r?\n)"%" yy_push_state(COMMENT);
"%" yy_push_state(COMMENT); 
<COMMENT>(\r?\n)/"%" 
<COMMENT>(\r?\n){whitespace}* printf("\n"); yy_pop_state();
<COMMENT>.


 /*Just in case*/
\r?\n printf("\n"); 

