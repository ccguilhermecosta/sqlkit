set wrap off
set lines 200
set pages 100

select
   substr(c.owner,1,15),
   c.object_name,
   c.object_type,
   b.sid,
   b.serial#,
   substr(b.status,1,10),
   b.osuser,
   b.machine
from
   v$locked_object a ,
   v$session b,
   dba_objects c
where
   b.sid = a.session_id
and
   a.object_id = c.object_id;