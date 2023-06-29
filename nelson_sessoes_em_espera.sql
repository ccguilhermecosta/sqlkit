set wrap off
set lines 200
set pages 100
col sid       for 99999
col event     for a40  wrap
col username  for A16  heading 'Username'
col osuser    for A20  heading 'OS user'

select s.sid, decode(s.status, 'ACTIVE', decode(w.state, 'WAITING', w.event, 'Running...'), '???') event, 
       username, osuser
from v$session_wait w, v$session s
where w.event not in ('SQL*Net message from client', 
                      'rdbms ipc message', 
                      'smon timer', 
                      'pmon timer',
                      'wakeup time manager',
                      'Queue Monitor Wait',
                      'jobq slave wait',
                      'ges remote message',
                      'gcs remote message',
                      'wait for unread message on broadcast channel',
                      'Streams AQ: qmn slave idle wait',
                      'Streams AQ: qmn coordinator idle wait',
                      'Streams AQ: waiting for time management or cleanup tasks',
                      'Streams AQ: waiting for messages in the queue')
  and w.sid = s.sid
  and w.sid not in (select sid from v$mystat where rownum = 1)
/
