%{
#include <stdio.h>
#include <stdlib.h>
#include "./src/ast.h"

int yylex(void);
int yyerror(const char* s);

ASTNode* root = nullptr;   // raíz del AST
%}

%union {
    int ival;
    float fval;
    char* sval;
    struct ASTNode* node;
}

%token LET FN IF ELSE WHILE FOR RETURN
%token I32 F64 BOOL CHAR STR
%token <ival> INT_LITERAL
%token <fval> FLOAT_LITERAL
%token <sval> STRING_LITERAL IDENTIFIER
%token PLUS MINUS MUL DIV AND OR NOT
%token EQ EQEQ NEQ LEQ GEQ LT GT
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA COLON

%type <node> program function function_list stmt stmt_list expr param_list param_decl type

%%

program:
    function_list { root = $1; }
;

function_list:
    function { $$ = new ASTNode("Program"); $$->children.push_back($1); }
    | function_list function { $$ = $1; $$->children.push_back($2); }
;

function:
    FN IDENTIFIER LPAREN param_list RPAREN LBRACE stmt_list RBRACE
    {
        $$ = new ASTNode("Function", $2);
        $$->children.push_back($4); // parámetros
        $$->children.push_back($7); // cuerpo
    }
;

param_list:
    /* vacío */ { $$ = new ASTNode("Params"); }
  | param_decl { $$ = new ASTNode("Params"); $$->children.push_back($1); }
  | param_decl COMMA param_list { $$ = $3; $$->children.insert($$->children.begin(), $1); }
;

param_decl:
    IDENTIFIER COLON type { $$ = new ASTNode("Param", $1); $$->children.push_back($3); }
;

type:
    I32 { $$ = new ASTNode("Type", "i32"); }
  | F64 { $$ = new ASTNode("Type", "f64"); }
  | BOOL { $$ = new ASTNode("Type", "bool"); }
  | CHAR { $$ = new ASTNode("Type", "char"); }
  | STR { $$ = new ASTNode("Type", "str"); }
;

stmt_list:
    /* vacío */ { $$ = new ASTNode("Block"); }
    | stmt_list stmt { $$ = $1; $$->children.push_back($2); }
;

stmt:
    LET IDENTIFIER EQ expr SEMICOLON
    {
        $$ = new ASTNode("Let", $2);
        $$->children.push_back($4);
    }
  | RETURN expr SEMICOLON
    {
        $$ = new ASTNode("Return");
        $$->children.push_back($2);
    }
  | IF expr LBRACE stmt_list RBRACE
    {
        $$ = new ASTNode("If");
        $$->children.push_back($2);
        $$->children.push_back($4);
    }
  | WHILE expr LBRACE stmt_list RBRACE
    {
        $$ = new ASTNode("While");
        $$->children.push_back($2);
        $$->children.push_back($4);
    }
  | expr SEMICOLON { $$ = $1; }
;

expr:
    expr PLUS expr
    { $$ = new ASTNode("Add"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr MINUS expr
    { $$ = new ASTNode("Sub"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr MUL expr
    { $$ = new ASTNode("Mul"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr DIV expr
    { $$ = new ASTNode("Div"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr LT expr
    { $$ = new ASTNode("Lt"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr GT expr
    { $$ = new ASTNode("Gt"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr LEQ expr
    { $$ = new ASTNode("Leq"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr GEQ expr
    { $$ = new ASTNode("Geq"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr EQEQ expr
    { $$ = new ASTNode("EqEq"); $$->children.push_back($1); $$->children.push_back($3); }
  | expr NEQ expr
    { $$ = new ASTNode("Neq"); $$->children.push_back($1); $$->children.push_back($3); }
  | LPAREN expr RPAREN { $$ = $2; }
  | IDENTIFIER { $$ = new ASTNode("Identifier", $1); }
  | INT_LITERAL { $$ = new ASTNode("IntLiteral", std::to_string($1)); }
  | FLOAT_LITERAL { $$ = new ASTNode("FloatLiteral", std::to_string($1)); }
;

%%

int yyerror(const char* s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
    return 0;
}
