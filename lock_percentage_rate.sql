SELECT 'SESSION::Lock rate' ,(cnt_block / cnt_all)* 100 pct
FROM ( SELECT COUNT(*) cnt_block FROM gv$session WHERE blocking_session IS NOT NULL), ( SELECT COUNT(*) cnt_all FROM gv$session);