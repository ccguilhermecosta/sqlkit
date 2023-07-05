with t as
( select TO_CHAR(dbms_metadata.get_ddl('USER','FIS37')) ddl from dual )
select replace(ddl,1,instr(ddl,'DEFAULT')-1)||';'
from t;