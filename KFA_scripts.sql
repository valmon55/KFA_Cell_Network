CREATE TABLE Cell_Number
	(id NUMBER PRIMARY KEY, Cell_number varchar2(12))

ALTER TABLE CELL_NUMBER ADD CONSTRAINT constr_cell_number UNIQUE (cell_number);  

ALTER TABLE CELL_NUMBER ADD sim_card_id NUMBER --

ALTER TABLE CELL_NUMBER ADD CONSTRAINT fk_sim_card_id FOREIGN KEY (sim_card_id) REFERENCES sim_card(id);

--ALTER TABLE CELL_NUMBER DROP CONSTRAINT fk_sim_card_id
--ALTER TABLE CELL_NUMBER DROP CONSTRAINT constr_cell_number 

CREATE SEQUENCE KFA.seq_cell_number
	START WITH 1 INCREMENT BY 1; 
	
CREATE OR REPLACE TRIGGER trg_cell_number 
	BEFORE INSERT 
	ON cell_number   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_cell_number.nextval INTO :NEW.id FROM dual;
	END IF;
END;

SELECT * FROM CELL_NUMBER cn 

TRUNCATE TABLE CELL_NUMBER
--ROLLBACK;

INSERT INTO CELL_NUMBER(CELL_NUMBER) 
SELECT cellnumber FROM ext_Cell_Number
COMMIT;

CREATE TABLE Sim_card
	(id NUMBER PRIMARY KEY, imei varchar2(36), pin__code varchar2(6), puck_code varchar2(6))
	
--DROP TABLE sim_card
SELECT * FROM SIM_CARD 	

SELECT * FROM user_sys_privs

SELECT * FROM user_tab_privs

SELECT * FROM session_privs;
SELECT * FROM user_sys_privs;
SELECT * FROM user_role_privs;

SELECT * FROM ext_Cell_Number

GRANT SELECT ON ext_Cell_Number TO KFA;

DROP TABLE ext_Cell_Number

CREATE TABLE ext_Cell_Number
(
CellNumber VARCHAR2(12)
)
ORGANIZATION EXTERNAL (
	TYPE ORACLE_LOADER
	DEFAULT DIRECTORY InputDir
	ACCESS PARAMETERS (
		RECORDS DELIMITED BY NEWLINE
		BADFILE InputDir: 'ext_Cell_Number.bad'
		LOGFILE InputDir: 'ext_Cell_Number.log'
		DISCARDFILE InputDir: 'ext_Cell_Number.dis'
		--SKIP 1
		FIELDS TERMINATED BY ','
		Missing field VALUES ARE NULL 
		(
			CellNumber CHAR(12)
		)
	)
	LOCATION ('CellNumbers.csv')
)
REJECT LIMIT UNLIMITED;