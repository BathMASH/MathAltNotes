%option stack
%{
int title = 0;
int author = 0;
int sections = 0;
int length = 0;
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
newcommand ("\\newcommand"|"\\renewcommand")

%x INPUT INCLUDE CLASS SECTIONS COMMAND
%%

{docclass} printf("%%"); ECHO; macrossetup(); yy_push_state(CLASS);
<CLASS>{rb} ECHO; yy_pop_state(); 

{title} ECHO; title = 1;
{author} ECHO; author = 1;
({chapter}|{section}|{subsection}|{subsubsection}) ECHO; sections = 1;

("\\input") ECHO; yy_push_state(INPUT);
<INPUT>{lb}(.*)/("/") printf("{");
<INPUT>"/"
<INPUT>{rb} ECHO; yy_pop_state();

("\\includegraphics") ECHO; yy_push_state(INCLUDE);
<INCLUDE>{ls}(.*){rs} ECHO; 
<INCLUDE>{lb}(.*)/("/") printf("{");
<INCLUDE>"/"
<INCLUDE>{rb} ECHO; yy_pop_state();

{newcommand} macrosstore("\\renewcommand",13); ECHO; yy_push_state(COMMAND);
<COMMAND>(.*){rb} macrosstore(yytext,yyleng); macrosstore("\n",1); ECHO; yy_pop_state();

{end} ECHO; choices(); macrosoutput();

 /*Just in case*/
\r?\n printf("\n"); 

%%

int choices(){
  FILE *output;
  output = fopen("choices.tex","w");
  if(output == NULL){
    fprintf(stderr, "Can't open choices file\n");
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
