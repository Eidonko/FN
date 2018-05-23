SRC2=fn.y fn.l 

INC=/home/acca/deflorio/include
LIB=/home/acca/deflorio/lib
CFLAGS= #-DHARDEBUG
CC=gcc
# HP-UX:
# CC=cc -Aa

all:	libfn.a fntest julia

libfn.a:	y.tab.c lex.yy.c $(SRC2) fn.h
	$(CC)  $(CFLAGS) -c y.tab.c  -I$(INC) -L$(LIB) -lfl -lm
	ar r libfn.a y.tab.o

fntest:	libfn.a fntest.c
	$(CC) $(CFLAGS) -o fntest fntest.c libfn.a -lm # -ly -lm

julia: jmain.c julia.c jio.c jancilla.c julia.h libfn.a fn.l fn.y
	$(CC) $(CFLAGS) -o julia jmain.c julia.c jio.c jancilla.c libfn.a -lfl -lm

y.tab.c:        fn.y
		flex fn.l
		bison --yacc -d -v fn.y

lex.yy.c:	fn.y fn.l
		bison --yacc -d -v fn.y
		flex fn.l

fn.c:	fn.w
	cweave fn.w
	ctangle fn.w

#a.out:	y.tab.c  lex.yy.c $(SRC)
	#cc y.tab.c -ll -ly
#
#y.tab.c:	$(SRC)
		#bison --yacc -v calc.y
#
#lex.yy.c:	calc.l
		#lex calc.l
