program:                    program identifier ; decl_list compound_stmt
                            ;
decl_list:                  decl_list ; decl
                            | decl
                            ;
decl:                       ident_list ; type
                            ;
ident_list:                 ident_list , identifier
                            | identifier
                            ;
type:                       integer
                            | real
                            | boolean
                            | char
                            ;
compound_stmt:              begin stmt_list end
                            ;
stmt_list:                  stmt_list ; stmt
                            | stmt
                            ;
stmt:                       label : unlabelled_stmt
                            | unlabelled_stmt
                            ;
label:                      identifier
                            ;
unlabelled_stmt:            assign_stmt
                            | if_stmt
                            | loop_stmt
                            | read_stmt
                            | write_stmt
                            | goto_stmt
                            | compound_stmt
                            ;
assign_stmt:                identifier := expr
                            ;
if_stmt:                    if cond then stmt
                            | if cond then stmt /* why though */
                            else stmt
                            ;
cond:                       expr
                            ;
loop_stmt:                  stmt_prefix do stmt_list stmt_suffix
                            ;
stmt_prefix:                while cond
                            |
                            ;
stmt_suffix:                until cond   
                            | end
                            ;
read_stmt:                  read ( ident_list )
                            ;
write_stmt                  write ( expr_list )
                            ;
goto_stmt:                  goto identifier
                            ;
expr_list:                  expr
                            | expr_list , expr
                            ;
expr:                       simple_expr , expr
                            | simple_expr RELOP simple_expr
                            ;
simple_expr:                term
                            | simpleexpr   ADDOP   term
                            ;
term:                       factor_a
                            | term   MULOP   factor_a
                            ;
factor_a:                   - factor /* factora != fatora */
                            | factor
                            ;
factor:                     identifier
                            | constant
                            | ( expr )
                            | function_ref
                            | NOT   factor
                            ;
function_ref:                identifier
                            | function_ref_par
                            ;
function_ref_par:           variable ( exprlist )
                            ;
variable:                   simple_variable_or_proc
                            | function_ref_par
                            ;
simple_variable_or_proc:    identifier
                            ;
constant:                   integer_constant
                            | real_constant
                            | char_constant
                            | boolean_constant
                            ;
boolean_constant:           false
                            | true
                            ;