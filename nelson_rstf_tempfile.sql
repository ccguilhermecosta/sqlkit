set wrap off
set lines 200
set pages 100
col kbytes           format 99g999g990  heading File|size(MB)
col kmaxsize         format 99g999g990  heading Max|size(MB)
col kautoextensible  format a4         heading Auto
col ktablespace_name format a25        heading Tablespace
col kstatus          format a10        heading Status
col kfile_id         format 990        heading File#
col kfile_name       format a60        heading File
                                                                                                                            
select trunc(bytes/1024/1024) kbytes,
       trunc(maxbytes/1024/1024) kmaxsize,
       autoextensible kautoextensible,
       tablespace_name ktablespace_name,
       status kstatus,
       file_id kfile_id,
       file_name kfile_name
from dba_temp_files
order by tablespace_name, file_name;

