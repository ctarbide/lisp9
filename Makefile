
NOFAKE = tools/nofake

CC = gcc

WIDTH = -m32
# WIDTH = -m64

OPTFLAGS = -O2
# OPTFLAGS = -O3
# OPTFLAGS = -O0

WERROR = -pedantic -Werror -fmax-errors=5

CFLAGS = $(WIDTH) -ggdb3 $(OPTFLAGS) -std=c99 \
    -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes \
    -Wshadow -Wconversion -Wdeclaration-after-statement \
    -Wno-unused-parameter \
    $(WERROR)

all:	ls9 # prolog # lisp9.ps

ls9.c: size_t_aux.nw ls9*.nw
	NOFAKE='$(NOFAKE)' $(NOFAKE).sh -L -Rls9.c -ols9.c size_t_aux.nw ls9*.nw

ls9_protos.h: ls9.c
	cproto -ev -DINSIDE_CPROTO ls9.c > .tmp.ls9_protos.h
	mv -f .tmp.ls9_protos.h ls9_protos.h
	chmod a-w ls9_protos.h

ls9.o: ls9.c ls9_protos.h
	$(CC) $(CFLAGS) -c ls9.c

ls9:	ls9.o
	$(CC) $(CFLAGS) -o ls9 ls9.o
	CHMOD='chmod 0555' NOFAKE='$(NOFAKE)' $(NOFAKE).sh -Rdump-image.sh \
		ls9.nw ls9-scripts.nw -odump-image.sh
	./dump-image.sh

lisp9.tr:	lisp9.txt
	./ls9 src/print.ls9 -T -C -p 60 -l 6 -m -4 -t "LISP9 REFERENCE MANUAL" \
		lisp9.txt >lisp9.tr

lisp9.ps:	lisp9.tr
	groff -Tps -P-p11i,8.5i lisp9.tr >lisp9.ps

test:	ls9 ls9.image
	./ls9 test.ls9

ptest:	ls9 prolog
	./ls9 -i prolog -- -q <src/test.pl9 > src/test.out
	diff -u src/test.OK src/test.out && rm src/test.out

zebra:	ls9 prolog src/zebra.pl9
	echo "prlist([])." \
	     "prlist([H|T]) :- write(H), nl, prlist(T)." \
	     ":- nl, zebra(H), !, prlist(H), fail." \
	     | ./ls9 -i prolog -- -q -c src/zebra.pl9

prolog:	ls9 src/prolog.ls9 src/prolog.pl9
	echo "(defun (start) (prolog) (quit)) (dump-image \"prolog\")" \
		| ./ls9 -ql src/prolog.ls9

arc:	clean
	./archive.sh

dist:   clean
	./release.sh

csums:
	csum -u <_csums >_csums.new
	mv _csums.new _csums

mksums:	clean
	find . -type f | grep -v _csums |grep -v $A | csum >_csums

clean:
	rm -f ls9.c ls9_protos.h ls9 ls9.image ls9-*.image \
		dump-image.sh archive.sh release.sh *.oimage prolog \
		lisp9.ps lisp9.tr lisp9.ps $A $R a.out *.core
