CREATE USER KFA IDENTIFIED BY bmw325xi;

--ALTER USER KFA IDENTIFIED BY bmw325xi;

GRANT CONNECT, CREATE SESSION, RESOURCE TO KFA; 
GRANT CREATE SESSION TO KFA;

ALTER USER KFA quota unlimited on USERS;

SELECT * FROM dba_sys_privs WHERE GRANTEE = 'KFA'; 
SELECT * FROM dba_tab_privs WHERE GRANTEE = 'KFA'; 
SELECT * FROM dba_role_privs WHERE GRANTEE = 'KFA';

SELECT * FROM ALL_USERS 

SELECT * FROM user_sys_privs;

SELECT * FROM dba_sys_privs WHERE grantee = 'kfa';

/*CREATE schema AUTHorization KFA
	CREATE TABLE Cell_Number
	(id NUMBER PRIMARY KEY, Cell_number varchar2(12))
	GRANT ALL ON cell_number TO system;*/

CREATE OR REPLACE DIRECTORY InputDir AS 'D:\OraInputDir'

GRANT READ, WRITE ON Directory InputDir TO KFA;
 
/*
CREATE TABLE ext_Cell_Number
(
CellNumber VARCHAR2(12)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
DEFAULT DIRECTORY InputDir
ACCESS PARAMETERS (
RECORDS DELIMITED BY NEWLINE
BADFILE 'ext_Cell_Number.bad'
LOGFILE 'ext_Cell_Number.log'
DISCARDFILE 'ext_Cell_Number.dis'
--SKIP 1
STRINGs
(
CellNumber CHAR(12)
)
FIELDS TERMINATED BY ','
)
LOCATION ('CellNumbers.csv')
)
REJECT LIMIT UNLIMITED;
*/
--GRANT SELECT ON ext_Cell_Number TO KFA;

SELECT --OWNER, DIRECTORY_NAME, DIRECTORY_PATH, SECONDARY_PATH
* 
FROM DBA_DIRECTORIES ORDER BY DIRECTORY_NAME;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));


SELECT * FROM v$sql WHERE sql_fulltext  LIKE '%WHERE t.INC_NUMBER = cn.CELL_NUMBER AND 1=1%'

/* Сравнить estimated vs actual  */
SELECT 
  p.operation,
  p.options,
  p.object_name,
  p.cardinality AS estimated,
  s.last_output_rows AS actual,
  ROUND(s.last_output_rows / NULLIF(p.cardinality, 0) * 100, 2) || '%' AS diff_percent
FROM v$sql_plan p
JOIN v$sql_plan_statistics_all s ON p.sql_id = s.sql_id 
                                  --AND p.child_number = s.child_number
                                  --AND p.id = p.operation_id
WHERE p.sql_id = '63v5axr2pj79a'
  AND p.cardinality > 0
ORDER BY p.id;

ALTER SESSION SET STATISTICS_level = ALL 

-- Найти SQL_ID в AWR
SELECT sql_id, sql_text
FROM dba_hist_sqltext
WHERE sql_text LIKE '%WHERE t.INC_NUMBER = cn.CELL_NUMBER AND 1=1%'
  AND ROWNUM <= 5;
 
-- Получить план из AWR
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR(
  sql_id => '63v5axr2pj79a',
  plan_hash_value => NULL,
  format => 'TYPICAL'
));

SELECT * FROM v$sql_plan p
WHERE p.sql_id = 'cpwdqy3y9art8'

SELECT * FROM v$sql_plan_statistics_all

-- Для текущего выполняющегося запроса
SELECT DBMS_SQLTUNE.REPORT_SQL_MONITOR(
  sql_id => '63v5axr2pj79a',
  type => 'ACTIVE',
  report_level => 'ALL') AS report
FROM dual;

-- Для последнего выполненного запроса
SELECT DBMS_SQLTUNE.REPORT_SQL_MONITOR(
  sql_id => (SELECT sql_id FROM v$sql 
             WHERE sql_text LIKE '%WHERE t.INC_NUMBER = cn.CELL_NUMBER AND 1=1%' 
             
             AND ROWNUM = 1),
  type => 'TEXT') AS report
FROM dual;

SELECT 
  *
FROM v$sql_plan_statistics_all s
JOIN v$sql_plan p ON p.sql_id = s.sql_id 
                  AND p.child_number = s.child_number
                  --AND p.id = s.operation_id
WHERE p.sql_id = '63v5axr2pj79a'
ORDER BY p.id;