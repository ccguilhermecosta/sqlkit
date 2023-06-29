set linesize 300
col segment_name format a40
SELECT * FROM (
select
SEGMENT_NAME,
SEGMENT_TYPE,
BYTES/1024/1024/1024 GB,
TABLESPACE_NAME
from 
dba_segments 
--where tablespace_name='SYSAUX'
order by 3 desc) 
WHERE ROWNUM <= 10;