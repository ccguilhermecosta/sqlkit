SET pagesize 500
SET linesize 500 
COL NAME format a20
COL time format a40
SELECT NAME,
       scn,
       time,
       database_incarnation#,
       guarantee_flashback_database,
       Sum(storage_size) / 1024 / 1024 / 1024
FROM   v$restore_point
GROUP  BY NAME,
          scn,
          time,
          database_incarnation#,
          guarantee_flashback_database,
          storage_size; 