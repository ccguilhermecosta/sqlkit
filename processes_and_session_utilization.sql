set linesize 300
select
	resource_name, 
	current_utilization, 
	max_utilization 
from 
	v$resource_limit 
where
	resource_name in ('processes','sessions');