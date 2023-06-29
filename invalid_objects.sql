set linesize 300
col object_type format a15
col quantidade format 9999
select
	object_type
	,count(*) QUANTIDADE
from
	dba_objects
where
	status <> 'VALID'
group by
	object_type;