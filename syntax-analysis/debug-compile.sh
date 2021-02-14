rm ./lex.yy.c
rm ./y.tab.c
rm ./y.tab.h
rm ./y.output
rm ./a.out
flex ./lexical-analysis/print.l
yacc ./syntax-analysis/second.y --debug --verbose -d -v
cc y.tab.c -ll
