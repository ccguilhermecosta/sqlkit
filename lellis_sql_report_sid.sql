/* sql_report_sid.sql
 *
 * Autor:      Lucas Pimentel Lellis (lucas.lellis@cgi.com)
 * Descricao:  Gera um report do real-time sql monitoring
 * Utilizacao: @sql_report_sid sid inst_id
 *
 * Ref.: https://oracle-base.com/articles/11g/real-time-sql-monitoring-11gr1
 */

store set %temp%\sqlenv replace

SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIM ON
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
SET TERM ON
SET VERIFY OFF
SET HEAD OFF

SELECT DBMS_SQLTUNE.REPORT_SQL_MONITOR(
  session_id   => '&1',
  inst_id      => '&2',
  type         => 'TEXT',
  report_level => 'ALL') AS report
FROM dual;

@%temp%\sqlenv
prompt

undef 1