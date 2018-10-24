%option stack
%{
%}
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"

%x INPUT
%%

("\\input"|"\\include") ECHO; yy_push_state(INPUT);
<INPUT>(".pdf_tex.tex") printf(".web.tex"); 
<INPUT>{rb} ECHO; yy_pop_state();
