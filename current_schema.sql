col current_user format a30
select sys_context( 'userenv', 'current_schema' ) as CURRENT_USER from dual;