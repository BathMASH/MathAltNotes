%option stack
%{
int title = 0;
int author = 0;
int sections = 0;
int article = 0;
int report = 0;
int extarticle = 0;
int extreport = 0;
int beamer = 0;
int length = 0;
int fontsize = 10;
int papersize = 0;
char *macros;
int macrosstoresize = 1024;
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
danger ("babel"|"fontenc"|"lmodern"|"graphicx"|"geometry"|"spverbatim"|"listings"|"amsmath"|"amssymb"|"amsfonts"|"amsthm"|"hyperref"|"DejaVuSansMono"|"etoolbox")
standardonly ("\\newpage"|"\\clearpage")
bracedcolor "{"(([^"}""{"])*)"\\color{"(([^"}""{"])*)"}"
picturestart "\\begin"{lb}"picture"{rb}
pictureend "\\begin"{lb}"picture"{rb}

%x INPUT INCLUDE CLASS SECTIONS COMMAND PACKAGES AUTHOR PICTURE
%%

 /* {doubledollar} ECHO; yy_push_state(DOUBLEDOLLAR); */
 /* <DOUBLEDOLLAR>{doubledollar} ECHO; yy_pop_state(); */

 /* {singledollar} ECHO; yy_push_state(SINGLEDOLLAR); */
 /* <SINGLEDOLLAR>{singledollar} ECHO; yy_pop_state(); */

{standardonly} printf("\\ifboolexpr{togl {clearprint} or togl {large}}{}{"); ECHO; printf("}\n");

{docclass} printf("%%"); ECHO; macrossetup(); yy_push_state(CLASS);
<CLASS>"8pt" fontsize=8; ECHO;
<CLASS>"9pt" fontsize=9; ECHO;
<CLASS>"10pt" fontsize=10; ECHO;
<CLASS>"11pt" fontsize=11; ECHO;
<CLASS>"12pt" fontsize=12; ECHO;
<CLASS>"14pt" fontsize=14; ECHO;
<CLASS>"17pt" fontsize=17; ECHO;
<CLASS>"20pt" fontsize=20; ECHO;
<CLASS>"extarticle" extarticle=1; ECHO;
<CLASS>"extreport" extreport=1; ECHO;
<CLASS>"article" article=1; ECHO;
<CLASS>"report" report=1; ECHO;
<CLASS>"beamer" beamer=1; ECHO;
<CLASS>"a4paper" papersize=4; ECHO;
<CLASS>{rb} ECHO; yy_pop_state(); 

{packages} yy_push_state(PACKAGES);
<PACKAGES>(("[")(.*)("]")){lb}{danger}{rb} printf("\\ifboolexpr{togl {web} or togl{clearprint}}{}{\\usepackage"); ECHO; printf("}"); printf("%%%%"); yy_pop_state();
<PACKAGES>(("[")(.*)("]")){lb}(.*){rb} printf("\\usepackage"); ECHO; printf("%%%%"); yy_pop_state();
<PACKAGES>{lb} printf("\\usepackage{"); 
<PACKAGES>{rb} ECHO; yy_pop_state();

"\\newtoggle{clearprint}"
"\\newtoggle{web}"
"\\newtoggle{large}"

{title} ECHO; title = 1;
{author}{lb} ECHO; author = 1; printf("\\parbox{\\textwidth}{"); yy_push_state(AUTHOR);
<AUTHOR>"\\\\" printf(", ");
<AUTHOR>{rb} printf("}"); ECHO; yy_pop_state();
({chapter}|{section}|{subsection}|{subsubsection}) ECHO; sections = 1;

{tableofcontents} sections = 1; ECHO;

{picturestart} ECHO; yy_push_state(PICTURE);
<PICTURE>{pictureend} ECHO; yy_pop_state();

{bracedcolor} printf(" \\textcolor{"); getcolor(); 

("\\input") ECHO; yy_push_state(INPUT);
<INPUT>{lb}(.*)/("/") printf("{");
<INPUT>"/"
<INPUT>{rb} printf("-cont"); ECHO; yy_pop_state();

("\\includegraphics") if(beamer==1) printf("\\fixincludegraphics"); else ECHO; yy_push_state(INCLUDE);
<INCLUDE>{ls}(.*){rs} ECHO; 
<INCLUDE>{lb}(.*)/("/") printf("{");
<INCLUDE>"/"
<INCLUDE>{rb} ECHO; yy_pop_state();

{newcommand}/("{"(.*)"}{"(.*)"_") macrosstore("\\renewcommand",13); ECHO; yy_push_state(COMMAND);
{newcommand}/("{"(.*)"}{"(.*)"^") macrosstore("\\renewcommand",13); ECHO; yy_push_state(COMMAND);
<COMMAND>(.*){rb} macrosstore(yytext,yyleng); macrosstore("\n",1); ECHO; yy_pop_state();

 /* This assumes that the end document is in the same file as the preamble */
{end} ECHO; choices(); macrosoutput();

 /*Just in case*/
\r?\n printf("\n"); 

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

int choices(){
  FILE *output;
  FILE *typeout;
  FILE *sizeout;
  FILE *paperout;
  output = fopen("choices.tex","w");
  typeout = fopen(".documentclass","w");
  sizeout = fopen(".fontsize","w");
  paperout = fopen(".papersize","w");
  if(output == NULL){
    fprintf(stderr, "Can't open choices file\n");
    exit(1);
  }
  if(typeout == NULL){
    fprintf(stderr, "Can't open documentclass output file\n");
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
  if(title == 1 && author == 1)
    fprintf(output,"\\toggletrue{frontmatter}");
  else
    fprintf(output,"\\togglefalse{frontmatter}");
  if(sections == 1)
    fprintf(output,"\\toggletrue{contents}");
  else
    fprintf(output,"\\togglefalse{contents}");
  if(article == 1 || extarticle == 1)
    fprintf(typeout,"article");
  if(report == 1 || extreport == 1)
    fprintf(typeout,"report");
  if(beamer == 1)
    fprintf(typeout,"beamer");

  fprintf(sizeout,"%d",fontsize);

  if(papersize == 0)
    fprintf(paperout," ");
  if(papersize == 4)
    fprintf(paperout,"a4paper");
  
  return 0;
}

int macrossetup(){
  //fprintf(stderr,"Setup\n");
  macros = (char *) calloc (macrosstoresize, sizeof(char)); 
  return 0;
}

int macrosstore(char *tostore, int tolength){
  int i;
  char *tmp;
  //fprintf(stderr,"Stored\n");
  if(length + tolength > macrosstoresize){
    tmp = (char *) calloc (macrosstoresize, sizeof(char));
    macrosstoresize = 2*macrosstoresize;
    for(i=0; i < length; i++)
      tmp[i] = macros[i];
    macrossetup();
    for(i=0; i < length; i++)
      macros[i] = tmp[i];
    free(tmp);
  }
  for(i=0; i < tolength; i++){
    macros[length+i] = tostore[i]; 
  }
  length=length+tolength;
  return 0;
}

int macrosoutput(){
  FILE *output;
  int i;
  //fprintf(stderr,"Output\n");
  output = fopen("macros.tex","w");
  if(output == NULL){
    fprintf(stderr,"Can't open macros file\n");
    exit(1);
  }

  for(i=0; i<length;i++)
    fprintf(output,"%c",macros[i]);
  return 0;
}
