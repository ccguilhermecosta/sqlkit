set lines 2000 Pages 200
col program for a40
col module for a40
col username for a20
col USE_MD for 99999
col name for a30
SELECT s.SID, s.program, s.module, s.username, b.NAME, ROUND(a.VALUE/(1024*1024),2) USE_MB FROM
v$sesstat a, v$statname b, v$session s
WHERE (NAME LIKE '%session uga memory%' OR NAME LIKE '%session pga memory%')
AND a.statistic# = b.statistic# 
AND a.sid=s.sid order by ROUND(a.VALUE/(1024*1024),2) desc
OFFSET 20 ROWS FETCH NEXT 15 ROWS ONLY;