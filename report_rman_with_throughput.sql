select controle,input_type,status,start_time,end_time,TIME_TAKEN_DISPLAY,INPUT_BYTES_PER_SEC_DISPLAY,OUTPUT_BYTES_PER_SEC_DISPLAY,INPUT_BYTES_DISPLAY,OUTPUT_BYTES_DISPLAY,device_type from (
select
row_number() over (order by session_key,start_time) linhas,
count(*) over () limite,
session_key,session_recid,
start_time start_time2,
fname Controle,
 INPUT_TYPE, STATUS,
 to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
 to_char(END_TIME,'mm/dd/yy hh24:mi')   end_time,
   TIME_TAKEN_DISPLAY,
   INPUT_BYTES_PER_SEC_DISPLAY,
   OUTPUT_BYTES_PER_SEC_DISPLAY,
   INPUT_BYTES_DISPLAY,
   OUTPUT_BYTES_DISPLAY,
 OUTPUT_DEVICE_TYPE  device_type
 from V$RMAN_BACKUP_JOB_DETAILS det left outer join ( select session_key,session_recid,fname from 
 (select max(btype_key) bs_key,session_key,session_recid from v$backup_controlfile_details group by session_key,session_recid)
 join v$backup_files using (bs_key) where fname is not null) using (session_key,session_recid)
  ) where linhas > limite -50
order by session_key,start_time2