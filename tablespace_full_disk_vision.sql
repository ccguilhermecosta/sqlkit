set linesize 300
col tablespace_name format a15
col file_name format a60
col id format 999
select  tablespace_name
       ,file_name
       ,file_id id
       ,(bytes/1024/1024/1024) file_GB
       ,(maxbytes/1024/1024/1024) filemax_GB
       ,(maxbytes/1024/1024/1024) - (bytes/1024/1024/1024) file_dif_GB
       ,sum(bytes/1024/1024/1024) over (partition by tablespace_name order by tablespace_name ) tbl_GB
       ,sum(maxbytes/1024/1024/1024) over (partition by tablespace_name order by tablespace_name ) tblmax_GB
       ,sum((maxbytes/1024/1024/1024) - (bytes/1024/1024/1024)) over (partition by tablespace_name order by tablespace_name ) tbldiff_GB
       ,sum(bytes/1024/1024/1024) over () TotalFile_GB
       ,sum(maxbytes/1024/1024/1024) over () TotalMax_GB
       ,sum((maxbytes/1024/1024/1024) - (bytes/1024/1024/1024)) over () Totaldiff_GB
from
 dba_data_files
order by tablespace_name,file_name;