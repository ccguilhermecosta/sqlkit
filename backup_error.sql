set pages 400 lines 400
select
sid, output 
from
gv$rman_output 
where SESSION_RECID=&RECID ;