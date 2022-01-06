
# automatically generated from Makefile.nw

SH = sh -eu

SOURCES = \
    Makefile.nw ls9-arith.nw ls9-cli.nw ls9-clsconv.nw ls9-compiler.nw \
    ls9-error.nw ls9-gc.nw ls9-globalenv.nw ls9-ht.nw ls9-img.nw \
    ls9-io.nw ls9-list.nw ls9-litpool.nw ls9-macroexpand.nw ls9-macros.nw \
    ls9-misc.nw ls9-printer.nw ls9-reader.nw ls9-repl.nw ls9-scripts.nw \
    ls9-startup.nw ls9-strings.nw ls9-syncheck.nw ls9-types.nw ls9-vm.nw \
    ls9.nw size_t_aux.nw

TARGETS = listings.nw \
    dump-image.sh lisp9.ps lisp9.tr ls9 ls9.c \
    ls9.image

.PHONY: all
all: $(TARGETS)

listings.nw: $(SOURCES)
	rm -f listings.nw
	nofake-exec.sh --error -R'generate listings.nw' $^ -- $(SH) >listings.nw
	chmod 0444 listings.nw

dump-image.sh: listings.nw \
    ls9 ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'dump-image.sh' Makefile.nw listings.nw -- $(SH)

lisp9.ps: listings.nw \
    lisp9.tr ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'lisp9.ps' Makefile.nw listings.nw -- $(SH)

lisp9.tr: listings.nw \
    lisp9.txt ls9 ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'lisp9.tr' Makefile.nw listings.nw -- $(SH)

ls9: listings.nw \
    ls9.c ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'ls9' Makefile.nw listings.nw -- $(SH)

ls9.c: listings.nw \
    ls9-arith.nw ls9-cli.nw ls9-clsconv.nw ls9-compiler.nw ls9-error.nw \
    ls9-gc.nw ls9-globalenv.nw ls9-ht.nw ls9-img.nw ls9-io.nw \
    ls9-list.nw ls9-litpool.nw ls9-macroexpand.nw ls9-macros.nw ls9-misc.nw \
    ls9-printer.nw ls9-reader.nw ls9-repl.nw ls9-scripts.nw ls9-startup.nw \
    ls9-strings.nw ls9-syncheck.nw ls9-types.nw ls9-vm.nw ls9.nw \
    size_t_aux.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'ls9.c' Makefile.nw listings.nw -- $(SH)

ls9.image: listings.nw \
    dump-image.sh ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'ls9.image' Makefile.nw listings.nw -- $(SH)

.PHONY: test
test: listings.nw \
    ls9 ls9.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe (.PHONY)' --aa-- 'test' Makefile.nw listings.nw -- $(SH)

.PHONY: touch
touch:
	-touch -c $(TARGETS)

.PHONY: clean
clean:
	-rm -f $(TARGETS)
