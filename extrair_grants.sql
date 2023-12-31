set long 10000
set pagesize 10000
SELECT * FROM (
SELECT 'GRANT '||PRIVILEGE||' TO '||GRANTEE||';' FROM DBA_SYS_PRIVS
WHERE GRANTEE IN ('RMS')
UNION ALL
SELECT 'GRANT '||PRIVILEGE||' ON '||GRANTOR||'.'||TABLE_NAME||' TO '||GRANTEE||';' FROM DBA_TAB_PRIVS
WHERE GRANTEE IN ('RMS')
UNION ALL
SELECT 'GRANT '||GRANTED_ROLE||' TO '||GRANTEE||';' FROM DBA_ROLE_PRIVS
WHERE GRANTEE IN ('RMS'));