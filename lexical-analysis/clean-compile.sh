rm ./lex.yy.c
rm ./outputs/hello
flex Yylex.lex
gcc -o outputs/hello lex.yy.c -lfl
