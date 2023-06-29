#####################
##IDENTIFICAR LOCKS##
#####################

- Consulta de forma hierárquica 

select  lpad(' ',3*(level-1)) || waiting_session waiting_session,
   (select serial# from v$session sess where sess.sid=sw.waiting_session) serial,
   (select username from v$session sess where sess.sid=sw.waiting_session) username,
    lock_type,
    mode_requested,
    mode_held,
    lock_id1,
    lock_id2
--  (select  (select owner||'.'||object_name from dba_objects obj where  obj.object_id=lk.object_id)from v$locked_object lk where xidsqn = lock_id2) table_name
 from
  (select w.session_id waiting_session,
        h.session_id holding_session,
        w.lock_type lock_type,
        h.mode_held mode_held,
        w.mode_requested mode_requested,
        w.lock_id1 lock_id1,
        w.lock_id2 lock_id2
  from (select * from dba_locks) w, (select * from dba_locks) h
 where h.blocking_others =  'Blocking'
  and  h.mode_held      !=  'None'
  and  h.mode_held      !=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type       =  h.lock_type
  and  w.lock_id1        =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2
  union all
  (select holding_session, null, 'None', null, null, null, null
    from (  select w.session_id waiting_session,
        h.session_id holding_session,
        w.lock_type lock_type,
        h.mode_held mode_held,
        w.mode_requested mode_requested,
        w.lock_id1 lock_id1,
        w.lock_id2 lock_id2
  from (select * from dba_locks) w, (select * from dba_locks) h
 where h.blocking_others =  'Blocking'
  and  h.mode_held      !=  'None'
  and  h.mode_held      !=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type       =  h.lock_type
  and  w.lock_id1        =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2)
 minus
  select waiting_session, null, 'None', null, null, null, null
    from (  select w.session_id waiting_session,
        h.session_id holding_session,
        w.lock_type lock_type,
        h.mode_held mode_held,
        w.mode_requested mode_requested,
        w.lock_id1 lock_id1,
        w.lock_id2 lock_id2
  from (select * from dba_locks) w, (select * from dba_locks) h
 where h.blocking_others =  'Blocking'
  and  h.mode_held      !=  'None'
  and  h.mode_held      !=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type       =  h.lock_type
  and  w.lock_id1        =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2))) sw
  connect by  prior waiting_session = holding_session
  start with holding_session is null;

- Após descobrir a sessão, visualizar a máquina que está causando o problema

set linesize 300
col uisername format a20
col machine format a20
col program format a15
select sid,s.serial#,s.osuser,s.username,s.program,machine,to_char(logon_time,'dd/mm/yyyy hh24:mi') logonp, spid from v$session_wait w
                                                             join v$session s using (sid)
                                                             join v$process p on (s.paddr = p.addr)
                                                             where sid=849;

- Avisar o cliente do usuário causador, ou matar a sessão




- Consulta em ambiente RAC

SELECT DECODE (l.BLOCK, 0, 'Waiting', 'Blocking ->') user_status
,CHR (39) || s.SID || ',' || s.serial# || CHR (39) sid_serial
,(SELECT instance_name FROM gv$instance WHERE inst_id = l.inst_id)
conn_instance
,s.SID
,s.PROGRAM
,s.osuser
,s.machine
,DECODE (l.TYPE,'RT', 'Redo Log Buffer','TD', 'Dictionary'
,'TM', 'DML','TS', 'Temp Segments','TX', 'Transaction'
,'UL', 'User','RW', 'Row Wait',l.TYPE) lock_type
--,id1
--,id2
,DECODE (l.lmode,0, 'None',1, 'Null',2, 'Row Share',3, 'Row Excl.'
,4, 'Share',5, 'S/Row Excl.',6, 'Exclusive'
,LTRIM (TO_CHAR (lmode, '990'))) lock_mode
,ctime
--,DECODE(l.BLOCK, 0, 'Not Blocking', 1, 'Blocking', 2, 'Global') lock_status
,object_name
FROM
   gv$lock l
JOIN
   gv$session s
ON (l.inst_id = s.inst_id
AND l.SID = s.SID)
JOIN gv$locked_object o
ON (o.inst_id = s.inst_id
AND s.SID = o.session_id)
JOIN dba_objects d
ON (d.object_id = o.object_id)
WHERE (l.id1, l.id2, l.TYPE) IN (SELECT id1, id2, TYPE
FROM gv$lock
WHERE request > 0)
ORDER BY id1, id2, ctime DESC;