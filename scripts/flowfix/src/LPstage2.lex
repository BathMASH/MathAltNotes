%option stack
%{
int normalsize = 17;
double factor = 1.4;
double cols = 0.8;
double margins = 2.5;
double lines = 1.25;
double mathlines = 1.25;
char pagesize[7];
int breqn = 1;
int font = 0;
int bracketmatch = 0;
int bettergraphics = 0;
%}
whitespace (" "|\t|(\r?\n))
alpha ([A-Za-z])
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
packages ("\\usepackage")("["*)(.*)("]"*){lb}
verbstart "\\begin"{lb}("verbatim"){rb}
verbend "\\end"{lb}("tabbing"){rb}
tabbingstart "\\begin"{lb}("tabbing"){rb}
tabbingend "\\end"{lb}("verbatim"){rb}
dmathstart "\\begin"{lb}("equation"){rb}
dmathend "\\end"{lb}("equation"){rb}
dmathstarstart ("$$"|"\\["|"\\begin"{lb}("equation*"|"displaymath"){rb})
dmathstarend ("$$"|"\\]"|"\\end"{lb}("equation*"|"displaymath"){rb})
dseriesstarstart "\\begin"{lb}("multline*"|"gather*"){rb}
dseriesstarend "\\end"{lb}("multline*"|"gather*"){rb}
dseriesstart "\\begin"{lb}("multline"){rb}
dseriesend "\\end"{lb}("multline"){rb}
dgroupnoalignstart "\\begin"{lb}("gather"){rb}
dgroupstarstart "\\begin"{lb}(("eqnarray*"|"align*"|"flalign*"){rb}|("alignat*"{rb}{lb}(.*){rb}))
dgroupstarend "\\end"{lb}("eqnarray*"|"align*"|"flalign*"|"alignat*"){rb}
dgroupstart "\\begin"{lb}(("eqnarray"|"align"|"flalign"){rb}|("alignat"{rb}{lb}(.*){rb}))
dgroupend "\\end"{lb}("eqnarray"|"align"|"flalign"|"alignat"|"gather"){rb}
arraystart ("\\begin"{lb}("array"){rb}{lb}|"\\begin"{lb}("matrix"|"pmatrix"|"bmatrix"|"Bmatrix"|"vmatrix"|"Vmatrix"|"smallmatrix"|"cases"){rb}) 
arrayend "\\end"{lb}("array"|"matrix"|"pmatrix"|"bmatrix"|"Bmatrix"|"vmatrix"|"Vmatrix"|"smallmatrix"|"cases"){rb}
tablestart "\\begin"{lb}("table"){rb}("["*)(.*)("]"*)
tableend "\\end"{lb}("table"){rb}
tabustart "\\begin"{lb}("tabular"|"longtable"){rb}
tabuend "\\end"{lb}("tabular"|"longtable"){rb}
tabularxstart "\\begin"{lb}("tabularx"|"tabu"|"largetabular"){rb}
tabularxend "\\end"{lb}("tabularx"|"tabu"|"largetabular"){rb}
newenvironment "\\newenvironment"

%x COMMENT INPUT CLASS DMATH DMATHSTAR DGROUPSTAR DGROUP DSERIES DSERIESSTAR PACKAGES VERBATIM TABU ARRAY SPLIT TAG LABEL INTERTEXT CHECKSTAR GRAPHICS TABULARX CAPTION NEWENVIR TABBING CASES
%s REMOVE KEEP TABLE
%%

("$"|"\\$") ECHO; /* protect */
("\\\\[") ECHO; /* protect */

 /*We need to ensure that comments are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) ECHO; yy_pop_state();

 /* Protect newenvironments until we know otherwise */
{newenvironment} ECHO; yy_push_state(NEWENVIR); yy_push_state(NEWENVIR);
<NEWENVIR>{lb} ECHO; bracketmatch++; 
<NEWENVIR>{rb} ECHO; bracketmatch--; if(bracketmatch==0) yy_pop_state();

{packages} ECHO; yy_push_state(PACKAGES);
<PACKAGES>("spverbatim") ECHO;
<PACKAGES>("verbatim") printf("spverbatim");
<PACKAGES>{rb} ECHO; yy_pop_state();

("\\begin"{lb}("document"){rb}) printf("\\usepackage{calc}\n\\usepackage{longtable}\n\\usepackage{tabu}\n\\usepackage{breqn}\n\\setlength{\\arraycolsep}{%lfem}\n\\renewcommand{\\arraystretch}{%lf}\n\\begin{document}\n\\renewcommand{\\baselinestretch}{%lf}\n\\selectfont\n\\setlength{\\parskip}{1.0\\baselineskip}\n",cols,factor,lines); 

{verbstart} printf("\\begin{spverbatim}"); yy_push_state(VERBATIM);
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
<VERBATIM>{verbend} printf("\\end{spverbatim}"); yy_pop_state();

"\\verb" printf("\\spverb"); matchverbchar(); 

{tabbingstart} ECHO; yy_push_state(TABBING);
<TABBING>(\r?\n) printf("\n"); /*Just in case*/
<TABBING>{tabbingend} ECHO; yy_pop_state();

 /*("\\input"{lb})(.*)/("_tex") ECHO;*/
("\\input"{lb}) ECHO; yy_push_state(INPUT);
<INPUT>{rb} printf("-lp"); ECHO; yy_pop_state();

<ARRAY>{arrayend} ECHO; yy_pop_state();

 /* Rules possibly used in several multi-line situations */
<CHECKSTAR>("\\notag"|"\\nonumber"|"\\intertextend")
<DGROUPSTAR,DGROUP,CHECKSTAR,SPLIT>("&") printf(" "); /*printf("\\ ");*/
<DMATHSTAR,DSERIESSTAR,DGROUPSTAR,DMATH,DSERIES,DGROUP,CHECKSTAR,SPLIT,ARRAY>{arraystart} ECHO; yy_push_state(ARRAY); /* protect */
<DSERIESSTAR,DSERIES>("\\\\") printf("\\end{math}\\\\\\begin{math}");
<DGROUPSTAR>("\\\\") printf("\\end{dmath*}\\begin{dmath*}");
<DGROUP,CHECKSTAR>("\\\\")/({whitespace}*("\\tag"|"\\label")) if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); printf("\\begin{dmath}[");
<DGROUP,CHECKSTAR>("\\\\")/({whitespace}*("\\notag"|"\\nonumber")) if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); printf("\\begin{dmath*}"); yy_push_state(CHECKSTAR);
<DGROUP,CHECKSTAR>("\\\\") if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); printf("\\begin{dmath}");

<DSERIESSTAR,DSERIES>("\\intertext")(.*)/("\\intertextend") printf("\\end{math}"); ECHO; printf("\\\\\\begin{math}");
<DGROUPSTAR>("\\intertext")(.*)/("\\intertextend") printf("\\end{dmath*}"); ECHO; printf("\\begin{dmath*}");
<DGROUP,CHECKSTAR>("\\intertext")(.*)/("\\intertextend\\notag") if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); ECHO; printf("\\begin{dmath*}"); yy_push_state(CHECKSTAR);
<DGROUP,CHECKSTAR>("\\intertext")(.*)/("\\intertextend\\nonumber") if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); ECHO; printf("\\begin{dmath*}"); yy_push_state(CHECKSTAR);
<DGROUP,CHECKSTAR>("\\intertext")(.*)/("\\intertextend") if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); ECHO; 
<DGROUP>("\\intertextend")/({whitespace}*("\\tag"|"\\label")) printf("\\begin{dmath}[");
<DSERIESSTAR,DSERIES,DGROUPSTAR,DGROUP>("\\intertextend") if (YY_START == DGROUP) printf("\\begin{dmath}");

<DMATH,DMATHSTAR,DSERIES,DSERIESSTAR,DGROUP,CHECKSTAR,DGROUPSTAR>("\\begin"{lb}("split"){rb}) yy_push_state(SPLIT);
<SPLIT>("\\end"{lb}("split"){rb}) yy_pop_state();

 /* Unnumbered */

    /* Single line displayed was 20pt*/
{dmathstarstart} printf("\\begin{dmath*}[compact,spread={%lf\\baselineskip}]",mathlines); yy_push_state(DMATHSTAR); 
<DMATHSTAR>{dmathstarend} printf("\\end{dmath*}"); yy_pop_state();

    /* Multi-line without alignment */
{dseriesstarstart} printf("\\begin{dseries*}[compact,spread={%lf\\baselineskip}]\\begin{math}",mathlines); yy_push_state(DSERIESSTAR);
<DSERIESSTAR>{dseriesstarend} printf("\\end{math}\\end{dseries*}"); yy_pop_state();

    /* Multi-line with alignment */
{dgroupstarstart} printf("\\begin{dgroup*}[compact,spread={%lf\\baselineskip}]\\begin{dmath*}",mathlines); yy_push_state(DGROUPSTAR);
<DGROUPSTAR>{dgroupstarend} printf("\\end{dmath*}\\end{dgroup*}"); yy_pop_state();


 /* Numbered */
   /* Lines with tags have them at the start of the line now (see stage0)*/ 
     /* Single line displayed was 20pt*/ 
{dmathstart}/({whitespace}*("\\tag"|"\\label")) printf("\\begin{dmath}[compact,spread={%lf\\baselineskip}",mathlines); yy_push_state(DMATH); 
{dmathstart} printf("\\begin{dmath}[compact,spread={%lf\\baselineskip}]",mathlines); yy_push_state(DMATH); 
<DMATH>{dmathend} printf("\\end{dmath}"); yy_pop_state();

    /* Multi-line without alignment */
    /* Need to check if you can have tags in the things that become this env and if you do then what should happen */
    /* This will effectively ignore things like shoveleft in multline but they also won't impact on ability to reflow */
{dseriesstart} printf("\\begin{dseries}[compact,spread={%lf\\baselineskip}]\\begin{math}",mathlines); yy_push_state(DSERIES);
<DSERIES>{dseriesend} printf("\\end{math}\\end{dseries}"); yy_pop_state();

     /* Multi-line with alignment */
{dgroupstart}/({whitespace}*("\\notag"|"\\nonumber")) printf("\\begin{dgroup*}[compact,spread={%lf\\baselineskip}]\\begin{dmath*}",mathlines); yy_push_state(DGROUP); yy_push_state(CHECKSTAR); 
{dgroupstart}/({whitespace}*("\\tag"|"\\label")) printf("\\begin{dgroup*}[compact,spread={%lf\\baselineskip}]\\begin{dmath}[",mathlines); yy_push_state(DGROUP); 
{dgroupstart} printf("\\begin{dgroup*}[compact,spread={%lf\\baselineskip}]\\begin{dmath}",mathlines); yy_push_state(DGROUP); 
{dgroupnoalignstart} printf("\\begin{dgroup*}[noalign,compact,spread={%lf\\baselineskip}]\\begin{dmath}[",mathlines); yy_push_state(DGROUP); 
<DGROUP,CHECKSTAR>{dgroupend} if (YY_START == CHECKSTAR) {printf("\\end{dmath*}"); yy_pop_state();} else printf("\\end{dmath}"); printf("\\end{dgroup*}"); yy_pop_state();


<DMATH,DGROUP>"\\tag"{lb} yy_push_state(TAG);
<DMATH,DGROUP>"\\label"{lb} yy_push_state(LABEL);

 /* Should this be inside the breqn or outside? */
<TAG,LABEL>("}")/({whitespace}*("\\tag"|"\\label")) yy_pop_state();
<TAG,LABEL>("}") yy_pop_state(); printf("]");
<TAG>(([^"}"]*)) printf(",number="); ECHO; 
<LABEL>(([^"}"]*)) printf(",label="); ECHO; 

 /* tables - we need to use longtabu and this ASSUMES there is a newline at the end of the tabular argument */
 /* Working on the assumption that if you used tabularx it was because you have a hideous wide table */
 /* We can't allow the table construct as longtabu doesn't do its job then */
{tablestart} yy_push_state(TABLE);
{tabularxstart} printf("\\newpage\\begin{landscape}\n\\begin{longtabu} to \\linewidth"); yy_push_state(TABULARX); yy_push_state(TABU);
{tabustart} printf("\\begin{longtabu} to \\textwidth"); yy_push_state(TABU);
<TABU>(("to")(([^"}"]*)))/("{") 
<TABU>("{\\linewidth}"|"{\\textwidth}")
<TABU>("@{"([^"}""{"]*)) ECHO; yy_push_state(KEEP); 
<TABU>("p{"([^"}""{"]*)) printf("X[p]"); yy_push_state(REMOVE);
<TABU>("c"|"l"|"r") printf("X["); ECHO; printf("]");
<TABU>("X") printf("X");
<TABU>("}"({whitespace}*)(\r?\n)) printf("}\n"); yy_pop_state();
  /* Only use to keep/remove a single brace that is immediately after the current matched text that does not contain a brace */
<KEEP>"}" ECHO; yy_pop_state();
<REMOVE>"}" yy_pop_state();

{tabuend} printf("\\end{longtabu}\n"); /*if (YY_START != TABLE) printf("\\end{longtabu}\n");*/
<TABLE>"\\caption" printf("Table caption: "); yy_push_state(CAPTION);/*<TABLE>"\\caption"{lb}(.*){rb} ECHO;*/ 
<CAPTION>("{"(.*))/"}" ECHO; printf("}\\addcontentsline{lot}{table}"); ECHO; printf("\\protect"); yy_pop_state();
<TABLE>{tableend} yy_pop_state();
<TABULARX>{tabularxend} printf("\\end{longtabu}\\end{landscape}\n"); yy_pop_state();

 /* graphics removed ECHO before if on the next line - is this right?*/
"\\setlength{\\unitlength}{"(.*)"}" ECHO; /*if (normalsize > 14) printf("\\setlength{\\unitlength}{%lfpt}",factor); else ECHO;*/
"\\includegraphics" if(normalsize > 14) {printf("{\\centering"); ECHO; yy_push_state(GRAPHICS);} else ECHO;
 /*<GRAPHICS>"angle"[[:blank:]]*"="[[:blank:]]*"0" if(normalsize > 14) printf("angle=90"); else ECHO; */
 /*<GRAPHICS>"\\textwidth" if(normalsize > 14) printf("\\textheight * \\real{0.9},height=\\textwidth * \\real{0.9},angle=90,keepaspectratio,"); else ECHO;*/
<GRAPHICS>{rb} if(normalsize > 14) printf("}}"); else ECHO; yy_pop_state();
<GRAPHICS>"width"(" ")*"="(.*)/(",") bettergraphics=1; if(normalsize > 14) {printf("width=\\textwidth,height=\\textheight,keepaspectratio,");} else ECHO;
<GRAPHICS>"width"(" ")*"="(.*)/("]") bettergraphics=1; if(normalsize > 14) {printf("width=\\textwidth,height=\\textheight,keepaspectratio,");} else ECHO;
 /*<GRAPHICS>"]" ECHO; yy_pop_state();*/
<GRAPHICS>{lb} if(normalsize > 14 && bettergraphics==0) printf("[width=\\textwidth,height=\\textheight,keepaspectratio,]"); bettergraphics=0; ECHO; /*yy_pop_state();*/
 /*"\\begin"{lb}"picture"{rb} if(normalsize > 14) {printf("\\begin{center}\\rotatebox{90}{"); ECHO;} else ECHO;*/
 /*"\\end"{lb}"picture"{rb} if(normalsize > 14) {ECHO; printf("}\\end{center}");} else ECHO; */


%%

int matchverbchar(){
  char match,c;
  match = input();
  printf("%c",match);
  while ((c = input()) != match)
    printf("%c",c);
  printf("%c",match);
}
