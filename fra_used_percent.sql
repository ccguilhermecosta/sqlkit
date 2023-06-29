select name
	,round(space_limit / 1024 / 1024 / 1024) size_gb
	,round(space_used  / 1024 / 1024 / 1024) used_gb
	,decode(nvl(space_used,0),0,0,round((space_used/space_limit) * 100)) pct_used
from v$recovery_file_dest
order by name;