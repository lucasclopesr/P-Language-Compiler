%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

typedef struct node node;
typedef node *list;
typedef union node_value node_value;

union node_value {
    int int_value;
    float float_value;
    char char_value;
};

struct node
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
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}

%}

%token PROGRAM
%token END_TOKEN THEN_TOKEN
%token CHAR_TYPE BOOL_TYPE REAL_TYPE INTEGER_TYPE ELSE_TOKEN
%token CHAR_CONST CONST  BOOL_CONST IDENTIFIER TRUE_CONST FALSE_CONST SIGN
%right OPEN_P BEGIN_TOKEN IF_TOKEN NOT_TOKEN WHILE_TOKEN UNTIL_TOKEN
%left CLOSE_P

%token UNKNOWN RELOP FUNC MULOP ADDOP
%token GOTO_TOKEN WRITE_TOKEN READ_TOKEN 
%token DO_TOKEN SEMICOLON
%token COLON COMMA ASSIGN 

%%

program:                    PROGRAM IDENTIFIER SEMICOLON decl_list compound_stmt
                            ;
decl_list:                  decl_list SEMICOLON decl
                            | decl
                            ;
decl:                       ident_list COLON type
                            ;
ident_list:                 ident_list COMMA IDENTIFIER
                            | IDENTIFIER
                            ;
type:                       INTEGER_TYPE
                            | REAL_TYPE
                            | BOOL_TYPE
                            | CHAR_TYPE
                            ;
compound_stmt:              BEGIN_TOKEN stmt_list END_TOKEN
                            ;
stmt_list:                  stmt_list SEMICOLON stmt
                            | stmt
                            ;
stmt:                       label COLON unlabelled_stmt
                            | unlabelled_stmt
                            ;
label:                      IDENTIFIER
                            ;
unlabelled_stmt:            assign_stmt
                            | if_stmt
                            | loop_stmt
                            | read_stmt
                            | write_stmt
                            | goto_stmt
                            | compound_stmt
                            ;
assign_stmt:                IDENTIFIER ASSIGN expr
                            ;
if_stmt:                    IF_TOKEN cond THEN_TOKEN stmt /* generates shift-reduce, shift is default on yacc */
                            | IF_TOKEN cond THEN_TOKEN stmt ELSE_TOKEN stmt
                            ;
cond:                       expr
                            ;
loop_stmt:                  stmt_prefix DO_TOKEN stmt_list stmt_suffix
                            ;
stmt_prefix:                WHILE_TOKEN cond
                            |
                            ;
stmt_suffix:                UNTIL_TOKEN cond
                            | END_TOKEN
                            ;
read_stmt:                  READ_TOKEN OPEN_P ident_list CLOSE_P
                            ;
write_stmt:                 WRITE_TOKEN OPEN_P expr_list CLOSE_P
                            ;
goto_stmt:                  GOTO_TOKEN IDENTIFIER
                            ;
expr_list:                  expr
                            | expr_list COMMA expr
                            ;
expr:                       simple_expr
                            | simple_expr RELOP simple_expr
                            ;
simple_expr:                term
                            | simple_expr ADDOP term
                            ;
term:                       factor_a
                            | term MULOP factor_a
                            ;
factor_a:                   SIGN factor /* factora != fatora */
                            | factor
                            ;
factor:                     constant /* removed IDENTIFIER (in function_ref already) */
                            | OPEN_P expr CLOSE_P
                            | function_ref
                            | NOT_TOKEN factor
                            ;
function_ref:                IDENTIFIER
                            | function_ref_par
                            ;
function_ref_par:           variable OPEN_P expr_list CLOSE_P
                            ;
variable:                   simple_variable_or_proc
                            | function_ref_par
                            ;
simple_variable_or_proc:    IDENTIFIER
                            ;
constant:                   CONST 
                            | CHAR_CONST
                            | boolean_constant
                            ;
boolean_constant:           FALSE_CONST
                            | TRUE_CONST
                            ;


%%

int main(int argc, char *argv[]) {
        map = new_hashmap(100);
        if (argc == 1){
          yyparse();
        }

        if (argc == 2) {
          yyin = fopen(argv[1], "r");
          yyparse();
        }

        return 0;
}

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
  put(map,key,value)
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
