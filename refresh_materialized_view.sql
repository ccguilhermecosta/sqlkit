--consulta 
select OWNER,MVIEW_NAME, LAST_REFRESH_DATE, LAST_REFRESH_TYPE
FROM dba_mviews
WHERE owner LIKE '%SIGO%'
AND MVIEW_NAME like '%VW_NOC_OT_ENCERRADO%';




--executa o refresh
select 'exec dbms_mview.refresh('''||OWNER||'.'||MVIEW_NAME||''','''||SUBSTR(LAST_REFRESH_TYPE,1,1)||''');'
from dba_mviews
where owner LIKE '%SIGO%'
AND MVIEW_NAME like '%VW_NOC_OT_ENCERRADO%';  

