
-- Трафик
--drop TABLE traffic
CREATE TABLE traffic
(
	id NUMBER PRIMARY KEY,
	traffic_type Varchar2(1), --
	oper_type_id NUMBER, --FOREIGN KEY fk_oper_type referencies
	oper_date DATE DEFAULT sysdate,
	amount NUMBER(10,6) DEFAULT 0 CHECK (amount >= 0) NOT NULL,  
	inc_number varchar2(15),
	--cell_number_id NUMBER FOREIGN KEY fk_cell_number referencies cell_number(id),
	--cell_network_id NUMBER, 
	--cell_number_id NUMBER FOREIGN KEY fk_cell_number referencies cell_number(id),
	--cell_network_id NUMBER,
	out_number varchar2(15)
	--,CONSTRAINT CHECK (amount >= 0)  
);

ALTER TABLE TRAFFIC DROP  COLUMN  traffic_type;

ALTER TABLE TRAFFIC 
	ADD CONSTRAINT fk_oper_type FOREIGN KEY (oper_type_id) REFERENCES oper_type(id);

ALTER TABLE TRAFFIC 
	MODIFY amount number(16,5)

/*ALTER TABLE TRAFFIC 
	--DROP CONSTRAINT fk_inc_number 
	ADD CONSTRAINT fk_inc_number FOREIGN KEY (inc_number) REFERENCES Cell_Number(Cell_Number);
ALTER TABLE TRAFFIC 
	--DROP CONSTRAINT fk_out_number 
	ADD CONSTRAINT fk_out_number FOREIGN KEY (out_number) REFERENCES Cell_Number(Cell_Number);
*/

SELECT * FROM TRAFFIC t 


CREATE SEQUENCE seq_traffic
	START WITH 1 INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER trg_traffic 
	BEFORE INSERT 
	ON traffic   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_traffic.nextval INTO :NEW.id FROM dual;
	END IF;
END;

-- справочинк типов операций
CREATE TABLE oper_type
(
	id NUMBER PRIMARY KEY,
	name varchar2(12) UNIQUE NOT NULL,
	decs varchar2(48)
);

ALTER TABLE oper_type
	ADD unit varchar2(10);

CREATE SEQUENCE seq_oper_type
	START WITH 1 INCREMENT BY 1; 

CREATE OR REPLACE TRIGGER trg_oper_type
	BEFORE INSERT 
	ON oper_type   
	FOR EACH ROW 	
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT seq_oper_type.nextval INTO :NEW.id FROM dual;
	END IF;
END;

SELECT  * FROM OPER_TYPE ot 

INSERT INTO oper_type(name)
SELECT 'SMS' FROM DUAL 
UNION ALL 
SELECT 'MMS' FROM DUAL 
UNION ALL 
SELECT 'Call' FROM DUAL 
UNION ALL 
SELECT 'Inet' FROM DUAL 

UPDATE oper_type
SET DECS = 'Measured in minutes'
WHERE name = 'Call';
COMMIT;

UPDATE oper_type
SET unit = 'Message'
WHERE name = 'MMS';
COMMIT;