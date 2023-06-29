set lines 170
col opname for a36
col target for a40
col "% Concluido" for a20
select inst_id,sid,serial#, opname, target, to_char(round(100*sofar/totalwork,2),'999D00')||' %' as "% Concluido" , sql_id
from sys.gv_$session_longops
where sofar<>totalwork
  and totalwork <> 0
order by opname, sid
/