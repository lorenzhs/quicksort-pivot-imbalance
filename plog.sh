#!/bin/sh

temp=$(mktemp /tmp/perf_XXXXXX)
perf stat -x ' ' -o ${temp} -- "$@"  | awk 'NR>1{print PREV} {PREV=$0} END{printf("%s ",$0)}'
tail -n +3 ${temp} | grep -v "<not supported>" | tr - _ | awk '{print $2 "=" $1}' | xargs
rm ${temp}
