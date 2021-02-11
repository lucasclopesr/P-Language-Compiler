%{
#include <stdio.h>
#include "grammar.h"
%}

%%

(if) printf("IF_TOKEN ");
(then) printf("THEN_TOKEN ");
(else) printf("ELSE_TOKEN ");
(begin) printf("BEGIN_TOKEN ");
(end) printf("END_TOKEN ");
(do) printf("DO_TOKEN ");
(while) printf("WHILE_TOKEN ");
(until) printf("UNTIL_TOKEN ");
(read) printf("READ_TOKEN ");
(write) printf("WRITE_TOKEN ");
(goto) printf("GOTO_TOKEN ");
(NOT) printf("NOT_TOKEN ");
(integer) printf("INTEGER_TYPE ");
(real) printf("REAL_TYPE ");
(boolean) printf("BOOL_TYPE ");
(char) printf("CHAR_TYPE ");
(program) printf("PROGRAM ");

(\+|-|or) printf("ADDOP ");
(\*|\/|div|mod|and) printf("MULOP ");
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) printf("FUNC ");
(false|true) printf("BOOL_CONST ");
[a-zA-Z]([a-zA-Z]|[0-9])* printf("IDENTIFIER ");
(\+|-)?([0-9][0-9]*|[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)?) printf("CONST ");
\'.\' printf("CHAR_CONST ");
(<=|>=|<>|=|<|>) printf("RELOP ");
(;|[ ];) printf("SEMICOLON ");
: printf("COLON ");
(,|[ ],) printf("COMMA ");
(:=|[ ]:=) printf("ASSIGN ");
[(] printf("OPEN_P ");
[)] printf("CLOSE_P ");
[ \t] ;
. printf("UNKNOWN ");

%%

int yywrap(void) {
  return 0;
}
