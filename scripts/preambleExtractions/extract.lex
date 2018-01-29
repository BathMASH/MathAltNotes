%option stack
%{
int title = 0;
int author = 0;
int sections = 0;
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

%x INPUT INCLUDE CLASS SECTIONS
%%

{docclass} printf("%%"); ECHO; yy_push_state(CLASS);
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

{end} ECHO; choices();

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
