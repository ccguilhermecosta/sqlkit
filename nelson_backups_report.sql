set wrap off
set lines 200
set pages 100
SET FEEDBACK OFF
SET VERIFY OFF
-- Altera o modo de otimizacao devido a BUG 5247609 (NOTES 5247609.8 e 375386.1)
ALTER SESSION SET OPTIMIZER_MODE=RULE;

COL dbid        FOR 999999999999999 HEADING "DBID";
COL oper        FOR a25 HEADING "Operacao";
COL tip         FOR a10 HEADING "Tipo";
COL lv          FOR 99  HEADING "LV";
COL stat        FOR a12 HEADING "Status";
COL dev         FOR a08 HEADING "Device";
COL ini         FOR a20 HEADING "Inicio";
COL fim         FOR a20 HEADING "Termino";
COL tam         FOR 99,999,999 HEADING "Tamanho(MB)";

prompt ============================================================================
prompt DBID 
prompt ============================================================================
SELECT dbid FROM v$database;

prompt
prompt ============================================================================
prompt LIST BACKUPs FULL - Ultimos 7 dias
prompt ============================================================================
select
           RECID,
        substr(operation,1,25)                       as "oper",
        object_type                                  as "tip",
        ROW_LEVEL                                    as "lv",
        substr(STATUS,1,15)                          as "stat",
        round(MBYTES_PROCESSED,2)                    as "tam",
           to_char(START_TIME,'DD-MM-RRRR HH24:MI:SS')  as "ini",
        to_char(END_TIME,'DD-MM-RRRR HH24:MI:SS')    as "fim",
           substr(output_device_type,1,10)              as "dev"        
from
        v$rman_status
where
        operation NOT IN ('CATALOG','RMAN','LIST')
        and trunc(END_TIME)>=trunc(sysdate-15)
           and object_type like 'DB%'
order by
        START_TIME DESC; 
 
prompt 
prompt ============================================================================
prompt ALL BACKUPs - Ultimos 3 dias
prompt ============================================================================
select
           RECID,
        substr(operation,1,25)                       as "oper",
        object_type                                  as "tip",
        ROW_LEVEL                                    as "lv",
        substr(STATUS,1,15)                          as "stat",
        round(MBYTES_PROCESSED,2)                    as "tam",
           to_char(START_TIME,'DD-MM-RRRR HH24:MI:SS')  as "ini",
        to_char(END_TIME,'DD-MM-RRRR HH24:MI:SS')    as "fim",
           substr(output_device_type,1,10)              as "dev"        
from
        v$rman_status
where
        operation NOT IN ('CATALOG','RMAN','LIST')
        and trunc(END_TIME)>=trunc(sysdate-7)
order by
        START_TIME DESC;

           
ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS;
SET FEEDBACK ON
SET VERIFY ON
