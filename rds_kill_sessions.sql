set serveroutput on;
begin
for i in (
select sid, serial# from gv$session where status='INACTIVE' and type='USER' and last_call_et/60 > 5)
loop
dbms_output.put_line('begin');
dbms_output.put_line('rdsadmin.rdsadmin_util.kill(');
dbms_output.put_line('sid =>'||i.sid||',');
dbms_output.put_line('serial =>'||i.serial#||');');
dbms_output.put_line('end;');
dbms_output.put_line('/');
dbms_output.put_line(' ');
end loop;
end;
