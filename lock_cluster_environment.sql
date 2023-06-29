//Query 1

SELECT o.name object_name, u.name owner, lid.*
FROM (SELECT
s.inst_id, s.SID, s.serial#, p.spid,NVL (s.sql_id, 0), s.sql_hash_value,
DECODE (l.TYPE,
'TM', l.id1,
'TX', DECODE (l.request,
0, NVL (lo.object_id, -1),
s.row_wait_obj#
),
-1
) AS object_id,
l.TYPE lock_type,
DECODE (l.lmode,
0, 'NONE',
1, 'NULL',
2, 'ROW SHARE',
3, 'ROW EXCLUSIVE',
4, 'SHARE',
5, 'SHARE ROW EXCLUSIVE',
6, 'EXCLUSIVE',
'?'
) mode_held,
DECODE (l.request,
0, 'NONE',
1, 'NULL',
2, 'ROW SHARE',
3, 'ROW EXCLUSIVE',
4, 'SHARE',
5, 'SHARE ROW EXCLUSIVE',
6, 'EXCLUSIVE',
'?'
) mode_requested,
l.id1, l.id2, l.ctime time_in_mode,s.row_wait_obj#, s.row_wait_block#,
s.row_wait_row#, s.row_wait_file#
FROM gv$lock l,
gv$session s,
gv$process p,
(SELECT object_id, session_id, xidsqn
FROM gv$locked_object
WHERE xidsqn > 0) lo
WHERE l.inst_id = s.inst_id
AND s.inst_id = p.inst_id
AND s.SID = l.SID
AND p.addr = s.paddr
AND l.SID = lo.session_id(+)
AND l.id2 = lo.xidsqn(+)) lid,
SYS.obj$ o,
SYS.user$ u
WHERE o.obj#(+) = lid.object_id
AND o.owner# = u.user#(+)
AND object_id <> -1 ;



//Query 2

SELECT 'Instance '||s1.INST_ID||' '|| s1.username || '@' || s1.machine
    || ' ( SID=' || s1.sid || ','|| s1.serial#||s1.status||  '  )  is blocking '
    || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' ||s2.sql_id
     FROM gv$lock l1, gv$session s1, gv$lock l2, gv$session s2
    WHERE s1.sid=l1.sid AND
     s1.inst_id=l1.inst_id AND
     s2.sid=l2.sid AND
     s2.inst_id=l2.inst_id AND
     l1.BLOCK=1 AND
    l2.request > 0 AND
    l1.id1 = l2.id1 AND
    l2.id2 = l2.id2 ;