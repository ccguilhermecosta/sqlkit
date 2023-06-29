set linesize 300
col name format a10
col value format a15
select name,value,datum_time,time_computed from v$dataguard_stats where name = 'apply lag';