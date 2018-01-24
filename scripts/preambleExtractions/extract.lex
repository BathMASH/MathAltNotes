%option stack
%{
int title = 0;
int author = 0;
int sections = 0;
%}

whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
docclass "\\documentclass"
title "\\title"
author "\\author"
chapter "\\chapter"
section "\\section"
subsection "\\subsection"
subsubsection "\\subsubsection"
end "\\end{document}"

%x CLASS SECTIONS
%%

{docclass} printf("%%"); ECHO; yy_push_state(CLASS);
<CLASS>{rb} ECHO; yy_pop_state(); 

{title} ECHO; title = 1;
{author} ECHO; author = 1;
({chapter}|{section}|{subsection}|{subsubsection}) ECHO; sections = 1;

{end} ECHO; choices();

 /*Just in case*/
\r?\n printf("\n"); 

%%

int choices(){
  FILE *output;
  output = fopen("./master/choices.tex","w");
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
