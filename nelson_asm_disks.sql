set wrap off
set lines 200
set pages 100
col path format a40
set feedback off

select GROUP_NUMBER,NAME,PATH,TOTAL_MB/1024 TOTAL_GB,FREE_MB/1024 FREE_GB,STATE
from v$asm_disk;

select GROUP_NUMBER,NAME,TOTAL_MB/1024 TOTAL_GB,FREE_MB/1024 FREE_GB,
        to_char((((TOTAL_MB - FREE_MB) / TOTAL_MB)  * 100),999.99)|| ' %' Ocupado, STATE
from v$asm_diskgroup
where TOTAL_MB > 0
;