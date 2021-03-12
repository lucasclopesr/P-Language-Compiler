rm ./lex.yy.c
rm ./y.tab.c
rm ./y.tab.h
rm ./y.output
rm ./a.out
yacc ./syntax-analysis/second.y --debug --verbose -d -v 
flex ./lexical-analysis/print.l
cc y.tab.c -ll
