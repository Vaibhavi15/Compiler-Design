%{
#include<stdio.h>
%}

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP LEFT_OP RIGHT_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token STRUCT UNION ENUM


%start start_state

%%

start_state
  : external_declaration
  | start_state external_declaration
  ;

external_declaration
  : declaration
  | function_declaration
  ;

declaration
  : type_specifier IDENTIFIER dimension initialiser identifier_list ';'
  | IDENTIFIER dimension initialiser identifier_list ';'
  ;

dimension
  : '['']' dimension_const
  | '['CONSTANT']' dimension
  |
  ;

dimension_const
  : '['']' dimension_const
  |
  ;

identifier_list
  : ',' IDENTIFIER dimension initialiser identifier_list
  |
  ;

initialiser
  : '=' initialisation
  |
  ;

initialisation
  : STRING_LITERAL
  | CONSTANT
  ;

type_specifier
  : INT
  | FLOAT
  | CHAR
  | VOID
  ;


function_declaration
  : type_specifier IDENTIFIER '(' param_list ')' compound_statement
  ;

param_list
  :type_specifier IDENTIFIER identifier_list_param
  |
  ;

identifier_list_param
  : ',' type_specifier IDENTIFIER identifier_list_param
  |
  ;

compound_statement
  : '{''}'
  | '{' statement_list '}'
  ;

statement_list
  : statement
  | statement_list statement
  ;

statement
  : conditional
  |
  ;

conditional
  : IF '(' condition ')' compound_statement
  | IF '(' condition ')' compound_statement ELSE compound_statement
  ;

condition
  : condition logical condition
  | var rel_operator var
  ;

var
  : IDENTIFIER
  | CONSTANT
  | STRING_LITERAL
  ;

rel_operator
  : LE_OP
  | GE_OP
  | EQ_OP
  | NE_OP
  ;

logical
  : AND_OP
  | OR_OP
  ;

%%

#include <stdio.h>
extern char yytext[];
extern int lineno;
yyerror(s)
char *s;
{
	fflush(stdout);
	printf("parse error in line no.%d. Message : %s\n\n",lineno,s);
}


yywrap()
{
  return(1);
}
