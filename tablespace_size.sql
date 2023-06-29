set linesize 300
set pagesize 300
SELECT  /*+first_rows */
        d.tablespace_name tsname,
        round(nvl(a.bytes , 0)/1024/1024/1024,2)  allocated,
        round((nvl(a.bytes - nvl(f.bytes, 0), 0)) /1024/1024/1024,2) used,
        round(nvl(f.bytes, 0) /1024/1024/1024,2) free,
        round((a.maxbytes-nvl(a.bytes , 0)) /1024/1024/1024,2) max,
        100-((nvl(a.bytes - nvl(f.bytes, 0),0))/((nvl(a.bytes-nvl(f.bytes,0),0))+nvl(f.bytes, 0)+a.maxbytes-nvl(a.bytes,0))*100) perfree
    FROM
        sys.dba_tablespaces d,
        (
            SELECT
                tablespace_name,
                SUM(bytes) bytes,
                COUNT(file_id) count,
                DECODE(SUM(DECODE(autoextensible, 'NO', 0, 1)), 0, 'NO', 'YES') autoext,
                SUM(DECODE(autoextensible, 'YES', maxbytes, bytes)) maxbytes
            FROM
                dba_data_files
            GROUP BY
                tablespace_name
        ) a,
        (
            SELECT
                tablespace_name,
                SUM(bytes) bytes
            FROM
                dba_free_space
            GROUP BY
                tablespace_name
        ) f
    WHERE
        d.tablespace_name = a.tablespace_name (+)
        AND d.tablespace_name = f.tablespace_name (+)
        AND NOT ( d.extent_management = 'LOCAL'
                  AND d.contents = 'TEMPORARY' )
        and d.contents='PERMANENT'          ;