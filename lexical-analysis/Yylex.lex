%{
#include <stdio.h>
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

(if) { return IF_TOKEN; }
(then) { return THEN_TOKEN; }
(else) { return ELSE_TOKEN; }
(begin) { return BEGIN_TOKEN; }
(end) { return END_TOKEN; }
(do) { return DO_TOKEN; }
(while) { return WHILE_TOKEN; }
(until) { return UNTIL_TOKEN; }
(read) { return READ_TOKEN; }
(write) { return WRITE_TOKEN; }
(goto) { return GOTO_TOKEN; }
(NOT) { return NOT_TOKEN; }
(integer) { return INTEGER_TYPE; }
(real) { return REAL_TYPE; }
(boolean) { return BOOL_TYPE; }
(char) { return CHAR_TYPE; }
(program) { return PROGRAM; }

(\+|-|or) { strcpy(yylval.op, yytext); return ADDOP; }
(\*|\/|div|mod|and) { strcpy(yylval.op, yytext); return MULOP; }
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) { strcpy(yylval.op, yytext); return FUNC; }
(false|true) {
  strcpy(yylval.char_val, yytext);
  if (strcmp(yytext, "false") == 0){
    return FALSE_CONST;
  }

  return TRUE_CONST;
}
[a-zA-Z]([a-zA-Z]|[0-9])* { yylval.id = malloc(sizeof(yytext)); strcpy(yylval.id, yytext); return IDENTIFIER; }
(\+|-)?([0-9][0-9]*|[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)?) { yylval.num_val = atoi(yytext); return CONST; }
\'.\' { yylval.char_val = yytext[0]; return CHAR_CONST; }
(<=|>=|<>|=|<|>) { strcpy(yylval.op, yytext); return RELOP; }
(;|[ ];) { return SEMICOLON; }
: { return COLON; }
(,|[ ],) { return COMMA; }
(:=|[ ]:=) { return ASSIGN; }
[(] { return OPEN_P; }
[)] { return CLOSE_P; }
[ \t\n] {;}
. { return UNKNOWN; }

%%

int yywrap(void) {
  return 1;
}
