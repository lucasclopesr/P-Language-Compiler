rm ./lex.yy.c
rm ./outputs/hello
flex P.lex
gcc -o outputs/hello lex.yy.c -lfl
