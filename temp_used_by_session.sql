set linesize 400
col username format a20
col osuser format a20
col module format a30
col program format a30
col tablespace format a30
col sid_serial format a20
SELECT   S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module,
          P.program, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
          COUNT(*) statements
 FROM     v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
 WHERE    T.session_addr = S.saddr
 AND      S.paddr = P.addr
 AND      T.tablespace = TBS.tablespace_name
 GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, S.module,
          P.program, TBS.block_size, T.tablespace
 ORDER BY mb_used;