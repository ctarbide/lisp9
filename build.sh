#!/bin/sh
# automatically generated from Makefile.nw
set -eu
SH=${SH:-sh -eu}; export SH
nofake-exec.sh --error 'Makefile.nw' -- ${SH}
make -f 'Makefile'
