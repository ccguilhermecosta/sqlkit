set serveroutput on size 10000;
declare 
total_new NUMBER(10) := 2477320;    --<-- Valor do Disco atual mais o valor que sera adicionado
free_new NUMBER(10) := 748452;      --<-- Espaco livre atual mais o valor que sera adicionado

BEGIN
dbms_output.put_line('=======================================================================================' );
dbms_output.put_line('===            Script para estimar o comsumo do disco apos o resize                  ==' );
dbms_output.put_line('=======================================================================================' );
dbms_output.put_line('--                                       |' );
dbms_output.put_line('--                                       |' );
dbms_output.put_line('--                                       V' );
dbms_output.put_line('=======================================================================================' );
dbms_output.put_line('    Novo valor do Disco em GB: ' || total_new  || ', Porcentagem de consumo apos resize: ' 
                          ||ROUND((1- (free_new / total_new))*100, 2)||'%' );
dbms_output.put_line('=======================================================================================' );
end;

/
