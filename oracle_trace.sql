******************
** ORACLE TRACE **
******************

- Identificar o usuário pra o trace
set linesize 300
select sid,serial#,program,osuser,module,program,event,machine  from v$session where  lower(osuser) like 'frogerio%';

select sid,serial#,program,osuser,module,program,event,machine  from v$session where  username like '%silva%';


- Identificar o PID
SELECT s.sid,
s.serial#,
'ora_' || p.spid || '.trc' AS trace_file
FROM v$session s,
v$process p
WHERE s.paddr = p.addr and s.sid = 508


- Habilitar o Trace

       SID    SERIAL# TRACE_FILE
---------- ---------- --------------------------------
       508      47643 ora_18993.trc


-- Inicia o Trace
exec dbms_monitor.session_trace_enable(508,47643,true,false);

-- Finaliza o Trace
exec DBMS_MONITOR.SESSION_TRACE_DISABLE(508,47643);


