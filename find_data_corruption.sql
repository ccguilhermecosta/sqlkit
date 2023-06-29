select
   relative_fno,
   owner,
   segment_name,
   segment_type
from
   dba_extents
where
   file_id = 1
and
   90268 between block_id and block_id + blocks - 1;