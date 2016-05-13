
#!/bin/bash
# Download the slow_log table into a file
# http://www.pythian.com/blog/exporting-the-mysql-slow_log-table-into-slow-query-log-format/

hostname=$1
username=$2
outputfile=/tmp/mysql.slow_log.log
reportfile=/tmp/report.txt

mysql -u $username -p -h $hostname -D mysql -s -r -e "SELECT \
CONCAT( '# Time: ', DATE_FORMAT(start_time, '%y%m%d %H%i%s'), '\n', \
'# User@Host: ', user_host, '\n', '# Query_time: ', TIME_TO_SEC(query_time),  \
'  Lock_time: ', TIME_TO_SEC(lock_time), '  Rows_sent: ', rows_sent, '  Rows_examined: ', \
rows_examined, '\n', sql_text, ';' ) FROM mysql.slow_log" > $outputfile

wget percona.com/get/pt-query-digest
chmod +x pt-query-digest
./pt-query-digest --limit=100% --type slowlog $outputfile > $reportfile
rm -f pt-query-digest
