%{
#include <stdio.h>
#include <string.h>
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
main()
{
        yyparse();
} 

%}

%token PROGRAM
%token CHAR_TYPE BOOL_TYPE REAL_TYPE INTEGER_TYPE ELSE_TOKEN
%token CHAR_CONST CONST  BOOL_CONST IDENTIFIER TRUE_CONST FALSE_CONST SIGN
%right OPEN_P BEGIN_TOKEN IF_TOKEN NOT_TOKEN WHILE_TOKEN UNTIL_TOKEN
%left CLOSE_P END_TOKEN THEN_TOKEN

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
decl:                       ident_list SEMICOLON type
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
expr:                       simple_expr COMMA expr
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
