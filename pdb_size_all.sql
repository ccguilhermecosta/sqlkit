set linesize 300
col name format a30
select con_id, name, open_mode, total_size/1024/1024/1024 "PDB_SIZE_GB" from v$pdbs;

