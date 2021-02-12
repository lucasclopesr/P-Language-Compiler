%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

(if) return IF_TOKEN;
(then) return THEN_TOKEN;
(else) return ELSE_TOKEN;
(begin) return BEGIN_TOKEN;
(end) return END_TOKEN;
(do) return DO_TOKEN;
(while) return WHILE_TOKEN;
(until) return UNTIL_TOKEN;
(read) return READ_TOKEN;
(write) return WRITE_TOKEN;
(goto) return GOTO_TOKEN;
(NOT) return NOT_TOKEN;
(integer) return INTEGER_TYPE;
(real) return REAL_TYPE;
(boolean) return BOOL_TYPE;
(char) return CHAR_TYPE;
(program) return PROGRAM;

(\+|-|or) return ADDOP;
(\*|\/|div|mod|and) return MULOP;
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) return FUNC;
(false|true) return BOOL_CONST;
[a-zA-Z]([a-zA-Z]|[0-9])* return IDENTIFIER;
(\+|-)?([0-9][0-9]*|[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)?) return CONST;
\'.\' return CHAR_CONST;
(<=|>=|<>|=|<|>) return RELOP;
(;|[ ];) return SEMICOLON;
: return COLON;
(,|[ ],) return COMMA;
(:=|[ ]:=) return ASSIGN;
[(] return OPEN_P;
[)] return CLOSE_P;
[ \t\n] ;
. return UNKNOWN;

%%

int yywrap(void) {
  return 0;
}
