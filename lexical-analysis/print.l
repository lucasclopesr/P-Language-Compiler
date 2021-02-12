%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

(if) printf("IF_TOKEN\n"); return IF_TOKEN;
(then) printf("THEN_TOKEN\n"); return THEN_TOKEN;
(else) printf("ELSE_TOKEN\n"); return ELSE_TOKEN;
(begin) printf("BEGIN_TOKEN\n"); return BEGIN_TOKEN;
(end) printf("END_TOKEN\n"); return END_TOKEN;
(do) printf("DO_TOKEN\n"); return DO_TOKEN;
(while) printf("WHILE_TOKEN\n"); return WHILE_TOKEN;
(until) printf("UNTIL_TOKEN\n"); return UNTIL_TOKEN;
(read) printf("READ_TOKEN\n"); return READ_TOKEN;
(write) printf("WRITE_TOKEN\n"); return WRITE_TOKEN;
(goto) printf("GOTO_TOKEN\n"); return GOTO_TOKEN;
(NOT) printf("NOT_TOKEN\n"); return NOT_TOKEN;
(integer) printf("INTEGER_TYPE\n"); return INTEGER_TYPE;
(real) printf("REAL_TYPE\n"); return REAL_TYPE;
(boolean) printf("BOOL_TYPE\n"); return BOOL_TYPE;
(char) printf("CHAR_TYPE\n"); return CHAR_TYPE;
(program) printf("PROGRAM\n"); return PROGRAM;

(\+|-|or) printf("ADDOP\n"); return ADDOP;
(\*|\/|div|mod|and) printf("MULOP\n"); return MULOP;
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) printf("FUNC\n"); return FUNC;
(false|true) printf("BOOL_CONST\n"); return BOOL_CONST;
[a-zA-Z]([a-zA-Z]|[0-9])* printf("IDENTIFIER\n"); return IDENTIFIER;
(\+|-)?([0-9][0-9]*|[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)?) printf("CONST\n"); return CONST;
\'.\' printf("CHAR_CONST\n"); return CHAR_CONST;
(<=|>=|<>|=|<|>) printf("RELOP\n"); return RELOP;
(;|[ ];) printf("SEMICOLON\n"); return SEMICOLON;
: printf("COLON\n"); return COLON;
(,|[ ],) printf("COMMA\n"); return COMMA;
(:=|[ ]:=) printf("ASSIGN\n"); return ASSIGN;
[(] printf("OPEN_P\n"); return OPEN_P;
[)] printf("CLOSE_P\n"); return CLOSE_P;
[ \t\n] ;
. printf("UNKNOWN\n"); return UNKNOWN;

%%

int yywrap(void) {
  return 0;
}
