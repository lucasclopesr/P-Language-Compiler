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
    float float_value;
    char char_value;
};

struct node {
  node_value data;
  char key[100];
};

node symbol_table[100];

void updateSymbol(char* key, node_value);

/*struct node
{
    char *key;
    node_value data;
    list next;
};

typedef struct hashmap *hashmap;
struct hashmap
{
    list *l;
    int _arr_len;
};

typedef struct hash_ret hash_ret;
struct hash_ret
{
    char valid;
    node_value value;
};


hash_ret get(hashmap h, char *key);
void put(hashmap h, char *key,  node_value data);
hashmap new_hashmap(int arr_size);
void hashmap_delete(hashmap h);

hashmap map;
*/

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}

%}

/* tokens mapping */
%union {int num_val; char char_val; char* id; char* op;}

%token PROGRAM

%token END_TOKEN

%token <op> CHAR_TYPE
%token <op> BOOL_TYPE
%token <op> REAL_TYPE
%token <op> INTEGER_TYPE

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
%type <num_val> type_num
%type <char_val> type_char
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
%type <op> simple_variable_or_proc
%type <num_val> constant
%type <char_val> boolean_constant 


%%

program:                    PROGRAM IDENTIFIER SEMICOLON decl_list compound_stmt { ; }
                            ;
decl_list:                  decl_list SEMICOLON decl { ; }
                            | decl { ; }
                            ;
decl:                       ident_list COLON type_num { ; }
                            | ident_list COLON type_char { ; }
                            ;
ident_list:                 ident_list COMMA IDENTIFIER { ; }
                            | IDENTIFIER { $$ = $1; }
                            ;
type_num:                   INTEGER_TYPE { $$ = $1; }
                            | REAL_TYPE { $$ = $1; }
                            | BOOL_TYPE { $$ = $1; }
                            ;
type_char:                  CHAR_TYPE { $$ = $1; }
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
                              printf("ADDOP");
                              if (strcmp($2, "+") == 0){
                                $$ = $1 + $3;
                              } else if (strcmp($2, "-") == 0) {
                                $$ = $1 - $3;
                              } else {
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
factor:                     constant { $$ = $1; } /* removed IDENTIFIER (in function_ref already) */
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
                            ;
variable:                   simple_variable_or_proc { $$ = $1; }
                            | FUNC { $$ = $1; }
                            ;
simple_variable_or_proc:    IDENTIFIER { $$ = $1; }
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
  }

  // map = new_hashmap(100);

  if (argc == 2) {
    yyin = fopen(argv[1], "r");
  }

  yyparse();

  return 0;
} 

void updateSymbol(char* key, node_value val){
  int i;
  int last;
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

  printf("id %d inserted in table with value %d\n", last, val);

}

/*
int hash_func(char *key){
    int ret = 0;
    for (int i = 0; key[i] != '\0'; i++){
        ret += key[i];
    }
    return ret;
}

char comp_func(char *k1, char *k2){
    return !strcmp(k1,k2);
}

int hash_map_get_index(hashmap h, char *key)
{
    return hash_func(key) % h->_arr_len;
}

list new_list()
{
    list item = malloc(sizeof(node));
    item->next = item->key = 0;
    return item;
}

char list_add(hashmap h, list item, char *key, node_value value)
{
    if (!item->key)
    {
        item->data = value;
        item->key = key;
        return 1;
    }
    if (comp_func(key, item->key))
    {
        item->data = value;
        return;
    }
    if (!item->next){
        item->next = new_list();
    }

    return list_add(h, item->next, key, value);
}

void put(hashmap h,  char *key, node_value value)
{
    int index = hash_map_get_index(h, key);
    list_add(h, h->l[index], key, value);
}

void assign(char *key, node_value value){
  printf("here");
  put(map,key,value);
}

list list_get(hashmap h, list item, char *key)
{

    if (!item->key)
    {
        return 0;
    }
    if (comp_func(key, item->key))
        return item;
    if (!item->next)
        return 0;

    return list_get(h, item->next, key);
}

list hashmap_get_item(hashmap h, char *key){
    unsigned index = hash_map_get_index(h, key);
    return list_get(h, h->l[index], key);
}

hashmap new_hashmap(int arr_size)
{
    hashmap h = malloc(sizeof(struct hashmap));
    h->l = malloc(arr_size * sizeof(list));
    h->_arr_len = arr_size;
    for (size_t i = 0; i < arr_size; i++)
    {
        h->l[i] = new_list();
    }
    return h;
}

hash_ret get(hashmap h, char *key)
{
    hash_ret ret;
    ret.valid = 0;
    const list item = hashmap_get_item(h, key);
    if (item == 0){
        return ret;
    }
    ret.value = item->data;
    ret.valid = 1;
    return ret;
}

void list_delete(list item)
{
    if (item->next)
    {
        list_delete(item->next);
    }
    free(item);
}

void hashmap_delete(hashmap h)
{
    for (size_t i = 0; i < h->_arr_len; i++)
    {
        list cur = h->l[i];
        list_delete(cur);
    }
    free(h->l);
    free(h);
}
*/
