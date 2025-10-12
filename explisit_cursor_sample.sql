CREATE TABLE Migr_RNCB_Indexes
( 
	--id NUMBER PRIMARY KEY,
	rep_date DATE NOT NULL,
   	name varchar2(32) NOT NULL,
   	value number(15,6) NOT NULL
   	,UNIQUE(rep_date, name)  
)
--drop TABLE Migr_RNCB_Indexes

DECLARE 	
	CURSOR q(dt DATE) is
	(
		SELECT t.dt,
				t.name,
				t.value
		FROM TEST_DATA t
		WHERE TRUNC(t.dt) = dt
	);
	qr q%rowtype;
	start_date DATE := to_date('01-07-2025', 'dd-mm-yyyy');
	curr_date DATE;
	i NUMBER :=0;
BEGIN
	sys.dbms_output.enable;
	sys.dbms_output.put_line('Started!');
	curr_date := start_date;
	while(curr_date <= trunc(sysdate))
	LOOP
		OPEN q(curr_date);
		LOOP
			FETCH q INTO qr;
			sys.dbms_output.put_line(qr.name);
			SELECT count(*) INTO i
			FROM Migr_RNCB_Indexes t
			WHERE t.rep_date = qr.dt
			  AND t.name = qr.name;
			IF i = 0 THEN
				INSERT INTO Migr_RNCB_Indexes VALUES qr;
			ELSE 
				UPDATE Migr_RNCB_Indexes m SET value = qr.value
				 WHERE m.rep_date = qr.dt
				   AND m.name = qr.name;
			END IF;
			EXIT WHEN q%notfound;
		END LOOP;	
		sys.dbms_output.put_line('Дата: ' || to_char(curr_date,'dd-mm-yyyy'));
		CLOSE q;
		curr_date := curr_date + 1;	
	END LOOP;
	sys.dbms_output.put_line('Finished!');
EXCEPTION 
	WHEN OTHERS THEN 
		sys.dbms_output.put_line(sqlerrm);
		sys.dbms_output.put_line(sqlcode);
END;

------------- test tables ----------------
CREATE TABLE Test_data
( 
	--id NUMBER PRIMARY KEY,
	dt DATE NOT NULL,
   	name varchar2(32) NOT NULL,
   	value number(15,6) NOT NULL
);
--drop table test_data
INSERT INTO TEST_DATA(dt,name,value)
SELECT * FROM (
SELECT TRUNC(sysdate) - 10, 't2', 2 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 5, 't1', 2 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 11, 'tes1', 32 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 10, 'fh1', 37 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 6, 't1', 1656 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 7, 't2', 21 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 4, 't1', 54 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 11, 'tgjhgj1', 12 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 10, 'kjhikjh', 2.22 FROM DUAL 
UNION all
SELECT TRUNC(sysdate) - 9, 't1', 27 FROM DUAL 
);

SELECT * FROM Test_data
ORDER BY 1,2

SELECT dt, NAME, sum(VALUE) value FROM Test_data
GROUP BY dt, NAME

SELECT * FROM Migr_RNCB_Indexes
ORDER BY 1,2

--SELECT TRUNC(sysdate) - 11 FROM DUAL 