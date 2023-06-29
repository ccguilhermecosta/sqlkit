SELECT log_date, status, run_duration
FROM dba_scheduler_job_run_details
WHERE job_name = 'REFRESH_ALL_REPORT_TABLES_JOB'
ORDER BY log_date ASC;