%{
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
	#include "mymain.cpp"

	int yylex(void);
	void yyerror(char *);

    extern FILE* yyin;
	extern int linecount;
	extern int commentflag;
	int error;
	int type;
	int flag = -1;
	extern char* yytext;


%}

%token _GREAT_EQ _LESS_EQ _LOGIC_OR _LOGIC_AND _NOT_EQ _EQUAL _INCR_1 _DECR_1 _CONSTANT _INCR_VAL _DECR_VAL _MULT_VAL _DIV_VAL _MOD_VAL _DO _ELSE _FOR _IF _PRINT _SCAN _WHILE _HEADER _PREPROC _STRING _RETURN

%union
{
	int number;
    char str[10000];
}


%token<str> _IDENTIFIER _MAIN _INT _CHAR _VOID
%type<str> type_specifier

%start global

%left ','
%right '=' _INCR_VAL _DECR_VAL _MULT_VAL _DIV_VAL MOD_VAL
%left _LOGIC_AND _LOGIC_OR
%left '>' '<' _GREAT_EQ _LESS_EQ
%left _EQUAL _NOT_EQ
%left '+' '-'
%left '*' '/' '%'
%left '(' ')' _INCR_1 _DECR_1

%%

global : _PREPROC _HEADER funcdec
       ;

funcdec : funcdec_ mainfunc
	    | funcdec_ mainfunc funcdec_
		| mainfunc funcdec_
        ;

mainfunc :  main '{' body '}'
		 {
			disp(s.top());
			if(!s.empty())
				s.pop();
		 }
		 ;

funcdec_ : functiondec '{' body '}'
		 {
			disp(s.top());
			if(!s.empty())
				s.pop();
		 }
		 | declaration
		 | funcdec_ functiondec '{' body '}'
         {
			disp(s.top());
			if(!s.empty())
			s.pop();
		 }
		 | funcdec_ declaration
		 ;

declaration : type_specifier declist ';'
            ;

type_specifier
 : _INT
 {
 	flag = 3;
 	strcpy($<str>$,"INTEGER_VARIABLE");
 }
 | _CHAR
 {
 	strcpy($<str>$,"CHAR_VARIABLE");
 	flag = 4;
 }
 | _VOID
 {
 	strcpy($<str>$,"VOID_VARIABLE");
 	flag = 5;
 }
 ;

declist : declist ',' pointer _IDENTIFIER optional '=' expression
		{
			table = s.top();
			token = $4;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
			operands.push($<str>4);
			printTACasgn();
		}
		| declist ',' pointer _IDENTIFIER optional '=' funccall_statement
		{
			table = s.top();
			token = $4;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
		}

  		| declist ',' pointer _IDENTIFIER optional
  		{
			table = s.top();
  			token = $4;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
  		}
		| pointer _IDENTIFIER optional
		{
			table = s.top();
			token = $2;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
			operands.push($<str>2);
		}
		| pointer _IDENTIFIER optional '=' expression
		{
			table = s.top();
			token = $2;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
			operands.push($<str>2);
			printTACasgn();
		}
		| pointer _IDENTIFIER optional '=' funccall_statement
		{
			table = s.top();
			token = $2;
			error = insertToken(flag,table);
			if(error)
			{
				printf("REDECLARED_VARIABLE");
				exit(error);
			}
		}
		;

pointer
 : '*'
 |
 ;

optional
 : '[' ']'
 | '[' _CONSTANT ']'
 | '[' _CONSTANT ']' '[' _CONSTANT ']'
 |
 ;

optional_call
 : '[' ']'
 | '[' _IDENTIFIER ']'
 | '[' _IDENTIFIER ']' '[' _IDENTIFIER ']'
 |
 ;

main  : type_specifier _MAIN '(' ')'
	  {
		 table.clear();
     	 s.push(table);
    	 counter++;
		 token = $2;
		 insertToken(2,table);
	  }
      ;

functiondec : type_specifier pointer _IDENTIFIER '(' type_specifier pointer _IDENTIFIER optional ','  type_specifier pointer _IDENTIFIER  optional ')'
			{

				table.clear();
				s.push(table);
			    counter++;
				token = $3;
				error = insertToken(flag,table);
				if(error)
				{
					printf("REDECLARED_VARIABLE");
					exit(error);
				}
				token = $7;
				error = insertToken(flag,table);
				if(error)
				{
					printf("REDECLARED_VARIABLE");
					exit(error);
				}
				token = $12;
				error = insertToken(flag,table);
				if(error)
				{
					printf("REDECLARED_VARIABLE");
					exit(error);
				}
				ret = helper[$1];
				error = insertFunc($<str>1,$<str>3,$<str>5,$<str>10);
				if(error == -1)
				{
					printf("REDECLARED_FUNCTION");
					exit(error);
				}
			}
            ;

body : declaration | statement | funccall_statement ';'
     | body declaration
	 | body statement
	 | body funccall_statement ';'
     ;

expression : expression '+' expression
			{
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
				printTAC('+');
			}
		   | expression '-' expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
				printTAC('-');
			}
		   | expression '*' expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
				printTAC('*');
			}
		   | expression '/' expression
		   {
				if($<number>1!=$<number>3 || $<number>$ != $<number>1)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
				printTAC('/');
			}
		   | expression '%' expression
		   {
				if($<number>1!=$<number>3 || $<number>$ != $<number>1)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
				printTAC('%');
			}
		   | '(' expression ')'
		   | expression '>' expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression '<' expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _GREAT_EQ expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _LESS_EQ expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _NOT_EQ expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _EQUAL expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _LOGIC_AND expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression _LOGIC_OR expression
		   {
				if($<number>1!=$<number>3)
				{
					printf("Type Mismatch Error");
					exit(2);
				}
				$<number>$ = $<number>1;
			}
		   | expression ',' expression
		   | _IDENTIFIER '=' expression
		   {

				token = $1;
				error = lookupTable(token);
				if(error)
				{
					printf("UNDECLARED_VARIABLE\n");
					exit(error);
				}
				type = lookupType($1);
		   		if(type!=$<number>3)
				{
					printf("Type Mismatch Error\n");
					exit(2);
				}
				operands.push($<str>1);
				printTACasgn();
           }
		   | _IDENTIFIER optional_call _INCR_1
		   {
		   		$<number>$ = lookupType($1);
				token = $1;
				error = lookupTable(token);
				if(error)
				{
					printf("UNDECLARED_VARIABLE");
					exit(error);
				}
				operands.push($<str>1);
				printTACun('+');
		   }
		   | _IDENTIFIER optional_call _DECR_1
		   {
		   		$<number>$ = lookupType($1);
				token = $1;
				error = lookupTable(token);
				if(error)
				{
					printf("UNDECLARED_VARIABLE");
					exit(error);
				}
				operands.push($<str>1);
				printTACun('-');
		   }
		   | _IDENTIFIER optional_call
		   {
		   		$<number>$ = lookupType($1);
				token = $1;
				error = lookupTable(token);
				if(error)
				{
					printf("UNDECLARED_VARIABLE");
					exit(error);
				}
				operands.push($<str>1);
		   }
		   | _CONSTANT
		   {
	   			$<number>$ = 3;
				//strcpy(, yytext);
				operands.push(yytext);
		   }
		   | _STRING
		   {
		   		$<number>$ = 4;
				operands.push(yytext);
		   }
		   ;

expression_statement : ';'
					 | expression ';'
					 ;

funccall_statement : _IDENTIFIER '(' expression ',' expression ')'
					{

						error = funcType($<str>1,$<number>3,$<number>5);
						if(error == -1)
						{
							printf("Function call arguments type error\n");
							exit(1);
						}

					}
				   ;

return_statement : _RETURN expression ';'
					{

						if(ret != $<number>2 )
						{
							printf("return type mismatch error\n");
							exit(1);
						}
					}
                 ;

io_statement : _PRINT '(' _STRING ',' identifier_list ')' ';'
			 | _SCAN '(' _STRING ',' identifieraddr_list ')' ';'
			 ;

identifier_list : identifier_list ',' _IDENTIFIER optional_call
				| _IDENTIFIER optional_call
				;

identifieraddr_list : identifieraddr_list ',' '&' _IDENTIFIER optional_call
					| '&' _IDENTIFIER optional_call
					| identifieraddr_list ','  _IDENTIFIER optional_call
					| _IDENTIFIER optional_call
					;

statement : expression_statement
		  | if_statement '{' body '}'
		  {
			disp(s.top());
			if(!s.empty())
				s.pop();
		  }
		  | if_statement '{' body '}' else_statement '{' body '}'
		  {
			disp(s.top());
			if(!s.empty())
				s.pop();
		  }
		  | loop_statement '{' body '}'
          {
			disp(s.top());
			if(!s.empty())
				s.pop();

		  }
 		  | do_statement '{' body '}' _WHILE '(' expression ')' ';'
          {
			disp(s.top());
			if(!s.empty())
				s.pop();
		  }
		  | return_statement
		  | io_statement
		  ;

loop_statement : _FOR '(' expression_statement expression_statement ')'
			   {
					table.clear();
					s.push(table); counter++;
			   }
			   | _FOR '(' expression_statement expression_statement expression ')'
			   {
				    table.clear();
				    s.push(table); counter++;

			   }
			   | _WHILE '(' expression ')'
			   {
				    table.clear();
				    s.push(table); counter++;
			   }
			   ;

do_statement : _DO
			 {
				table.clear();
				s.push(table); counter++;

			 }
			 ;

if_statement : _IF '(' expression ')'
			 {
				table.clear();
				s.push(table); counter++;
			 }
			 ;

else_statement : _ELSE
			   {
					disp(s.top());
					if(!s.empty())
						s.pop();
			   		table.clear();
					s.push(table); counter++;
			   }
	    	   ;

%%


int main(int argc, char *argv[])
{
	FILE* SRC;
	printf("\nSYNTACTICAL ANALYSIS\n");
	printf("----------------\n\n");
	if (argc == 2 && (SRC = fopen(argv[1],"r")))
        	yyin = SRC;
	else if(SRC == NULL)
	{
		printf("File not found\n");
		exit(0);
	}
	helper["FUNCTION"] = 1;
	helper["MAIN_FUNCTION"] = 2;
	helper["INTEGER_VARIABLE"] = 3;
	helper["CHAR_VARIABLE"] = 4;
	helper["VOID_VARIABLE"] = 5;
	insertFunc("INTEGER_VARIABLE", "strcmp", "CHAR_VARIABLE", "CHAR_VARIABLE");
	insertFunc("INTEGER_VARIABLE", "strcpy", "CHAR_VARIABLE", "CHAR_VARIABLE");
	table.clear();
	s.push(table);
	if(!yyparse())
		printf("\nPARSING PASSED!\n");
	else
		printf("\nPARSING FAILED!\n");
	fclose(SRC);

	if(commentflag)
	{
		printf("\nERROR 2 : Comment not closed\n");
		exit(2);
	}

	return 0;
}

void yyerror(char *msg)
{
	printf("\nSYNTAX ERROR at line %d\n",linecount);
}
