set linesize 300
col used_bytes format 999999999999
col max_bytes format 999999999999
col free_bytes format 999999999999
SELECT TS.tablespace_name             AS TABLESPACE,
       TS.CONTENTS                    AS TYPE,
       FL.bytes_used                  AS USED_BYTES,
       FL.max_bytes                   AS MAX_BYTES,
       FL.bytes_free                  AS FREE_BYTES,
       Replace(FL.pct_used, ',', '.') AS USED_PCT,
       Decode(TS.status, 'ONLINE', 1,
                         'OFFLINE', 2,
                         'READ ONLY', 3,
                         0)           AS STATUS,
       (SELECT Decode(database_role, 'SNAPSHOT STANDBY', 1,
                                     'LOGICAL STANDBY', 2,
                                     'PHYSICAL STANDBY', 3,
                                     'PRIMARY', 4,
                                     'FAR SYNC', 5,
                                     0) AS ROLE
        FROM   v$database)            AS DATABASE_ROLE
FROM   (SELECT a.tablespace_name,
               Round (a.bytes_alloc)                             bytes_alloc,
               Round (Nvl (b.bytes_free, 0))                     bytes_free,
               Round (( a.bytes_alloc - Nvl (b.bytes_free, 0) )) bytes_used,
               Round (( ( a.bytes_alloc - Nvl (b.bytes_free, 0) ) / a.maxbytes )
                      * 100,
               2)
                                                                 Pct_used,
               Round (maxbytes)                                  MAX_BYTES
        FROM   (SELECT f.tablespace_name,
                       SUM (f.bytes)                                 bytes_alloc
                       ,
                       SUM (
               Decode (f.autoextensible, 'YES', f.maxbytes,
                                         'NO', f.bytes))maxbytes
                FROM   dba_data_files f
                GROUP  BY tablespace_name) a,
               (SELECT f.tablespace_name,
                       SUM (f.bytes) bytes_free
                FROM   dba_free_space f
                GROUP  BY tablespace_name) b
        WHERE  a.tablespace_name = b.tablespace_name(+)
        UNION ALL
        SELECT h.tablespace_name,
               Round (SUM (h.bytes_free + h.bytes_used))
               bytes_alloc,
               Round (SUM (( h.bytes_free + h.bytes_used ) -
                           Nvl (p.bytes_used, 0)))
               bytes_free,
               Round (SUM (Nvl (p.bytes_used, 0)))
               bytes_used,
               Round (( SUM (Nvl (p.bytes_used, 0)) / SUM (
                               Decode (f.autoextensible, 'YES', f.maxbytes,
                                                  'NO', f.bytes)) ) * 100, 2)
               pct_used,
               Round (SUM (Decode (f.autoextensible, 'YES', f.maxbytes,
                                                     'NO', f.bytes)))
               MAX_BYTES
        FROM   sys.gv_$temp_space_header h,
               sys.gv_$temp_extent_pool p,
               dba_temp_files f
        WHERE  p.file_id(+) = h.file_id
               AND p.tablespace_name(+) = h.tablespace_name
               AND p.inst_id(+) = h.inst_id
               AND f.file_id = h.file_id
               AND f.tablespace_name = h.tablespace_name
        GROUP  BY h.tablespace_name)FL
       inner join dba_tablespaces TS
               ON FL.tablespace_name = TS.tablespace_name
ORDER  BY 1; 