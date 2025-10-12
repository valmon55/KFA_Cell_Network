/* CLIENT */
CREATE TABLE Client
	(
		id NUMBER PRIMARY KEY, 
		first_name varchar2(16),
		last_name varchar2(16),
		middle_name varchar2(16),
		birhdate DATE DEFAULT to_date('01-01-1980', 'dd-mm-yyyy') NOT NULL,
		crdentials varchar2(128) UNIQUE --вероятно стоит здесь использовать вложенную таблицу
	 )

CREATE SEQUENCE seq_client
	START WITH 1 INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER trg_client
	BEFORE INSERT 
	ON client   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_client.nextval INTO :NEW.id FROM dual;
	END IF;
END;

/* CELL NUMBER*/
--DROP TABLE Cell_Number

CREATE TABLE Cell_Number
	(
		id NUMBER PRIMARY KEY, 
	 	Cell_number varchar2(12) UNIQUE	 	
	 )
ALTER TABLE Cell_Number  
	ADD client_id NUMBER
ALTER TABLE Cell_Number
	ADD CONSTRAINT fk_Client FOREIGN KEY (client_id) REFERENCES client(id)
	 
CREATE SEQUENCE seq_cell_number
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


/* SIM CARD */
--DROP TABLE Sim_card
CREATE TABLE Sim_card
	(
		id NUMBER PRIMARY KEY, 
		imei varchar2(36) UNIQUE, 
		start_date DATE,
		finish_date DATE,
		pin__code varchar2(6), 
		puck_code varchar2(6),
		status varchar2(1) DEFAULT 'N' NOT NULL,
		cell_number_id NUMBER,
		--client_id NUMBER, 
		CONSTRAINT fk_Cell_Number FOREIGN KEY (cell_number_id) REFERENCES cell_number(id)
	);

--ALTER TABLE SIM_CARD ADD status varchar2(1) DEFAULT 'N' NOT NULL; 
--ALTER TABLE SIM_CARD ADD start_date DATE; 
--ALTER TABLE SIM_CARD ADD finish_date DATE;

CREATE SEQUENCE seq_Sim_card
	START WITH 1 INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER trg_Sim_card 
	BEFORE INSERT 
	ON Sim_card   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_Sim_card.nextval INTO :NEW.id FROM dual;
	END IF;
END;


----------------------------------------------------------------
SELECT * FROM CELL_NUMBER cn 

TRUNCATE TABLE CELL_NUMBER

/* вставка из внешней таблицы */
INSERT INTO CELL_NUMBER(CELL_NUMBER) 
SELECT cellnumber FROM ext_Cell_Number
COMMIT;

	
SELECT * FROM SIM_CARD 	

--SELECT * FROM user_sys_privs;
SELECT * FROM user_tab_privs;

-----------------------------------------------------------------
/* External Table */
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