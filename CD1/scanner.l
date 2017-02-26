
%option noyywrap

%{
#include"symtab1.h"
#include"constab.h"
#include<string.h>
#include<stdlib.h>
#include "y.tab.h"


int lineno=1;
int flag=0;
int commentDepth;
int ERROR=0;
%}



%x commentsc
%x str
DOTHASH [\.#]

UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
DIGIT [0-9]

ALPHANUM {DIGIT}|{IDENT}

LETTER [A-Za-z]

DELIMITER [\v \t]

NEWLINE [\n]


IDENT ([_a-zA-Z]|{UCN})([_a-zA-Z0-9]|{UCN})*


SLCOMMENT ("//".*)
%%





"#include<"{LETTER}+".h>" {  }

"#define"[.]+[\n] {  }




"//".*  {  }


<commentsc>
{
 [\n]                                { yymore(); ++lineno; }
"*/"                                 { commentDepth--; BEGIN(INITIAL);}
"/*"                                 {commentDepth++; yymore(); }

<<EOF>>                              {printf("line no. %d :ERROR: Unclosed comment.",lineno);
					return 0;
                                      FILE** fout=&stdout;
           printf("\n\n===============================================\n");
           printf("------------------SYMBOL TABLE-----------------\n");
           printf("===============================================\n\n");
            symtab_dump(*fout);

            yyterminate();
                                      }

.                                    yymore();
}

[/][\*](.*[\n]*.*)*[\*][/] {
                            int i;
                            for(i = 0; i<strlen(yytext);i++){
                                if(yytext[i]=='\n'){
                                    lineno++;

                                }

                            }

                        }


"/*"  { commentDepth=1;yymore(); BEGIN(commentsc);}

"*/"  { if(commentDepth>0) { printf("line no. %d :ERROR: Nested commenting attempted.",lineno);return 0;}
        commentDepth=0;
      }


"*=" { insert(yytext,yyleng,3,0,lineno);  return(MUL_ASSIGN); }

"/=" { insert(yytext,yyleng,3,0,lineno);  return(DIV_ASSIGN); }

"%=" { insert(yytext,yyleng,3,0,lineno);  return(MOD_ASSIGN); }

"-=" { insert(yytext,yyleng,3,0,lineno);  return(SUB_ASSIGN); }

"+=" { insert(yytext,yyleng,3,0,lineno);  return(ADD_ASSIGN); }

">>=" { insert(yytext,yyleng,3,0,lineno);  return(RIGHT_ASSIGN); }

"<<=" { insert(yytext,yyleng,3,0,lineno);  return(LEFT_ASSIGN); }

"&=" { insert(yytext,yyleng,3,0,lineno);  return(AND_ASSIGN); }

"|=" { insert(yytext,yyleng,3,0,lineno);  return(OR_ASSIGN); }

"^=" { insert(yytext,yyleng,3,0,lineno);  return(XOR_ASSIGN); }

"<<" { insert(yytext,yyleng,3,0,lineno);  return(LEFT_OP); }

">>" { insert(yytext,yyleng,3,0,lineno);  return(RIGHT_OP); }

"++" { insert(yytext,yyleng,3,0,lineno);  return(INC_OP); }

"--" { insert(yytext,yyleng,3,0,lineno);  return(DEC_OP); }

"+" { insert(yytext,yyleng,3,0,lineno);  return('+'); }

"-" { insert(yytext,yyleng,3,0,lineno);  return('-'); }

"*" { insert(yytext,yyleng,3,0,lineno);  return('*'); }

"/" { insert(yytext,yyleng,3,0,lineno);  return( '/'); }

"%" { insert(yytext,yyleng,3,0,lineno);  return( '%');}

"&&" { insert(yytext,yyleng,3,0,lineno);  return( AND_OP);}

"||" { insert(yytext,yyleng,3,0,lineno);  return(OR_OP); }

"!" { insert(yytext,yyleng,3,0,lineno);  return('!'); }

"<" { insert(yytext,yyleng,3,0,lineno);  return('<');}

">" { insert(yytext,yyleng,3,0,lineno);  return('>');}

":" { insert(yytext,yyleng,3,0,lineno);  return(':');}

"?" { insert(yytext,yyleng,3,0,lineno);  return('?');}

"<=" { insert(yytext,yyleng,3,0,lineno);  return( LE_OP); }

">=" { insert(yytext,yyleng,3,0,lineno);  return( GE_OP); }

"==" { insert(yytext,yyleng,3,0,lineno);  return( EQ_OP); }

"!=" { insert(yytext,yyleng,3,0,lineno);  return( NE_OP); }

"&" { insert(yytext,yyleng,3,0,lineno);  return('&'); }

"|" { insert(yytext,yyleng,3,0,lineno);  return('|'); }

"^" { insert(yytext,yyleng,3,0,lineno);  return('^'); }

"(" { insert(yytext,yyleng,4,0,lineno);  return('('); }

")" { insert(yytext,yyleng,4,0,lineno);  return(')'); }

"[" { insert(yytext,yyleng,4,0,lineno); return('['); }

"]" { insert(yytext,yyleng,4,0,lineno);  return(']'); }

"{" { insert(yytext,yyleng,4,0,lineno); return('{'); }

"}" { insert(yytext,yyleng,4,0,lineno);  return('}'); }

"," { insert(yytext,yyleng,4,0,lineno);  return(','); }

";" { insert(yytext,yyleng,4,0,lineno);  flag =0;return(';'); }

"=" { insert(yytext,yyleng,4,0,lineno);  return('='); }




"volatile" { insert(yytext,yyleng,1,0,lineno);  return( VOLATILE); }

"char" { insert(yytext,yyleng,1,0,lineno); flag=2 ; return( CHAR); }

"int" { insert(yytext,yyleng,1,0,lineno); flag=1;return(INT); }

"void" { insert(yytext,yyleng,1,0,lineno);  return(VOID); }

"if" { insert(yytext,yyleng,1,0,lineno);  return(IF); }

"else" { insert(yytext,yyleng,1,0,lineno);  return(ELSE); }

"while" { insert(yytext,yyleng,1,0,lineno);  return(WHILE); }

"for" { insert(yytext,yyleng,1,0,lineno);  return(FOR); }

"continue" { insert(yytext,yyleng,1,0,lineno);  return(CONTINUE); }

"break" { insert(yytext,yyleng,1,0,lineno);  return(BREAK); }

"return" { insert(yytext,yyleng,1,0,lineno);  return(RETURN); }

"auto" { insert(yytext,yyleng,1,0,lineno);  return(AUTO); }

"extern" { insert(yytext,yyleng,1,0,lineno);  return(EXTERN); }

"float" { insert(yytext,yyleng,1,0,lineno);  return(FLOAT); }

"double" { insert(yytext,yyleng,1,0,lineno);  return(DOUBLE); }

"switch" { insert(yytext,yyleng,1,0,lineno);  return(SWITCH); }

"case" { insert(yytext,yyleng,1,0,lineno);  return(CASE); }

"const" { insert(yytext,yyleng,1,0,lineno);  return(CONST); }

"default" { insert(yytext,yyleng,1,0,lineno);  return(DEFAULT); }

"long" { insert(yytext,yyleng,1,0,lineno);  return(LONG); }

"register" { insert(yytext,yyleng,1,0,lineno);  return(REGISTER); }

"short" { insert(yytext,yyleng,1,0,lineno);  return(SHORT); }

"signed" { insert(yytext,yyleng,1,0,lineno);  return(SIGNED); }

"static" { insert(yytext,yyleng,1,0,lineno);  return(STATIC); }

"unsigned" { insert(yytext,yyleng,1,0,lineno);  return(UNSIGNED); }

"do" { insert(yytext,yyleng,1,0,lineno);  return(DO); }

"enum" { insert(yytext,yyleng,1,0,lineno);  return(ENUM); }

"struct" { insert(yytext,yyleng,1,0,lineno);  return(STRUCT); }

"union"	{ insert(yytext,yyleng,1,0,lineno);  return(UNION); }

"goto" { insert(yytext,yyleng,1,0,lineno);  return(GOTO); }

"sizeof" { insert(yytext,yyleng,1,0,lineno);  return(SIZEOF); }

"typedef" { insert(yytext,yyleng,1,0,lineno);  return(TYPEDEF); }

{DIGIT}+[a-zA-Z0-9]+    {printf("%4d\t", lineno);printf("ERROR: UNACCEPTABLE IDENTIFIER FORMAT!\n");}

{IDENT}\(\)  {
insert(yytext,yyleng,5,flag + 1,lineno);
return(IDENTIFIER); }

(\*{IDENT})|({IDENT}"[]")|(\*\ {IDENT})|({IDENT}\[{ALPHANUM}+\])       {
            int i;
            char s[50];
            for(i=0;yytext[i]!='[';i++)
            {
              char tmp = yytext[i];
              s[i] = yytext[i];
            }
            s[i] = '\0';
            insert(s,yyleng,2,flag + 2,lineno);return(IDENTIFIER);}


({IDENT}\[{ALPHANUM}+\]\[{ALPHANUM}+\])   {
            int i;
            char s[50];
            for(i=0;yytext[i]!='[';i++)
            {
              char tmp = yytext[i];
              s[i] = yytext[i];
            }
            s[i] = '\0';
            insert(s,yyleng,2,flag + 3,lineno);return(IDENTIFIER);}

{IDENT} {
insert(yytext,yyleng,2,flag + 1,lineno);
return(IDENTIFIER); }

{DIGIT}+ {
                insertc(yytext,yyleng,1,lineno);
              return (CONSTANT);}
{DIGIT}+"."{DIGIT}+ |
{DIGIT}+"."{DIGIT}+(E|e)[+-]?{DIGIT}+ {
                                            insertc(yytext,yyleng,2,lineno);
                 return(CONSTANT);}

\'[a-zA-Z0-9]\' {
                insertc(yytext,yyleng,3,lineno);
               return(CONSTANT);}


\" { BEGIN(str); }




<str>
{\"        {  if(ERROR==0)
              insertc(yytext,yyleng-1,4,lineno);
                BEGIN(INITIAL);
                 return(STRING_LITERAL);
                 }

\n        {
                 printf("line no. %d :ERROR: unterminated string constant\n",lineno);
			return 0;
                 ERROR=1;
                 }


\\[^ntrbf]. {
                 printf("line no. %d :ERROR: Bad escape sequence\n",lineno);
			return 0;
                 ERROR=1;
                 }

\\n  { yymore();}
\\t  { yymore();}
\\r  { yymore();}
\\b  { yymore();}
\\f  { yymore();}
\\(.|\n)  {yymore();}


[^\\\n\"]+        {yymore();}

}




{DELIMITER} { }

{NEWLINE} {lineno++;}
<<EOF>>   { FILE** fout=&stdout;

           printf("------------------SYMBOL TABLE-----------------\n");

            symtab_dump(*fout);

            yyterminate();}

. {printf("line no. %d :ERROR: unsupported character:%s\n",lineno,yytext);return 0;}

%%

int main(int argc, char **argv)
{
++argv; --argc;
if(argc>0)
	yyin=fopen(argv[0], "r");
else
	yyin=stdin;

yyparse();


}
