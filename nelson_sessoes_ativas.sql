set wrap off
set lines 200
set pages 100
col exec         for 9999999    heading 'Exec'
col inst         for 99         heading 'Inst'
col text         for a60        heading 'Sql text'
col hash_value   for 9999999999 heading 'Hash value'
col sid          for 99999       heading 'Sid'
col username     for A16        heading 'Username'
col osuser       for A20        heading 'OS user'

prompt
prompt Sessoes ativas
prompt ==============

select distinct s.sid, s.serial#, s.username, osuser, q.hash_value,s.inst_id,s.sql_id, substr(q.sql_text, 1, 60) text
from gv$session s, gv$sql q
where s.status = 'ACTIVE'
  and s.type = 'USER'
  and s.sql_hash_value = q.hash_value
  and s.sql_address = q.address
  and q.child_number = 0
  and s.inst_id = q.inst_id
  and s.sid not in (select sid from v$mystat where rownum = 1)
/