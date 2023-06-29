Set ServerOutput On
Set FeedBack Off
Set Verify Off
Set Heading Off
Set Long 65536
Set LineSize 2000
Set PageSize 0
Set TrimSpool On
Set LongChunkSize 2000

select 'cl scr;' || chr(10) ||
'Prompt --------------------------------------- Conectando ' || banco || chr(10) || 
'' || chr(10) ||
'conn oradba/apdsaccvamtobp11g#2019@' || banco || chr(10) ||
'' || chr(10) ||
'Prompt --------------------------------------- Criando usuário ' || banco || chr(10) || 
'select instance_name from v$instance;' || chr(10) ||
'' || chr(10) ||
'create user USR_DB_AUTOMATION_ESPORADICO identified by "cQu_bb#w5PbI8anp#e" default tablespace users profile default account unlock;' || chr(10) ||
'' || chr(10) ||
'grant create session, alter session to USR_DB_AUTOMATION_ESPORADICO;' || chr(10) ||
'' || chr(10) ||
' ' cmd 
 from bancos a where ambiente = 'P'
 order by 1;