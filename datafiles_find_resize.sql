SELECT 'alter database datafile '''
       || file_name
       || ''' resize '
       || Round(hwm)
       || 'M;'         command,
       tablespace_name,
       file_name,
       file_size,
       hwm,
       file_size - hwm can_save
FROM   (SELECT /*+ RULE */ ddf.tablespace_name,
                           ddf.file_name
                                  file_name,
                           ddf.bytes / 1048576
                                  file_size,
                           ( ebf.maximum +
                           de.blocks - 1 ) * dbs.db_block_size / 1048576 hwm
        FROM   dba_data_files ddf,
               (SELECT file_id,
                       Max(block_id) maximum
                FROM   dba_extents
                GROUP  BY file_id) ebf,
               dba_extents de,
               (SELECT value db_block_size
                FROM   v$parameter
                WHERE  NAME = 'db_block_size') dbs
        WHERE  ddf.file_id = ebf.file_id
               AND de.file_id = ebf.file_id
               AND de.block_id = ebf.maximum
        ORDER  BY 1,
                  2); 