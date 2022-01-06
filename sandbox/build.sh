#!/bin/sh
set -eux
cat<<'EOF'>ls9rtt.r
/* va_list is not ansi, define here just to include system headers without
 * issue
 */
#define __DEFINED_va_list
typedef void *va_list;
typedef void *__builtin_va_list;
#define INSIDE_CPROTO
EOF
nofake -Rls9.c size_t_aux.nw ls9*.nw >>ls9rtt.r
rtt -x -D__RTT__=1 ls9rtt.r
nofake-coalesce.pl <ls9rtt.nw > a
mv -fv a ls9rtt.nw
cat<<'EOF'>a.c
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE           600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE         200112L
#endif
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <locale.h>
#include <ctype.h>
#include <limits.h>
#include <setjmp.h>
#include <signal.h>
EOF
nofake -R'untagged enums' -R'struct imghdr' -Rglobals \
    -Rprotos -Rimpl ls9rtt.nw >> a.c
gcc -O2 -ansi -pedantic -Wall -Werror -fmax-errors=3 a.c
