set linesize 300
col STATUS format a25
col hrs format 999.99
select
SESSION_KEY, INPUT_TYPE, STATUS,
to_char(START_TIME,'dd/mm/yy hh24:mi') start_time,
to_char(END_TIME,'dd/mm/yy hh24:mi')   end_time,
elapsed_seconds/3600                   hrs,
input_bytes/1024/1024/1024   ent,
output_bytes/1024/1024/1024  sai
from V$RMAN_BACKUP_JOB_DETAILS
order by session_key,start_time;