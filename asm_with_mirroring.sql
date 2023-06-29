set lines 9999
set pages 9999
select name
	, round(TOTAL_MB/decode(type,'NORMAL',2,'HIGH',3,1)/1024) TOTAL_GB
	, round(usable_FILE_mb/1024) USABLE_FREE_GB
	, round((HOT_USED_MB+COLD_USED_MB)/decode(type,'NORMAL',2,'HIGH',3,1)/1024) DATA_USE_GB
	,round(REQUIRED_MIRROR_FREE_MB/decode(type,'NORMAL',2,'HIGH',3,1)/1024) REQ_FREE_REDUN_GB
	, round((round((HOT_USED_MB+COLD_USED_MB)/decode(type,'NORMAL',2,'HIGH',3,1)/1024)+round(REQUIRED_MIRROR_FREE_MB/decode(type,'NORMAL',2,'HIGH',3,1)/1024))*100/round(TOTAL_MB/decode(type,'NORMAL',2,'HIGH',3,1)/1024),2) PCT_USED
	,type 
from v$asm_diskgroup;