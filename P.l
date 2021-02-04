%{
#include <stdio.h>
#include "grammar.h"
%}

%%

(if) printf("%d\n",IF_TOKEN);
(then) printf("%d\n",THEN_TOKEN);
(else) printf("%d\n",ELSE_TOKEN);
(begin) printf("%d\n",BEGIN_TOKEN);
(end) printf("%d\n",END_TOKEN);
(do) printf("%d\n",DO_TOKEN);
(while) printf("%d\n",WHILE_TOKEN);
(until) printf("%d\n",UNTIL_TOKEN);
(read) printf("%d\n",READ_TOKEN);
(write) printf("%d\n",WRITE_TOKEN);
(goto) printf("%d\n",GOTO_TOKEN);
(NOT) printf("%d\n",NOT_TOKEN);
(integer) printf("%d\n",INTEGER_TYPE);
(real) printf("%d\n",REAL_TYPE);
(boolean) printf("%d\n",BOOL_TYPE);
(char) printf("%d\n",CHAR_TYPE);
(program) printf("%d\n",PROGRAM);

(\+|-|or) printf("%d\n",ADDOP);
(\*|\/|div|mod|and) printf("%d\n",MULOP);
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) printf("%d\n",FUNC);
(false|true) printf("%d\n",BOOL_CONST);
[a-zA-Z]([a-zA-Z]|[0-9])* printf("%d\n",IDENTIFIER);
[0-9][0-9]* printf("%d\n",INTEGER_CONST);
[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)? printf("%d\n",REAL_CONST);
\'.\' printf("%d\n",CHAR_CONST);
(<=|>=|<>|=|<|>) printf("%d\n",RELOP);
(;|[ ];) printf("%d\n",SEMICOLON);
: printf("%d\n",COLON);
(,|[ ],) printf("%d\n",COMMA);
(:=|[ ]:=) printf("%d\n",ASSIGN);
[(] printf("%d\n",OPEN_P);
[)] printf("%d\n",CLOSE_P);
[ \t\n] ;
. printf("%d\n", UNKNOWN);

%%

int yywrap(void) {
  return 0;
}
