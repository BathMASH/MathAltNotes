%option stack
%{
int brackets = 0;
char verbsnap = '=';
%}
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
ls ([[:blank:]])*"["([[:blank:]])*
rb ([[:blank:]])*"}"
rs ([[:blank:]])*"]"
verbstart "\\begin"{lb}("verbatim"|"spverbatim"){rb}
verbend "\\end"{lb}("verbatim"|"spverbatim"){rb}
lstlistingstart "\\begin"{lb}("lstlisting"){rb}({ls}[^\[\]]*{rs})?
lstlistingend "\\end"{lb}("lstlisting"){rb}
dropmath ("\\text"{lb}|"\\intertext"{lb})
toc ("\\chapter"|"\\section"|"\\subsection"|"\\subsubsection"|"\\caption"|"\\chapter*"|"\\section*"|"\\subsection*"|"\\subsubsection*"|"\\subhead"|"\\subsubhead")
figstart "\\begin"{lb}("figure"|"picture"){rb}
figend "\\end"{lb}("figure"|"picture"){rb}
decthm "\\declaretheorem"{ls}

%x COMMENT VERBATIM SINGLEDOLLAR DOUBLEDOLLAR DROPMATH TOC FIG DECTHM OPTIONS LISTING
%%

("\\\\") ECHO; /* protect above the below as sometimes people write \\$ */
("\\$") ECHO; /* protect */

 /* Protect */
{verbstart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} ECHO; yy_pop_state();
 /* We need to do this separately because of the options */
{lstlistingstart} ECHO; yy_push_state(LISTING);
<LISTING>(\r?\n) printf("\n"); /*Just in case*/
<LISTING>{lstlistingend} ECHO; yy_pop_state();

"\\verb" ECHO; verbsnap=input(); printf("%c",verbsnap); findsnap();

"\\begin"{lb}(([^"}""{""["])*){rb}{ls} ECHO; yy_push_state(OPTIONS);
<OPTIONS>{rs} ECHO; yy_pop_state();

"\\begin"{lb}"frame"{rb}{lb} ECHO; brackets = 1; yy_push_state(TOC);

"\\captionof"{lb}(([^"}""{""["])*){rb}{lb} ECHO; brackets = 1; yy_push_state(TOC);

 /* We need to leave the $ in these alone {toc}(("[")(.*)("]"))*{lb} ECHO; brackets = 1; yy_push_state(TOC); */
{toc}{lb} ECHO; brackets = 1; yy_push_state(TOC);
{toc}{ls} ECHO; brackets = 0; yy_push_state(TOC); yy_push_state(OPTIONS);
<TOC>{lb} ECHO; brackets = brackets+1;
<TOC>{rb} ECHO; brackets = brackets-1; if(brackets==0) yy_pop_state();

{figstart} ECHO; yy_push_state(FIG);
<FIG>{figend} ECHO; yy_pop_state();

{decthm} ECHO; yy_push_state(DECTHM);
<DECTHM>{rs} ECHO; yy_pop_state();

<TOC,FIG,OPTIONS>("\\("|"\\)") printf("$");
<TOC,FIG,OPTIONS>("\\["|"\\]") printf("$$");

 /*We need to ensure that comments are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) ECHO; yy_pop_state();

<INITIAL,DROPMATH>"$$" printf("\\["); yy_push_state(DOUBLEDOLLAR);
<INITIAL,DROPMATH>"$" printf("\\("); yy_push_state(SINGLEDOLLAR);

<SINGLEDOLLAR,DOUBLEDOLLAR>"\\$" ECHO;
<SINGLEDOLLAR>"$" printf("\\)"); yy_pop_state();
<DOUBLEDOLLAR>"$$" printf("\\]"); yy_pop_state(); 

<SINGLEDOLLAR,DOUBLEDOLLAR>{dropmath} ECHO; yy_push_state(DROPMATH);
<DROPMATH>([^$]*){rb} ECHO; yy_pop_state();

 /*Just in case*/
\r?\n printf("\n"); 

%%

int findsnap(){
  char c;
  while( (c = input()) != verbsnap && c != EOF)
    printf("%c",c);
  if(c == verbsnap)
    printf("%c",c);
    else{
    fprintf(stderr,"There is an error in the inline verbatim workings of the dedollar script. It has hit EOF while scanning verb.");
    return 1;
  }
  return 0;
}
