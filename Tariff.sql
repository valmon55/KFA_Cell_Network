CREATE TABLE tariff_plan
(
	id NUMBER PRIMARY KEY,
	name varchar2(32) NOT NULL,
	price number(15,6) NOT NULL 
);

ALTER TABLE tariff_plan 
	ADD cell_number_id NUMBER;

ALTER TABLE tariff_plan
	 ADD CONSTRAINT fk_cell_number_t_plan FOREIGN KEY (cell_number_id) REFERENCES cell_number(id);

CREATE SEQUENCE tariff_plan_seq
	INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE TRIGGER tariff_plan_trg
	BEFORE INSERT ON tariff_plan
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT tariff_plan_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;

--DROP TABLE tariff_pack
CREATE TABLE tariff_pack
(
	id NUMBER PRIMARY KEY,
	tariff_plan_id NUMBER,
	name varchar2(32) NOT NULL,
	pack_type NUMBER NOT NULL, --своя/чужая сеть, роуминг и т.п. 
	period NUMBER, --срок действия 
	amount number(15,6) NOT NULL,
	price number(15,6) NOT NULL
	, CONSTRAINT fk_tariff_plan FOREIGN KEY (tariff_plan_id)  REFERENCES tariff_plan(id)
);

CREATE SEQUENCE tariff_pack_seq
	INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE TRIGGER tariff_pack_trg
	BEFORE INSERT ON tariff_pack
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT tariff_pack_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;
