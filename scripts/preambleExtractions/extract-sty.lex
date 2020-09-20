%option stack
%{
%}

whitehspace (" "|\t)
whitespace (" "|\t|(\r?\n))
lb ([[:blank:]])*"{"([[:blank:]])*
rb ([[:blank:]])*"}"
ls ([[:blank:]])*"["([[:blank:]])*
rs ([[:blank:]])*"]"
lp ([[:blank:]])*"("([[:blank:]])*
rp ([[:blank:]])*")"

%x INCLUDE
%%

("\\includegraphics") ECHO; yy_push_state(INCLUDE);
<INCLUDE>{ls}(.*){rs} ECHO; 
<INCLUDE>{lb}(.*)/("/") printf("{");
<INCLUDE>"/"
<INCLUDE>{rb} ECHO; yy_pop_state();
