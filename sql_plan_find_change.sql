set pagesize 1000
set linesize 200
column begin_interval_time format a20
column milliseconds_per_execution format 999999990.999
column rows_per_execution format 999999990.9
column buffer_gets_per_execution format 999999990.9
column disk_reads_per_execution format 999999990.9
break on begin_interval_time skip 1
SELECT
 to_char(s.begin_interval_time,'mm/dd hh24:mi')
 AS begin_interval_time,
 ss.plan_hash_value,
 ss.executions_delta,
 CASE
 WHEN ss.executions_delta > 0
 THEN ss.elapsed_time_delta/ss.executions_delta/1000
 ELSE ss.elapsed_time_delta
 END AS milliseconds_per_execution,
 CASE
 WHEN ss.executions_delta > 0
 THEN ss.rows_processed_delta/ss.executions_delta
 ELSE ss.rows_processed_delta
 END AS rows_per_execution,
 CASE
 WHEN ss.executions_delta > 0
 THEN ss.buffer_gets_delta/ss.executions_delta
 ELSE ss.buffer_gets_delta
 END AS buffer_gets_per_execution,
 CASE
 WHEN ss.executions_delta > 0
 THEN ss.disk_reads_delta/ss.executions_delta
 ELSE ss.disk_reads_delta
 END AS disk_reads_per_execution
FROM wrh$_sqlstat ss
INNER JOIN wrm$_snapshot s ON s.snap_id = ss.snap_id
WHERE ss.sql_id = '&sql_id'
AND ss.buffer_gets_delta > 0
ORDER BY s.snap_id, ss.plan_hash_value;