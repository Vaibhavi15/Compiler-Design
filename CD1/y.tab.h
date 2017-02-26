/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    CONSTANT = 259,
    STRING_LITERAL = 260,
    SIZEOF = 261,
    CHAR = 262,
    SHORT = 263,
    INT = 264,
    LONG = 265,
    SIGNED = 266,
    UNSIGNED = 267,
    FLOAT = 268,
    DOUBLE = 269,
    CONST = 270,
    VOLATILE = 271,
    VOID = 272,
    CASE = 273,
    DEFAULT = 274,
    IF = 275,
    ELSE = 276,
    SWITCH = 277,
    WHILE = 278,
    DO = 279,
    FOR = 280,
    GOTO = 281,
    CONTINUE = 282,
    BREAK = 283,
    RETURN = 284,
    INC_OP = 285,
    DEC_OP = 286,
    LE_OP = 287,
    GE_OP = 288,
    EQ_OP = 289,
    NE_OP = 290,
    LEFT_OP = 291,
    RIGHT_OP = 292,
    AND_OP = 293,
    OR_OP = 294,
    MUL_ASSIGN = 295,
    DIV_ASSIGN = 296,
    MOD_ASSIGN = 297,
    ADD_ASSIGN = 298,
    SUB_ASSIGN = 299,
    LEFT_ASSIGN = 300,
    RIGHT_ASSIGN = 301,
    AND_ASSIGN = 302,
    XOR_ASSIGN = 303,
    OR_ASSIGN = 304,
    TYPEDEF = 305,
    EXTERN = 306,
    STATIC = 307,
    AUTO = 308,
    REGISTER = 309,
    STRUCT = 310,
    UNION = 311,
    ENUM = 312
  };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define CONSTANT 259
#define STRING_LITERAL 260
#define SIZEOF 261
#define CHAR 262
#define SHORT 263
#define INT 264
#define LONG 265
#define SIGNED 266
#define UNSIGNED 267
#define FLOAT 268
#define DOUBLE 269
#define CONST 270
#define VOLATILE 271
#define VOID 272
#define CASE 273
#define DEFAULT 274
#define IF 275
#define ELSE 276
#define SWITCH 277
#define WHILE 278
#define DO 279
#define FOR 280
#define GOTO 281
#define CONTINUE 282
#define BREAK 283
#define RETURN 284
#define INC_OP 285
#define DEC_OP 286
#define LE_OP 287
#define GE_OP 288
#define EQ_OP 289
#define NE_OP 290
#define LEFT_OP 291
#define RIGHT_OP 292
#define AND_OP 293
#define OR_OP 294
#define MUL_ASSIGN 295
#define DIV_ASSIGN 296
#define MOD_ASSIGN 297
#define ADD_ASSIGN 298
#define SUB_ASSIGN 299
#define LEFT_ASSIGN 300
#define RIGHT_ASSIGN 301
#define AND_ASSIGN 302
#define XOR_ASSIGN 303
#define OR_ASSIGN 304
#define TYPEDEF 305
#define EXTERN 306
#define STATIC 307
#define AUTO 308
#define REGISTER 309
#define STRUCT 310
#define UNION 311
#define ENUM 312

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
