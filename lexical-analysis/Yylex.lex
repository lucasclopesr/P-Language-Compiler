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
(integer) { yylval.type = INTEGER_TYPE;  return INTEGER_TYPE; }
(real) { yylval.type = REAL_TYPE; return REAL_TYPE; }
(boolean) { yylval.type = BOOL_TYPE; return BOOL_TYPE; }
(char) { yylval.type = CHAR_TYPE; return CHAR_TYPE; }
(program) { return PROGRAM; }

(\+|-|or) { yylval.op = malloc(sizeof(yytext)); strcpy(yylval.op, yytext); return ADDOP; }
(\*|\/|div|mod|and) { yylval.op = malloc(sizeof(yytext)); strcpy(yylval.op, yytext); return MULOP; }
(sin|cos|log|ord|chr|abs|sqrt|exp|eof|eoln) { yylval.op = malloc(sizeof(yytext)); strcpy(yylval.op, yytext); return FUNC; }
(false|true) {
  yylval.char_val = malloc(sizeof(yytext));
  strcpy(yylval.char_val, yytext);
  if (strcmp(yytext, "false") == 0){
    return FALSE_CONST;
  }

  return TRUE_CONST;
}
[a-zA-Z]([a-zA-Z]|[0-9])* { yylval.id = malloc(sizeof(yytext)); strcpy(yylval.id, yytext); return IDENTIFIER; }
(\+|-)?([0-9][0-9]*|[0-9][0-9]*(\.[0-9]+)?(E(\+|-)[0-9]+)?) { yylval.num_val = atoi(yytext); return CONST; }
\'.\' { yylval.char_val = yytext[0]; return CHAR_CONST; }
(<=|>=|<>|=|<|>) { yylval.op = malloc(sizeof(yytext)); strcpy(yylval.op, yytext); return RELOP; }
(;|[ ];) { return SEMICOLON; }
: { return COLON; }
(,|[ ],) { yylval.op = malloc(sizeof(yytext)); strcpy(yylval.op, yytext); return COMMA; }
(:=|[ ]:=) { return ASSIGN; }
[(] { return OPEN_P; }
[)] { return CLOSE_P; }
[ \t\n] {;}
. { return UNKNOWN; }

%%

int yywrap(void) {
  return 1;
}
