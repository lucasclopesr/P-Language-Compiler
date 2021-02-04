%{
#include <stdio.h>
%}

%%

(if) printf("IF");
(then) printf("THEN");
(else) printf("ELSE");
(begin) printf("BEGIN");
(end) printf("END");
(do) printf("DO");
(while) printf("WHILE");
(until) printf("UNTIL");
(read) printf("READ");
(write) printf("WRITE");
(goto) printf("GOTO");
(NOT) printf("NOT");
(integer) printf("INTEGER_TYPE");
(real) printf("REAL_TYPE");
(boolean) printf("BOOL_TYPE");
(char) printf("CHAR_TYPE");
(program) printf("PROGRAM");

(\+|-|or) printf("ADDOP");
(\*|\/|div|mod|and) printf("MULOP");
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) printf("FUNC");
(false|true) printf("BOOL_CONST");
[a-zA-Z]([a-zA-Z]|[0-9])* printf("IDENTIFIER");
[0-9][0-9]* printf("INTEGER_CONST");
[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)? printf("REAL_CONST");
\'.\' printf("CHAR_CONST");
(<=|>=|<>|=|<|>) printf("RELOP");

%%

int yywrap(void) {
  return 0;
}
