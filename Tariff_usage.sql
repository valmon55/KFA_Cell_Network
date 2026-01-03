CREATE TABLE tariff_plan_usage
(
	id NUMBER PRIMARY KEY,
	tariff_plan_id NUMBER, 
	start_date DATE NOT NULL,
	finish_date DATE,
	CONSTRAINT fk_tariff_plan_usg FOREIGN KEY (tariff_plan_id) REFERENCES tariff_plan(id)
)

CREATE SEQUENCE tariff_plan_usage_seq
	INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE TRIGGER tariff_plan_usage_trg
	BEFORE INSERT ON tariff_plan_usage
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT tariff_plan_usage_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;

--DROP TABLE tariff_pack_rest
CREATE TABLE tariff_pack_rest
(
	id NUMBER PRIMARY KEY,
	tariff_pack_id NUMBER,
	start_date DATE NOT NULL,
	finish_date DATE,
	amount number(15,6) NOT NULL
	, CONSTRAINT fk_tariff_pack_rest FOREIGN KEY (tariff_pack_id)  REFERENCES tariff_pack(id)
);

CREATE SEQUENCE tariff_pack_rest_seq
	INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE TRIGGER tariff_pack_rest_trg
	BEFORE INSERT ON tariff_pack_rest
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT tariff_pack_rest_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;
