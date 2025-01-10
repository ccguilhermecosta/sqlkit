SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET LINES 200;
SET PAGES 2000;

DECLARE
    v_ts_id NUMBER;
    not_in_awr EXCEPTION;
    v_ts_block_size NUMBER;
    v_begin_snap_id NUMBER;
    v_end_snap_id NUMBER;
    v_begin_snap_date DATE;
    v_end_snap_date DATE;
    v_numdays NUMBER;
    v_count NUMBER;
    v_ts_begin_size NUMBER;
    v_ts_end_size NUMBER;
    v_ts_growth NUMBER;
    v_ts_begin_allocated_space NUMBER;
    v_ts_end_allocated_space NUMBER;
    v_db_begin_size NUMBER := 0;
    v_db_end_size NUMBER := 0;
    v_db_begin_allocated_space NUMBER := 0;
    v_db_end_allocated_space NUMBER := 0;
    v_db_growth NUMBER := 0;

    CURSOR v_cur IS 
        SELECT tablespace_name 
        FROM dba_tablespaces 
        WHERE contents = 'PERMANENT';

BEGIN
    FOR v_rec IN v_cur LOOP
        BEGIN
            v_ts_begin_allocated_space := 0;
            v_ts_end_allocated_space := 0;
            v_ts_begin_size := 0;
            v_ts_end_size := 0;

            SELECT ts# 
            INTO v_ts_id 
            FROM v$tablespace 
            WHERE name = v_rec.tablespace_name;

            SELECT block_size 
            INTO v_ts_block_size 
            FROM dba_tablespaces 
            WHERE tablespace_name = v_rec.tablespace_name;

            SELECT COUNT(*) 
            INTO v_count 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id;

            IF v_count = 0 THEN
                RAISE not_in_awr;
            END IF;

            SELECT MIN(snap_id), MAX(snap_id), 
                   MIN(TRUNC(TO_DATE(rtime, 'MM/DD/YYYY HH24:MI:SS'))), 
                   MAX(TRUNC(TO_DATE(rtime, 'MM/DD/YYYY HH24:MI:SS')))
            INTO v_begin_snap_id, v_end_snap_id, 
                 v_begin_snap_date, v_end_snap_date 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id;

            IF UPPER(v_rec.tablespace_name) = 'SYSTEM' THEN
                v_numdays := v_end_snap_date - v_begin_snap_date;
            END IF;

            SELECT ROUND(MAX(tablespace_size) * v_ts_block_size / 1024 / 1024, 2) 
            INTO v_ts_begin_allocated_space 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id AND snap_id = v_begin_snap_id;

            SELECT ROUND(MAX(tablespace_size) * v_ts_block_size / 1024 / 1024, 2) 
            INTO v_ts_end_allocated_space 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id AND snap_id = v_end_snap_id;

            SELECT ROUND(MAX(tablespace_usedsize) * v_ts_block_size / 1024 / 1024, 2) 
            INTO v_ts_begin_size 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id AND snap_id = v_begin_snap_id;

            SELECT ROUND(MAX(tablespace_usedsize) * v_ts_block_size / 1024 / 1024, 2) 
            INTO v_ts_end_size 
            FROM dba_hist_tbspc_space_usage 
            WHERE tablespace_id = v_ts_id AND snap_id = v_end_snap_id;

            v_db_begin_allocated_space := v_db_begin_allocated_space + v_ts_begin_allocated_space;
            v_db_end_allocated_space := v_db_end_allocated_space + v_ts_end_allocated_space;
            v_db_begin_size := v_db_begin_size + v_ts_begin_size;
            v_db_end_size := v_db_end_size + v_ts_end_size;
            v_db_growth := v_db_end_size - v_db_begin_size;
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Summary');
    DBMS_OUTPUT.PUT_LINE('========');
    DBMS_OUTPUT.PUT_LINE('1) Allocated Space: ' || v_db_end_allocated_space || ' MB (' || ROUND(v_db_end_allocated_space / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('2) Used Space: ' || v_db_end_size || ' MB (' || ROUND(v_db_end_size / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('3) Used Space Percentage: ' || ROUND(v_db_end_size / v_db_end_allocated_space * 100, 2) || ' %');
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('History');
    DBMS_OUTPUT.PUT_LINE('========');
    DBMS_OUTPUT.PUT_LINE('1) Allocated Space on ' || v_begin_snap_date || ': ' || v_db_begin_allocated_space || ' MB (' || ROUND(v_db_begin_allocated_space / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('2) Current Allocated Space on ' || v_end_snap_date || ': ' || v_db_end_allocated_space || ' MB (' || ROUND(v_db_end_allocated_space / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('3) Used Space on ' || v_begin_snap_date || ': ' || v_db_begin_size || ' MB (' || ROUND(v_db_begin_size / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('4) Current Used Space on ' || v_end_snap_date || ': ' || v_db_end_size || ' MB (' || ROUND(v_db_end_size / 1024, 2) || ' GB)');
    DBMS_OUTPUT.PUT_LINE('5) Total growth during last ' || v_numdays || ' days between ' || v_begin_snap_date || ' and ' || v_end_snap_date || ': ' || v_db_growth || ' MB (' || ROUND(v_db_growth / 1024, 2) || ' GB)');

    IF (v_db_growth <= 0 OR v_numdays <= 0) THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('No data growth was found for the Database');
    ELSE
        DBMS_OUTPUT.PUT_LINE('6) Per day growth during last ' || v_numdays || ' days: ' || ROUND(v_db_growth / v_numdays, 2) || ' MB (' || ROUND((v_db_growth / v_numdays) / 1024, 2) || ' GB)');
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('Expected Growth');
        DBMS_OUTPUT.PUT_LINE('===============');
        DBMS_OUTPUT.PUT_LINE('1) Expected growth for next 30 days: ' || ROUND((v_db_growth / v_numdays) * 30, 2) || ' MB (' || ROUND(((v_db_growth / v_numdays) * 30) / 1024, 2) || ' GB)');
        DBMS_OUTPUT.PUT_LINE('2) Expected growth for next 60 days: ' || ROUND((v_db_growth / v_numdays) * 60, 2) || ' MB (' || ROUND(((v_db_growth / v_numdays) * 60) / 1024, 2) || ' GB)');
        DBMS_OUTPUT.PUT_LINE('3) Expected growth for next 90 days: ' || ROUND((v_db_growth / v_numdays) * 90, 2) || ' MB (' || ROUND(((v_db_growth / v_numdays) * 90) / 1024, 2) || ' GB)');
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('/\/\/\/\/\/\/\/\/\/\/ END \/\/\/\/\/\/\/\/\/\/\');
    END IF;

EXCEPTION
    WHEN not_in_awr THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('====================================================================================================================');
        DBMS_OUTPUT.PUT_LINE('!!! ONE OR MORE TABLESPACES USAGE INFORMATION NOT FOUND IN AWR !!!');
        DBMS_OUTPUT.PUT_LINE('Execute DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT, or wait for next AWR snapshot capture before executing this script');
        DBMS_OUTPUT.PUT_LINE('====================================================================================================================');
END;
/