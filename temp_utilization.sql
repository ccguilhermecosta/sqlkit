set linesize 300
col tablespace format a30
SELECT A.tablespace_name tablespace, D.gb_total,
    SUM (A.used_blocks * D.block_size) / 1024 / 1024 / 1024 gb_used,
    D.gb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 / 1024 gb_free
   FROM v$sort_segment A,
    (
   SELECT B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 / 1024 gb_total
    FROM v$tablespace B, v$tempfile C
     WHERE B.ts#= C.ts#
      GROUP BY B.name, C.block_size) D
    WHERE A.tablespace_name = D.name
    GROUP by A.tablespace_name, D.gb_total;