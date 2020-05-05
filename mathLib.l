%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}


%%


"@"                         {return func;}
"evalExp"	        {return evaluateExpression;}
"evalFun"           {return evaluateFunction;}
"typeof"            {return type_of;}
"evalDiff"          {return evaluateDifferentiation;}
"diff"              {return differentiate;}
"show"                  {return show;}
"pop"                   {return pop;}
"root"                  {return root;}
"over"				   {return exit_command;}
"append"                {return append;}
"exponent"              {return exponent;}
"log"              {return logarithm;}
[a-zA-Z]			                        {yylval.id = yytext[0]; return variable;}
([1-9][0-9]+|[0-9])                          {
                                                yylval.num = (float)atof(yytext);
                                              
                                                return number;
                                            }
([1-9][0-9]+|[0-9])?\.[0-9]+               {    
                                               
                                                yylval.num = (float)atof(yytext);
                                                 return number;
                                            }
[ \t\n]                ;
[-+=;!*(/){}^<>@_.,]           	   {return yytext[0];}
.                                   {ECHO; yyerror ("Invalid Input\n");}

%%
int yywrap (void) {return 1;}

