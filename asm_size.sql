set linesize 300
col ocupado format a15
select 
	name,
	state,
	total_mb/1024 Total_GB,
	free_mb/1024 Free_GB,
	to_char((((TOTAL_MB - FREE_MB) / TOTAL_MB)  * 100),999.99)|| ' %' Ocupado,
	type 
from 
	v$asm_diskgroup; 