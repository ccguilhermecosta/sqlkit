select a.file_id,
       file_name,
       ceil( (nvl(hwm,1)*8192)/1024/1024 ) smallest,
       ceil( blocks*8192/1024/1024) currsize,
       ceil( blocks*8192/1024/1024) -
       ceil( (nvl(hwm,1)*8192)/1024/1024 ) savings,
        AUTOEXTENSIBLE
from dba_data_files a,
     ( select file_id, max(block_id+blocks-1) hwm
         from dba_extents
        group by file_id ) b
where a.file_id = b.file_id(+)
and tablespace_name = 'IPO_STAG'
order by 1 desc
/
