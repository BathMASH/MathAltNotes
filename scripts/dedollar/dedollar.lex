%option stack
%{
int brackets = 0;
%}
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("verbatim"){rb}
dropmath ("\\text"{lb}|"\\intertext"{lb})
toc ("\\chapter"|"\\section"|"\\subsection"|"\\subsubsection"|"\\caption")
figstart "\\begin"{lb}("figure"){rb}
figend "\\end"{lb}("figure"){rb}

%x COMMENT VERBATIM SINGLEDOLLAR DOUBLEDOLLAR DROPMATH TOC FIG
%%

("\\$") ECHO; /* protect */

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();

 /* We need to leave the $ in these alone */
{toc}(("[")(.*)("]"))*{lb} ECHO; brackets = 1; yy_push_state(TOC);
<TOC>{lb} ECHO; brackets = brackets+1;
<TOC>{rb} ECHO; brackets = brackets-1; if(brackets==0) yy_pop_state();

{figstart} ECHO; yy_push_state(FIG);
<FIG>{figend} ECHO; yy_pop_state();

 /*We need to ensure that comments are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) ECHO; yy_pop_state();

<INITIAL,DROPMATH>"$$" printf("\\["); yy_push_state(DOUBLEDOLLAR);
<INITIAL,DROPMATH>"$" printf("\\("); yy_push_state(SINGLEDOLLAR);

<SINGLEDOLLAR>"$" printf("\\)"); yy_pop_state();
<DOUBLEDOLLAR>"$$" printf("\\]"); yy_pop_state(); 

<SINGLEDOLLAR,DOUBLEDOLLAR>{dropmath} ECHO; yy_push_state(DROPMATH);
<DROPMATH>([^$]*){rb} ECHO; yy_pop_state();

 /*Just in case*/
\r?\n printf("\n"); 

