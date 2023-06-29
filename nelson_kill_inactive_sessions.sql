set wrap off
set lines 200
set pages 100
SELECT 'ALTER SYSTEM KILL SESSION '''|| SID || ',' || SERIAL# ||', @'||inst_id|| ''' IMMEDIATE; '
FROM GV$SESSION
WHERE STATUS = 'INACTIVE'
AND TADDR IS NULL;