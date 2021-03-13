%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lex.yy.c"
#include <math.h>
 
typedef struct node node;
typedef node *list;
typedef union node_value node_value;

union node_value {
  int int_value;
  float real_value;
  char char_value;
};

struct node {
  int type;
  node_value data;
  char key[100];
};

#define SYMBOLS 100
node symbol_table[SYMBOLS];

void updateSymbol(char* key, node_value);
node getSymbol(char* key);
char id_buffer[100][10]; // Variable names are limited to 10 characters
int buffer_idx = 0;

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}

%}

/* tokens mapping */
%union {int num_val; char char_val; char* id; char* op; int type;}

%token PROGRAM

%token END_TOKEN

%token <type> CHAR_TYPE
%token <type> BOOL_TYPE
%token <type> REAL_TYPE
%token <type> INTEGER_TYPE

%token <num_val> CONST
%token <char_val> CHAR_CONST
%token <char_val> TRUE_CONST
%token <char_val> FALSE_CONST
%token <id> IDENTIFIER

%token <op> SIGN
%token <op> RELOP
%token <op> FUNC
%token <op> MULOP
%token <op> ADDOP

%token <op> GOTO_TOKEN
%token <op> WRITE_TOKEN
%token <op> READ_TOKEN 

%token <op> DO_TOKEN
%right <op> WHILE_TOKEN
%right <op> UNTIL_TOKEN

%token <op> SEMICOLON

%token <op> COLON
%token <op> COMMA
%token <op> ASSIGN 

%right <op> OPEN_P
%left <op> CLOSE_P
%right <op> BEGIN_TOKEN

%right <op> IF_TOKEN
%token <op> THEN_TOKEN
%token <op> ELSE_TOKEN

%right <op> NOT_TOKEN
%token <op> UNKNOWN

/* non-terminal types */
%type <id> assign_stmt
%type <num_val> type
%type <id> ident_list
%type <id> label
%type <num_val> expr
%type <num_val> cond 
%type <op> if_stmt
%type <num_val> stmt
%type <num_val> expr_list
%type <num_val> simple_expr
%type <num_val> term
%type <num_val> factor_a 
%type <num_val> factor
%type <num_val> function_ref
%type <id> variable
%type <num_val> simple_variable_or_proc
%type <num_val> constant
%type <char_val> boolean_constant 


%%

program:                    PROGRAM IDENTIFIER SEMICOLON decl_list compound_stmt { ; }
                            ;
decl_list:                  decl_list SEMICOLON decl { ; }
                            | decl { ; }
                            ;
decl:                       ident_list COLON type {
                              int i;
                              
                              for (i = 0; i < buffer_idx; i++) {
                                updateSymbolType(id_buffer[i], $3);
                                // printf("In buffer: %s\n", id_buffer[i]);
                              }
                            }
                            ;
ident_list:                 ident_list COMMA IDENTIFIER {
                              if (buffer_idx == 0) {
                                strcpy(id_buffer[buffer_idx], $1);
                                buffer_idx++;
                                strcpy(id_buffer[buffer_idx], $3);
                              } else {
                                strcpy(id_buffer[buffer_idx], $3);
                              } 
                              buffer_idx++;
                            }
                            | IDENTIFIER {
                              strcpy(id_buffer[buffer_idx], $1);
                              buffer_idx++;
                              $$ = $1;
                            }
                            ;
type:                       INTEGER_TYPE { $$ = $1; }
                            | REAL_TYPE { $$ = $1; }
                            | BOOL_TYPE { $$ = $1; }
                            | CHAR_TYPE { $$ = $1; }
                            ;
compound_stmt:              BEGIN_TOKEN stmt_list END_TOKEN { ; }
                            ;
stmt_list:                  stmt_list SEMICOLON stmt { ; }
                            | stmt { ; }
                            ;
stmt:                       label COLON unlabelled_stmt { ; }
                            | unlabelled_stmt { ; }
                            ;
label:                      IDENTIFIER { $$ = $1; }
                            ;
unlabelled_stmt:            assign_stmt { ; }
                            | if_stmt { ; }
                            | loop_stmt { ; }
                            | read_stmt { ; }
                            | write_stmt { ; }
                            | goto_stmt { ; }
                            | compound_stmt { ; }
                            ;
assign_stmt:                IDENTIFIER ASSIGN expr {
                              updateSymbol($1, (node_value) $3);
                            }
                            ;
if_stmt:                    IF_TOKEN cond THEN_TOKEN stmt {
                              if ($2) {
                                $$ = $4;
                              }
                            } /* generates shift-reduce, shift is default on yacc */
                            | IF_TOKEN cond THEN_TOKEN stmt ELSE_TOKEN stmt {
                              if ($2) {
                                $$ = $4;
                              } else {
                                $$ = $6;
                              } 
                            }
                            ;
cond:                       expr { $$ = $1; }
                            ;
loop_stmt:                  stmt_prefix DO_TOKEN stmt_list stmt_suffix { ; }
                            ;
stmt_prefix:                WHILE_TOKEN cond { ; }
                            |
                            ;
stmt_suffix:                UNTIL_TOKEN cond { ; }
                            | END_TOKEN { ; }
                            ;
read_stmt:                  READ_TOKEN OPEN_P ident_list CLOSE_P { ; }
                            ;
write_stmt:                 WRITE_TOKEN OPEN_P expr_list CLOSE_P { ; }
                            ;
goto_stmt:                  GOTO_TOKEN IDENTIFIER { ; }
                            ;
expr_list:                  expr { $$ = $1; }
                            | expr_list COMMA expr { ; }
                            ;
expr:                       simple_expr { $$ = $1; }
                            | simple_expr RELOP simple_expr { $$ = $1 > $3; }
                            ;
simple_expr:                term { $$ = $1; }
                            | simple_expr ADDOP term {
                              if (strcmp($2, "+") == 0){
                                $$ = $1 + $3;
                                printf("%d + %d: %d\n", $1, $3, $$);
                              } else if (strcmp($2, "-") == 0) {
                                printf("minus");
                                $$ = $1 - $3;
                              } else {
                                printf("or");
                                $$ = $1 || $3;
                              }
                            }
                            ;
term:                       factor_a { $$ = $1; }
                            | term MULOP factor_a {
                              if (strcmp($2, "*") == 0){
                                $$ = $1 * $3;
                              } else if (strcmp($2, "/") == 0 || strcmp($2, "div") == 0) {
                                $$ = $1 / $3;
                              } else if (strcmp($2, "mod") == 0){
                                $$ = $1 % $3;
                              } else {
                                $$ = $1 && $3;
                              }
                            }
                            ;
factor_a:                   SIGN factor  {
                              if ($1 == '+') { 
                                $$ = $2;
                              } else {
                                $$ = -$2;
                              }
                            } /* factora != fatora */
                            | factor { $$ = $1; }
                            ;
factor:                     constant { $$ = $1; }
                            | OPEN_P expr CLOSE_P { $$ = $2; }
                            | function_ref { $$ = $1; }
                            | NOT_TOKEN factor { $$ = $2; }
                            ;
function_ref:               variable OPEN_P simple_expr CLOSE_P {
                              if (strcmp($1, "sin") == 0){
                                printf("sin");
                                /* $$ = sin($3); */
                              } else if (strcmp($1, "cos") == 0) {
                                printf("cos");
                                /* $$ = cos($3); */
                              } else if (strcmp($1, "log") == 0){
                                /* $$ = log($3); */
                              } else if (strcmp($1, "ord") == 0){
                                /* $$ = ord($3); */
                              } else if (strcmp($1, "chr") == 0){
                                /* $$ = chr($3); */
                              } else if (strcmp($1, "abs") == 0){
                                printf("abs");
                                /* $$ = abs($3); */
                              } else if (strcmp($1, "sqrt") == 0){
                                printf("sqrt");
                                /* $$ = sqrt($3); */
                              } else if (strcmp($1, "exp") == 0){
                                /* $$ = exp($3); */
                              } else if (strcmp($1, "eof") == 0){
                                /* $$ = eof($3); */
                              } else if (strcmp($1, "eoln") == 0){
                                /* $$ = eoln($3); */
                              }                            
                            }
                            | IDENTIFIER {
                              node n;
                              n = getSymbol($1);
                              if (n.type == -1) {
                                // Symbol not found
                                printf("Symbol not found: %s", $1);
                              } else {
                                if (n.type == INTEGER_TYPE || n.type == BOOL_TYPE) {
                                  printf("\nint or bool\n");
                                  $$ = n.data.int_value;
                                } else if (n.type == REAL_TYPE) {
                                  printf("\nreal\n");
                                  // REAL
                                  $$ = n.data.real_value;
                                } else if (n.type == CHAR_TYPE) {
                                  printf("\nchar\n");
                                  // CHAR
                                  $$ = n.data.char_value;
                                }
                              }
                            }
                            ;
variable:                   simple_variable_or_proc { $$ = $1; }
                            | FUNC { $$ = $1; }
                            ;
simple_variable_or_proc:    IDENTIFIER {
                              node n = getSymbol($1);
                              if (n.type == -1) {
                                // Symbol not found
                                printf("Symbol not found: %s", $1);
                              } else {
                                if (n.type == INTEGER_TYPE || n.type == BOOL_TYPE) {
                                  printf("\nint or bool\n");
                                  $$ = n.data.int_value;
                                } else if (n.type == REAL_TYPE) {
                                  printf("\nreal\n");
                                  // REAL
                                  $$ = n.data.real_value;
                                } else if (n.type == CHAR_TYPE) {
                                  printf("\nchar\n");
                                  // CHAR
                                  $$ = n.data.char_value;
                                }
                              }
                            }
                            ;
constant:                   CONST  { $$ = $1; }
                            | CHAR_CONST { $$ = $1; }
                            | boolean_constant { $$ = $1; }
                            ;
boolean_constant:           FALSE_CONST { $$ = $1; }
                            | TRUE_CONST { $$ = $1; }
                            ;


%%

int main(int argc, char *argv[]) {
  int i;

  // Initializes empty symbol_table
  for (i = 0; i < 100; i++){
    strcpy(symbol_table[i].key, "none");
    symbol_table[i].type = -1;
  }

  // map = new_hashmap(100);

  if (argc == 2) {
    yyin = fopen(argv[1], "r");
  }

  yyparse();
  print_symbols();
  return 0;
} 

node getSymbol(char* key) {
  int i;
  node n;
  n.type = -1;

  for (i = 0; i < 100; i++){
    
    if (strcmp(symbol_table[i].key, key) == 0){
      // printf("\nSYMBOL FOUND! i = %d\nSymbol val: %d\nSymbol type: %d\n\n", i, symbol_table[i].data, symbol_table[i].type);
      return symbol_table[i];
    }
  }

  printf("Variable not found");
  return n;
  
}

void updateSymbolType(char* key, int type){
  int i;
  int last = 0;
  int was_updated = 0; 

  for (i = 0; i < 100; i++){
    
    if (strcmp(symbol_table[i].key, "none") != 0){
      last = i;
    }

    if (strcmp(symbol_table[i].key, key) == 0){
      symbol_table[i].type = type;
      was_updated = 1;
    }
  }

  if (!was_updated) {
    if (last < 99) {
      strcpy(symbol_table[last+1].key, key);
      symbol_table[last+1].type = type;
    } else {
      printf("Memoria cheia!");
    }
  }

  // printf("id %d inserted in table with type %d\n", last, type);

}

void updateSymbol(char* key, node_value val){
  int i;
  int last = 0;
  int was_updated = 0; 

  for (i = 0; i < 100; i++){
    
    if (strcmp(symbol_table[i].key, "none") != 0){
      last = i;
    }

    if (strcmp(symbol_table[i].key, key) == 0){
      symbol_table[i].data = val;
      was_updated = 1;
    }
  }

  if (!was_updated) {
    if (last < 99) {
      strcpy(symbol_table[last+1].key, key);
      symbol_table[last+1].data = val;
    } else {
      printf("Memoria cheia!");
    }
  }

  // printf("id %d inserted in table with value %d\n", last, val);
}

print_symbols(){
  printf("Symbol's table:\n");
  for (int i = 0; i < SYMBOLS; i++){
      if(symbol_table[i].type > -1){
        printf("%s: ", symbol_table[i].key);
        if(symbol_table[i].type == INTEGER_TYPE){
          printf("%d\n", symbol_table[i].data.int_value);
        } else if (symbol_table[i].type == CHAR_TYPE){
          printf("%c\n", symbol_table[i].data.char_value);
        } else if (symbol_table[i].type == BOOL_TYPE){
          printf("%d\n", symbol_table[i].data.int_value);
        } else if (symbol_table[i].type == REAL_TYPE){
          printf("%f\n", symbol_table[i].data.real_value);
        } else {
          printf("null\n");
        }
      }
  }
}
