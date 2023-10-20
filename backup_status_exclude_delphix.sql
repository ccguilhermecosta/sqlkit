set linesize 300
col STATUS format a25
col TIME_TAKEN_DISPLAY format a10
col hrs format 999.99
SELECT j.session_recid,
       j.session_stamp,
       j.command_id,
       To_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss')    start_time,
       To_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss')      end_time,
       Trunc(j.input_bytes / 1024 / 1024)                input_mbytes,
       Trunc(j.output_bytes / 1024 / 1024)               output_mbytes,
       j.status,
       j.input_type,
       Decode(To_char(j.start_time, 'd'), 1, 'Sunday',
                                          2, 'Monday',
                                          3, 'Tuesday',
                                          4, 'Wednesday',
                                          5, 'Thursday',
                                          6, 'Friday',
                                          7, 'Saturday') dow,
       Trunc(j.elapsed_seconds)                          elapsed_seconds,
       j.time_taken_display,
       Round(j.input_bytes_per_sec / 1024 / 1024, 2)     AS "INPUT MB/s",
       Round(j.output_bytes_per_sec / 1024 / 1024, 2)    AS "OUTPUT MB/s"
FROM   v$rman_backup_job_details j
WHERE  j.start_time > Trunc(sysdate) - 1
       --and j.input_type<>'ARCHIVELOG' 
       AND j.command_id NOT LIKE 'DLPX%'
       AND j.command_id NOT LIKE 'SNL%'
--AND STATUS <>'FAILED'
ORDER  BY j.start_time; 