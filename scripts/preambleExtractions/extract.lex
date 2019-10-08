%option stack
%{
int title = 0;
int author = 0;
int sections = 0;
int beamer = 0;
int macrolength = 0;
int beginendlength = 0;
int fontsize = 10;
int papersize = 0;
int fleqn = 0;
char *macros;
char *beginend;
char *class;
int macrosstoresize = 1024;
int beginendsize = 1024;
int donesetup = 0;
int brackets = 0;
int frac = 0;
int authorcount = 0;
int begun = 0;
int colorlst = 0;
%}

whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
ls ([[:blank:]])*"["([[:blank:]])*
rs ([[:blank:]])*"]"
docclass "\\documentclass"
title "\\title"
author "\\author"
chapter "\\chapter"
section "\\section"
subsection "\\subsection"
subsubsection "\\subsubsection"
end "\\end{document}"
tableofcontents "\\tableofcontents"
packages ("\\usepackage")
newcommand ("\\newcommand"|"\\renewcommand")
newenvironment "\\newenvironment"
danger ("babel"|"fontenc"|"lmodern"|"graphicx"|"geometry"|"spverbatim"|"listings"|"amsmath"|"amssymb"|"amsfonts"|"amsthm"|"hyperref"|"DejaVuSansMono"|"etoolbox"|"epsfig"|"mathdesign")
notlarge ("cleveref")
standardonly ("\\newpage"|"\\clearpage") 
bracedcolor "{"(([^"}""{"])*)"\\color{"(([^"}""{"])*)"}"
picturestart "\\begin"{lb}"picture"{rb}
pictureend "\\end"{lb}"picture"{rb}
figurestart "\\begin"{lb}"figure"{rb}
figureend "\\end"{lb}"figure"{rb}
mathstart "\\begin"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}
mathsend "\\end"{lb}("equation"|"equation*"|"displaymath"|"multline*"|"gather*"|"multline"|"gather"|"eqnarray*"|"align*"|"eqnarray"|"align"){rb}
begindocument "\\begin"{lb}"document"{rb}
pmatrix "\\pmatrix"
frac "\\frac"
toosmall ("\\tiny"|"\\scriptsize"|"\\footnotesize"|"\\small")
lstset "\\lstset"{lb}
externaldoc "\\externaldocument"(("[")(.*)("]"))*{lb}[^"{""}"]*
verbatim "\\begin"{lb}("verbatim"|"spverbatim"){rb}

%x COMMENT INPUT IMPORT INCLUDE CLASS SECTIONS COMMAND PACKAGES AUTHOR PICTURE BEGINEND PMATRIX FRAC CHOOSE ATOP LISTING READCLASS EXTHYPER FIGURE INPUTPDFLATEX TIKZCD MATH VERBATIM
%s LSTSET
%%

 /* {doubledollar} ECHO; yy_push_state(DOUBLEDOLLAR); */
 /* <DOUBLEDOLLAR>{doubledollar} ECHO; yy_pop_state(); */

 /* {singledollar} ECHO; yy_push_state(SINGLEDOLLAR); */
 /* <SINGLEDOLLAR>{singledollar} ECHO; yy_pop_state(); */

  /*We need to ensure that comments AND VERBATIM are not processed */
("%")* ECHO; yy_push_state(COMMENT);
<COMMENT>("%") ECHO;
<COMMENT>(\r?\n) printf("\n"); yy_pop_state();

{verbatim} ECHO; yy_push_state(VERBATIM);
<VERBATIM>"\\end"{lb}("verbatim"|"spverbatim"){rb} ECHO; yy_pop_state();
<VERBATIM>(\r?\n) printf("\n");

{standardonly} printf("\\ifboolexpr{togl {clearprint} or togl {large}}{}{"); ECHO; printf("}\n");
("\\hypersetup"){lb}(.*){whitespace}* printf("\\ifboolexpr{togl {clearprint} or togl {large} or togl {web}}{}{"); ECHO; printf("}\n");


{docclass} printf("%%"); ECHO; macrossetup(0); macrossetup(1); donesetup=1; yy_push_state(CLASS);
<CLASS>"8pt" fontsize=8; ECHO;
<CLASS>"9pt" fontsize=9; ECHO;
<CLASS>"10pt" fontsize=10; ECHO;
<CLASS>"11pt" fontsize=11; ECHO;
<CLASS>"12pt" fontsize=12; ECHO;
<CLASS>"14pt" fontsize=14; ECHO;
<CLASS>"17pt" fontsize=17; ECHO;
<CLASS>"20pt" fontsize=20; ECHO;
<CLASS>{lb} ECHO; yy_push_state(READCLASS);
<CLASS>"a4paper" papersize=4; ECHO;
<CLASS>"fleqn" fleqn=1; ECHO;
<READCLASS>(.*)/"}" ECHO; whatclass(); yy_pop_state(); yy_pop_state(); 

{packages} yy_push_state(PACKAGES);
<PACKAGES>(("[")(.*)("]"))*{lb}"bm"{rb} printf("\\newcommand{\\hmmax}{0}\\newcommand{\\bmmax}{2}\n\\usepackage"); ECHO; yy_pop_state();
<PACKAGES>(("[")(.*)("]"))*{lb}"xr"{rb} printf("\\ifpdf\\usepackage{xr,xr-hyper}\\else\\fi"); yy_pop_state();
<PACKAGES>(("[")(.*)("]"))*{lb}{danger}{rb} printf("\\ifboolexpr{togl {web} or togl{clearprint}}{}{\\usepackage"); ECHO; printf("}"); yy_pop_state();
<PACKAGES>(("[")(.*)("]"))*{lb}{notlarge}{rb} printf("\\ifboolexpr{togl {web} or togl{large}}{}{\\usepackage"); ECHO; printf("}"); yy_pop_state();
<PACKAGES>(("[")(.*)("]"))*{lb}"tikz"{rb} if(beamer==0) printf("\\usepackage[dvipsnames]{xcolor}\\usepackage"); else printf("\\PassOptionsToPackage{dvipsnames}{xcolor}\\usepackage"); ECHO; yy_pop_state();
<PACKAGES>(("[")(.*)("]"))*{lb} printf("\\usepackage"); ECHO; 
<PACKAGES>","(" ")* printf(",");
<PACKAGES>{lb} printf("\\usepackage{"); 
<PACKAGES>{rb} ECHO; yy_pop_state();

"\\graphicspath" printf("%%"); ECHO; 

"\\beamertemplatenavigationsymbolsempty" /* This switches the commands off in beamer which is silly but also doesn't work in handout format*/
"\\frametitle"{lb}[^\{\}]*{rb} printf("\\mode<presentation>{"); ECHO; printf("}"); /* This creates extra sections in the handout */

{externaldoc} printf("\\ifpdf\\ifboolexpr{togl {clearprint} or togl {web}}{"); ECHO; printf("-clear}}{"); ECHO; yy_push_state(EXTHYPER); 
<EXTHYPER>{rb} ECHO; printf("}\\else\\fi"); yy_pop_state();

{lstset} ECHO; brackets=1; yy_push_state(LSTSET);
<LSTSET>"backgroundcolor" ECHO; colorlst = 1;
<LSTSET>{lb} ECHO; brackets=brackets+1;
<LSTSET>{rb} ECHO; brackets=brackets-1; if(brackets==0) yy_pop_state(); 

"\\newtoggle{clearprint}"
"\\newtoggle{web}"
"\\newtoggle{large}"
"\\endinput"

"\\smallskip" ECHO;
"\\medskip" ECHO;
"\\bigskip" ECHO;

{toosmall} printf("\\ifboolexpr{togl {web} or togl {clearprint}}{\\normalsize}{"); ECHO; printf("}");

{begindocument} begun=1; if(beginendlength > 0) printf("\\usepackage{demacro-private}\n"); ECHO; 

{title} ECHO; title = 1;
{author}{lb} ECHO; author = 1; /*printf("\\parbox{\\textwidth}{"); yy_push_state(AUTHOR);*/
 /*<AUTHOR>"\\\\" printf(", ");*/
 /*<AUTHOR>{rb} printf("}"); ECHO; yy_pop_state();*/
({chapter}|{section}|{subsection}|{subsubsection}) ECHO; sections = 1;

{tableofcontents} sections = 1; ECHO;

 /* Single letter short forms which are used by TeX4ht and other packages for internal work need to be redefined */
"\\b"{lb} printf("\\underline{");

{picturestart} ECHO; yy_push_state(PICTURE);
<PICTURE>{pictureend} ECHO; yy_pop_state();

{mathstart}?{whitespace}*"\\begin"{lb}"tikzcd"{rb} printf("\n\\begin{mytikz}"); yy_push_state(TIKZCD);
<TIKZCD>"\\end"{lb}"tikzcd"{rb}{whitespace}*{mathsend}? printf("\\end{mytikz}\n"); yy_pop_state();
<TIKZCD>{ls}{whitespace}*"ampersand"{whitespace}*"replacement"{whitespace}*"="{whitespace}*"\\&"{rs}
<TIKZCD>"\\&" ECHO;
<TIKZCD>"&" printf("\\&");

{figurestart} ECHO; yy_push_state(FIGURE);
<FIGURE>("\\input"|"\\include") ECHO; yy_push_state(INPUTPDFLATEX);
<INPUTPDFLATEX>{lb}(.*)/("/") printf("{");
<INPUTPDFLATEX>"/"
<INPUTPDFLATEX>{rb} ECHO; yy_pop_state();
<FIGURE>{figureend} ECHO; yy_pop_state();

{bracedcolor} if(begun==1) {printf(" \\textcolor{"); getcolor();} else ECHO;

("\\input"|"\\include") ECHO; yy_push_state(INPUT);
<INPUT>{lb}(.*)/("/") printf("{");
<INPUT>"/"
<INPUT>{rb} printf("-cont"); ECHO; yy_pop_state();

("\\import") printf("\\input"); yy_push_state(IMPORT); 
<IMPORT>{lb}[^"{""}"]*{rb}/"{"
<IMPORT>"{" ECHO; 
<IMPORT>{rb} printf("-cont"); ECHO; yy_pop_state();

("\\includegraphics") if(beamer==0) checkbeamer(); if(beamer==1) printf("\\fixincludegraphics"); else ECHO; yy_push_state(INCLUDE);
<INCLUDE>{ls}(.*){rs} ECHO; 
<INCLUDE>{lb}(.*)/("/") printf("{");
<INCLUDE>"/"
<INCLUDE>{rb} ECHO; yy_pop_state();

 /* Changed 0 to 1 and removed ECHO to place these also in the de-marco */
{newcommand}/("{"(.*)"}"("["(.*)"]")?"{"(.*)"_") macrosstore("\\renewcommand",13,1); yy_push_state(BEGINEND);//ECHO; yy_push_state(COMMAND);
{newcommand}/("{"(.*)"}"("["(.*)"]")?"{"(.*)"^") macrosstore("\\renewcommand",13,1); yy_push_state(BEGINEND);//ECHO; yy_push_state(COMMAND);
{newcommand}/("{\\vec}") macrosstore("\\renewcommand",13,1); yy_push_state(BEGINEND); //ECHO; yy_push_state(COMMAND);
<COMMAND>(.*){rb} macrosstore(yytext,yyleng,1); macrosstore("\n",1,1); yy_pop_state(); //ECHO; yy_pop_state();

{newenvironment}{lb}"Proof" ECHO; printf("Ori");
"\\begin"{lb}"Proof" ECHO; printf("Ori");
"\\end"{lb}"Proof" ECHO; printf("Ori");

 {newcommand}/(("["(.*)"]")*"{"(.*)"}"("["(.*)"]")*"{"(.*)"\\begin") macrosstore("\\renewcommand",13,1); yy_push_state(BEGINEND);
 {newcommand}/(("["(.*)"]")*"{"(.*)"}"("["(.*)"]")*"{"(.*)"\\end") macrosstore("\\renewcommand",13,1); yy_push_state(BEGINEND);
 <BEGINEND>(.*){rb} macrosstore(yytext,yyleng,1); macrosstore("\n",1,1); yy_pop_state();

{pmatrix}{lb} printf("\\begin{pmatrix}"); brackets=1; yy_push_state(PMATRIX);
<PMATRIX>{lb} ECHO; brackets=brackets+1; 
<PMATRIX>{rb} brackets=brackets-1; if(brackets==0) {printf("\\end{pmatrix}"); yy_pop_state();}else ECHO;
<PMATRIX>"\\cr" printf("\\\\");
<PMATRIX>(\r?\n) printf("\n");

<INITIAL,PMATRIX>{frac}(" ")*/[0-9][0-9] printf("\\frac"); frac=0; yy_push_state(FRAC);
<FRAC>[0-9] printf("{"); ECHO; printf("}"); frac=frac+1; if(frac==2) yy_pop_state();

<INITIAL,PMATRIX>{lb}([^"}""{"])*/"\\choose" printf("\\binom"); ECHO; yy_push_state(CHOOSE);
<CHOOSE>"\\choose" printf("}");
<CHOOSE>([^"\\choose"])*{rb} printf("{"); ECHO; yy_pop_state();

<INITIAL,PMATRIX>{lb}([^"}""{"])*/"\\atop" printf("\\binom"); ECHO; yy_push_state(ATOP);
<ATOP>"\\atop" printf("}");
<ATOP>([^"\\atop"])*{rb} printf("{"); ECHO; yy_pop_state();

 /* This assumes that the end document is in the same file as the preamble */
{end} ECHO; choices(); if(macrolength > 0 || beginendlength > 0) macrosoutput(); 

 /*Just in case*/
\r?\n printf("\n"); 
<<EOF>> if(macrolength > 0 || beginendlength > 0) macrosoutput();  yyterminate();

%%

#include <string.h>

int getcolor(){
  int colorstart =0;
  int colorend =0;
  int deletestart=0;
  int i=yyleng;
  int j=0;
  char *yycopy = strdup( yytext );
  while(colorstart == 0 || colorend == 0 || deletestart == 0){
    /*printf("%c", yycopy[i] );*/
    if(yycopy[i-1] == '}')
      colorend = i-2;
    if(yycopy[i-1] == '{'){
      colorstart = i;
      j=i-1;
      while(deletestart == 0){
	if(yycopy[j] == 'r' && yycopy[j-1] == 'o' && yycopy[j-2] == 'l' && yycopy[j-3] == 'o' && yycopy[j-4] == 'c' && yycopy[j-5] == '\\')
	  deletestart = j-5;
	j--;
      }
    }
    i--;
  }
  for(i=colorstart; i<=colorend;i++)
    printf("%c", yycopy[i] );
  printf("}");
  for(i=0; i<yyleng; i++)
    if(i<deletestart || i>colorend+1)
      printf("%c",yycopy[i]);
  free( yycopy );
  return 0;
}

int whatclass(){
  class = strdup( yytext );
  if(strcmp(class,"beamer")==0){
      beamer = 1;
      /*printf("beamer located");*/
  }
  return 0;
}

int choices(){
  int size = 0;
  FILE *output;
  FILE *typeout;
  FILE *alttype;
  FILE *sizeout;
  FILE *paperout;
  FILE *unknown;
  FILE *fleqnout;
  FILE *beamerfix;
  output = fopen("choices.tex","w");
  typeout = fopen(".documentclass","w");
  alttype = fopen(".alternativeclass","w");
  sizeout = fopen(".fontsize","w");
  paperout = fopen(".papersize","w");
  unknown = fopen(".unknownclass","w");
  fleqnout = fopen(".fleqn","w");
  beamerfix = fopen(".beamerfix","w");
  if(output == NULL){
    fprintf(stderr, "Can't open choices file\n");
    exit(1);
  }
  if(typeout == NULL){
    fprintf(stderr, "Can't open documentclass output file\n");
    exit(1);
  }
  if(alttype == NULL){
    fprintf(stderr, "Can't open alternativeclass output file\n");
    exit(1);
  }
  if(sizeout == NULL){
    fprintf(stderr, "Can't open fontsize output file\n");
    exit(1);
  }
  if(paperout == NULL){
    fprintf(stderr, "Can't open papersize output file\n");
    exit(1);
  }
  if(unknown == NULL){
    fprintf(stderr, "Can't open unknown class output file\n");
    exit(1);
  }
  if(fleqnout == NULL){
    fprintf(stderr, "Can't open fleqn class option output file\n");
    exit(1);
  }
  if(beamerfix == NULL){
    fprintf(stderr, "Can't open beamefix class option output file\n");
    exit(1);
  }
  if(title == 1 && author == 1)
    fprintf(output,"\\toggletrue{frontmatter}");
  else
    fprintf(output,"\\togglefalse{frontmatter}");
  if(sections == 1)
    fprintf(output,"\\toggletrue{contents}");
  else
    fprintf(output,"\\togglefalse{contents}");

  fprintf(typeout,"%s",class);
  
  if(strcmp(class,"article")==0 || strcmp(class,"extarticle")==0){  
    fprintf(alttype,"article");
    fprintf(unknown,"false");
  }else if(strcmp(class,"report")==0 || strcmp(class,"extreport")==0){
    fprintf(alttype,"report");
    fprintf(unknown,"false");
  }else if(strcmp(class,"book")==0 || strcmp(class,"extbook")==0 || strcmp(class,"tufte-book")==0){
    fprintf(alttype,"book");
    fprintf(unknown,"false");
  }else if(strcmp(class,"amsart") == 0){
    fprintf(alttype,"article");
    fprintf(unknown,"false");
  }else if(strcmp(class,"amsbook") == 0){
    fprintf(alttype,"book");
    fprintf(unknown,"false");
  }else if(strcmp(class,"beamer") == 0){
    fprintf(alttype,"article");
    fprintf(unknown,"false");
    fprintf(beamerfix,"unknownkeysallowed,xcolor={usenames,svgnames,dvipsnames}");
  }else{
    fprintf(alttype,"report");
    fprintf(unknown,"true");
  }

  fprintf(sizeout,"%d",fontsize);

  if(papersize == 0)
    fprintf(paperout," ");
  if(papersize == 4)
    fprintf(paperout,"a4paper");
  if(fleqn == 0)
    fprintf(fleqnout," ");
  if(fleqn == 1)
    fprintf(fleqnout,"fleqn");
  
  fclose(output);
  fclose(typeout);
  fclose(sizeout);
  fclose(paperout);
  fclose(unknown);
  fclose(fleqnout);
  return 0;
}

int checkbeamer(){
  FILE *docinput;
  char savedclass[1024];
  docinput = fopen(".documentclass","r");
  if(docinput == NULL){
    fprintf(stderr,"Warning: Can't open documentclass input file but this is okay if it doesn't exist yet\n");
    //exit(1);
  }else{
    fscanf(docinput,"%s",savedclass);
    if(strcmp(savedclass,"beamer")==0)
      beamer = 1;
    fclose(docinput);
  }

  return 0;
}

int macrossetup(int type){
  //fprintf(stderr,"Setup\n");
  if(type == 0)
    macros = (char *) calloc (macrosstoresize, sizeof(char)); 
  if(type == 1)
    beginend = (char *) calloc (beginendsize, sizeof(char)); 
  return 0;
}

int macrosstore(char *tostore, int tolength, int type){
  int i;
  char *tmp;
  if(donesetup==0){
    macrossetup(0); 
    macrossetup(1);
    donesetup=1;
  }
  if(type == 0){
    if(macrolength + tolength > macrosstoresize){
      tmp = (char *) calloc (macrosstoresize, sizeof(char));
      macrosstoresize = 2*macrosstoresize;
      for(i=0; i < macrolength; i++)
	tmp[i] = macros[i];
      macrossetup(type);
      for(i=0; i < macrolength; i++)
	macros[i] = tmp[i];
      free(tmp);
    }
    for(i=0; i < tolength; i++){
      macros[macrolength+i] = tostore[i]; 
    }
    macrolength=macrolength+tolength;
  }

  if(type == 1){
    if(beginendlength + tolength > beginendsize){
      tmp = (char *) calloc (beginendsize, sizeof(char));
      beginendsize = 2*beginendsize;
      for(i=0; i < beginendlength; i++)
	tmp[i] = beginend[i];
      macrossetup(type);
      for(i=0; i < beginendlength; i++)
	beginend[i] = tmp[i];
      free(tmp);
    }
    for(i=0; i < tolength; i++){
      beginend[beginendlength+i] = tostore[i]; 
    }
    beginendlength=beginendlength+tolength;
  }
  return 0;
}

int macrosoutput(){
  FILE *output;
  FILE *demacro;
  int i;
  //printf("Output\n");
  output = fopen("macros.tex","w");
  demacro = fopen("demacro-private.sty","w");
  if(output == NULL){
    fprintf(stderr,"Can't open macros file\n");
    exit(1);
  }
  if(demacro == NULL){
    fprintf(stderr,"Can't open demacro file\n");
    exit(1);
  }
  for(i=0; i<macrolength;i++)
    fprintf(output,"%c",macros[i]);

  if(colorlst == 1){
    fprintf(output,"\\ConfigureEnv{lstlisting}\n");
    fprintf(output,"{\\ifvmode\\IgnorePar\\fi\\EndP\\HCode{<div class=\"shaded\">}\\par}{\\ifvmode\\IgnorePar\\fi\\EndP\\HCode{</div>}\\par}{}{}\n");
    fprintf(output,"\\Css{div.shaded {\n");
    fprintf(output,"background-color: AliceBlue;\n");
    fprintf(output,"}\n"); 
    fprintf(output,"}\n");
  }
  fclose(output);

  for(i=0; i<beginendlength;i++)
    fprintf(demacro,"%c",beginend[i]);
  fclose(demacro);

  return 0;
}
