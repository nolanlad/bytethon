LEX = flex 
YACC = yacc -d

CC = gcc

check: y.tab.o lex.yy.o fcomp.o utilities.o
	$(CC) -o check y.tab.o lex.yy.o fcomp.o utilities.o -ll -lm

lex.yy.o: lex.yy.c y.tab.h
lex.yy.o y.tab.o: fcomp.h utilities.h

y.tab.c y.tab.h: check.y
	$(YACC) -v check.y

lex.yy.c: check.l
	$(LEX) check.l

fcomp.o: fcomp.c
	$(CC) -c fcomp.c

utilities.o: utilities.c
	$(CC) -c utilities.c

clean:
	-rm -f *.o lex.yy.c *.tab.*  calc *.output