set linesize 300
col username format a20
col machine format a20
col program format a40
col wait_class format a20
col event format a40
select sid,s.username,s.program,machine,w.event,w.wait_class,w.seconds_in_wait,to_char(logon_time,'dd/mm/yyyy hh24:mi') logon,sql_id from v$session_wait w
                                                             join v$session s using (sid)
                                                             join v$process p on (s.paddr = p.addr)
                                                             where w.wait_class <> 'Idle';





##Lento mas não tem wait class → CPU
set linesize 300
col username format a20
col machine format a20
col program format a40
col wait_class format a20
col event format a40
select sid,s.username,s.program,osuser,machine,s.event,s.wait_class,s.seconds_in_wait,to_char(logon_time,'dd/mm/yyyy hh24:mi') logon,sql_id from 
                                                                  v$session s 
                                                             join v$process p on (s.paddr = p.addr)
                                                             where s.status='ACTIVE' and s.username <> ' ' 