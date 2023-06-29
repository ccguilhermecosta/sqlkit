set linesize 300
col file_name format a100
set pagesize 999
SELECT FILE# file_nr,
to_char(CHECKPOINT_TIME,'dd/mm/yyyy hh24:mi') checkpoint_time,
name file_name
from v$datafile_header;