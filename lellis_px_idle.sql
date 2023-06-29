-- Sessões Idle a mais de 30 min e com parallel degree >= 100

col qcsid for 99999999999999
col qcserial# for 99999999999999
col req_degree for 99999999999999
col degree for 99999999999999
col program for a40
col machine for a40
col osuser for a30
col idle_time for a30

select
    ps.qcsid,
    ps.qcserial#,
    ps.req_degree,
    ps.degree,
    s.status,
    s.program,
    s.osuser,
    s.machine,
    s.logon_time,
    to_char(extract(day from numtodsinterval(s.last_call_et, 'second')) * 24 + extract(hour from numtodsinterval(s.last_call_et, 'second')), 'fm00000')|| ':' ||
    to_char(extract(minute from numtodsinterval(s.last_call_et, 'second')), 'fm00') || ':' ||
    to_char(extract(second from numtodsinterval(s.last_call_et, 'second')), 'fm00') idle_time
from
    (
        select
            distinct qcsid,
            qcserial#,
            req_degree,
            degree
        from
            v$px_session
        -- Sessoes com parallel >= 100
        where req_degree > 99
        order by
            req_degree desc nulls last,
            degree desc nulls last
    ) ps
    join v$session s on ps.qcsid = s.sid
    and ps.qcserial# = s.serial#
where
    ps.qcserial# is not null
    -- sessoes em idle ha mais de 30 minutos
    and s.last_call_et > 1800
    and s.status = 'INACTIVE';

