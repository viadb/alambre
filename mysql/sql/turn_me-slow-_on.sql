
SET GLOBAL slow_query_log_file='/mysql_logs/mysql-slow-test.log';
SET GLOBAL long_query_time=0;
SET GLOBAL slow_query_log_use_global_control='all';


SET GLOBAL slow_query_log_file='/mysql_logs/mysql-slow.log';
SET GLOBAL long_query_time=3;
SET GLOBAL slow_query_log_use_global_control='';
