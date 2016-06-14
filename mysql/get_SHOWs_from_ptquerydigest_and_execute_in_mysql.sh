#!/bin/bash
# $1 file
# $2 password
# $3 output

# Input is the output of pt-query-digest

egrep "SHOW.[TABLE|CREATE].*" $1 \
| sed 's/^#\s*//' | sed 's/\\/\\\\/g' | sort | uniq \
| sed "s/'/\\\'/g" | xargs -i mysql --user=admin --password=$2 -e {} > $3

