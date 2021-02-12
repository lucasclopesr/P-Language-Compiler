rm ./lex.yy.c
rm ./y.tab.c
rm ./y.tab.h
rm ./y.output
rm ./a.out
flex ./lexical-analysis/Yylex.lex
yacc ./syntax-analysis/sa-generator.y -d -v
cc y.tab.c -ll
