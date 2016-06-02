#!/bin/bash

LOG=analyze_tables.log
DBLIST=analyze_tables_dblist
BIGTABLES=analyze_tables_tables
source .analyze_tables
HOSTDEST="-h10.10.10.10"

function executeQuery() {
  mysql -BN $HOSTDEST -uroot -p$pw -e "$1" "$2"
}

function analyze() {
  mysqlcheck  $HOSTDEST -uroot -p$pw --analyze "$1" "$2"
}


echo "###" >> $LOG
echo "Start $(date)" >> $LOG
executeQuery "show databases" \
  | egrep -v "information_schema|mysql|performance_schema|test" > $DBLIST

for db in $(<$DBLIST)
do
  executeQuery "SELECT CONCAT(table_schema, '.', table_name) FROM   information_schema.TABLES ORDER  BY data_length + index_length DESC LIMIT  10" $db > $BIGTABLES

  for tab in $(<$BIGTABLES)
  do
    echo "Analyzing $(date): $db $tab" >> $LOG
    analyze $db $tab >> $LOG
  done
done

echo "Done  $(date)" >> $LOG

exit 0
