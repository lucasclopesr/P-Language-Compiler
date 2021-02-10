%{
#include <stdio.h>
#include <string.h>
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
main()
{
        yyparse();
} 

%}

%token UNKNOWN RELOP CHAR_CONST REAL_CONST INTEGER_CONST IDENTIFIER BOOL_CONST
%token FUNC MULOP ADDOP PROGRAM CHAR_TYPE BOOL_TYPE REAL_TYPE INTEGER_TYPE 
%token NOT_TOKEN GOTO_TOKEN WRITE_TOKEN READ_TOKEN UNTIL_TOKEN WHILE_TOKEN
%token DO_TOKEN END_TOKEN BEGIN_TOKEN ELSE_TOKEN THEN_TOKEN  IF_TOKEN SEMICOLON
%token COLON COMMA ASSIGN OPEN_P 

%%

commands: /* empty */
        | commands command
        ;

command:
        heat_switch
        |
        target_set
        ;

heat_switch:
        TOKHEAT STATE
        {
                printf("\tHeat turned on or off\n");
        }
        ;

target_set:
        TOKTARGET TOKTEMPERATURE NUMBER
        {
                printf("\tTemperature set\n");
        }
        ;

%%
