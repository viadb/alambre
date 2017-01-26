#!/bin/bash

# $1 use the DUMPFILE (output of mysqlbinlog full decode-rows)
br() {echo -e "\n" ;}

echo "50 top events comming from SQL_THREAD"
egrep -o "^###\s(UPDATE|INSERT INTO|DELETE FROM).*$" $1 | sort |  uniq -c | sort -nr | head -50
br
echo "50 top local events"
egrep -o ".*(UPDATE|INSERT INTO|DELETE FROM)\s\w+" $1 | sort | uniq -c | sort -nr | head -50
exit 0
