parser: y.tab.c
	gcc -o parser y.tab.c
y.tab.c: PLA.y lex.yy.c
	yacc PLA.y
lex.yy.c: PLA.l
	lex PLA.l
