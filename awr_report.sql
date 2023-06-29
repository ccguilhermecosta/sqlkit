--gerar relatório

@$ORACLE_HOME/rdbms/admin/awrrpt.sql

--mandar para a pasta temp, para extração

[oracle@exacc0201vm01 ~]$ chmod 777 awr_rwms2.lst
[oracle@exacc0201vm01 ~]$ cp awr_rwms2.lst /tmp

--relatório dentro de um banco único

@?/rdbms/admin/awrrpt.sql

--relatório dentro de cluster

@?/rdbms/admin/awrgrpt.sql