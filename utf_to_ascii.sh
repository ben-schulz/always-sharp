#!/bin/bash

#
# remove an initial byte-order mark
# (i.e. bytes 0xef 0xbb 0xbf )
# if present,
# and convert dos line-endings
# (i.e. '\r' or '^M')
# to unix
# (i.e. '\n')
#
# \0 (2019.04.19)

file=$1

if [ -z $file ]; then
    file='/dev/stdin'
fi

cat $file | sed -e '1{ s/\xef\xbb\xbf// }; s/\r//; '
