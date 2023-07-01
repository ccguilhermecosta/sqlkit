set lines 800
SELECT host_name, instance_name, TO_CHAR(startup_time, 'DD-MM-YYYY HH24:MI:SS') startup_time, FLOOR(sysdate-startup_time) days FROM sys.gv_$instance;