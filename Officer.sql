/* привилегии пользователя системы */
CREATE TABLE Officer_Priv
(
	id NUMBER PRIMARY KEY,
	name varchar2(24) UNIQUE NOT NULL,
	description varchar2(128)
);

CREATE SEQUENCE seq_officer_priv
	START WITH 1 INCREMENT BY 1;
	
CREATE OR REPLACE TRIGGER  trg_officer_priv
	BEFORE INSERT 
	ON Officer_Priv   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_officer_priv.nextval INTO :NEW.id FROM dual;
	END IF;
END;

/* пользователи системы */
CREATE TABLE Officer
(
	id NUMBER PRIMARY KEY,
	first_name varchar2(16),
	last_name varchar2(16),
	middle_name varchar2(16),
	birhdate DATE DEFAULT to_date('01-01-1980', 'dd-mm-yyyy') NOT NULL,
	employee_number varchar2(128) UNIQUE,
	officer_priv_id NUMBER, 
	CONSTRAINT fk_Officer_Priv FOREIGN KEY (Officer_Priv_id) REFERENCES Officer_Priv(id) 
);

--DROP TABLE officer;

CREATE SEQUENCE seq_officer
	START WITH 1 INCREMENT BY 1;
	
CREATE OR REPLACE TRIGGER  trg_officer
	BEFORE INSERT 
	ON Officer
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_officer.nextval INTO :NEW.id FROM dual;
	END IF;
END;