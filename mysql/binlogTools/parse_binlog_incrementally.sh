#!/bin/bash

# $1 relay or binlog file

DUMPFILE=_proc_$(echo $1 | grep -o -P "\K[[:digit:]]+$")

if [ -f $1 ]
then
  [ -f $DUMPFILE ] && \
  mysqlbinlog --base64-output='decode-rows' -vvv --start-position=$( tac $DUMPFILE | head -1000 | grep -m1 -oP '^# at \K[[:digit:]]+') $1 >> $DUMPFILE \
  || \
  mysqlbinlog --base64-output='decode-rows' -vvv $1 >> $DUMPFILE
else
  echo "Binlog/Relay do not exists."
  exit 1
fi

exit 0 
