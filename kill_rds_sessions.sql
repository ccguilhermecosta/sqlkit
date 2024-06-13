BEGIN
  for session_to_drop in (select sid, serial# 
                            from v$session 
                           where username in ('USR_MS_TMS_PRD') and status = 'INACTIVE')  
  loop
    rdsadmin.rdsadmin_util.kill(session_to_drop.sid, session_to_drop.serial#);
  end loop;
end;