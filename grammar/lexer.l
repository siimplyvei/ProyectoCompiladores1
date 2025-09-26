%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

"let"       return LET;
"fn"        return FN;
"if"        return IF;
"else"      return ELSE;
"while"     return WHILE;
"for"       return FOR;
"return"    return RETURN;

"i32"       return I32;
"f64"       return F64;
"bool"      return BOOL;
"char"      return CHAR;
"str"       return STR;

[0-9]+      { yylval.ival = atoi(yytext); return INT_LITERAL; }
[0-9]+"."[0-9]+  { yylval.fval = atof(yytext); return FLOAT_LITERAL; }
\"([^\\\"]|\\.)*\" { yylval.sval = strdup(yytext); return STRING_LITERAL; }
[a-zA-Z_][a-zA-Z0-9]()_]()
