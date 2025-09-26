%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

int yylex(void);
int yyerror(const char* s);
%}

%union {
    int ival;
    float fval;
    char* sval;
}

%token LET FN IF ELSE WHILE FOR RETURN
%token I32 F64 BOOL CHAR STR
%token <ival> INT_LITERAL
%token <fval> FLOAT_LITERAL
%token <sval> STRING_LITERAL IDENTIFIER
%token PLUS MINUS MUL DIV AND OR NOT
%token EQ NEQ LEQ GEQ LT GT
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA

%%

program:
    function_list
;

function_list:
    function
    | function_list function
;

function:
    FN IDENTIFIER LPAREN RPAREN LBRACE stmt_list RBRACE
;

stmt_list:
    /* vacío */
    | stmt_list stmt
;

stmt:
    LET IDENTIFIER EQ expr SEMICOLON
    | RETURN expr SEMICOLON
    | IF expr LBRACE stmt_list RBRACE
    | WHILE expr LBRACE stmt_list RBRACE
    | expr SEMICOLON
;

expr:
    expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | LPAREN expr RPAREN
    | IDENTIFIER
    | INT_LITERAL
    | FLOAT_LITERAL
;

%%

int yyerror(const char* s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
    return 0;
}
