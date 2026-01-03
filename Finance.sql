--drop TABLE balance
CREATE TABLE account
(
	id NUMBER PRIMARY KEY,
	cell_number_id NUMBER, 
	bal_amount NUMBER(15,6) DEFAULT 0 NOT NULL 
	,CONSTRAINT fk_cell_number_bal FOREIGN KEY (cell_number_id) REFERENCES cell_number(id)
)

--drop sequence balance_seq
CREATE SEQUENCE account_seq
	INCREMENT BY 1 START WITH 1;

--drop TRIGGER balance_trg
CREATE OR REPLACE TRIGGER account_trg
	BEFORE INSERT ON account
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT account_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;

CREATE TABLE fin_trans_type
(
	id NUMBER PRIMARY KEY,
	direction NUMBER(1) CHECK (direction IN (1, -1)),
	name varchar2(16)	
)

CREATE SEQUENCE fin_trans_type_seq
	INCREMENT BY 1 START WITH 1;

--drop TRIGGER balance_trg
CREATE OR REPLACE TRIGGER fin_trans_type_trg
	BEFORE INSERT ON fin_trans_type
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT fin_trans_type_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;

CREATE TABLE fin_trans
(
	id NUMBER PRIMARY KEY,
	account_id NUMBER, 
	trans_type_id NUMBER,
	trans_date DATE NOT NULL,
	amount NUMBER(15,6) DEFAULT 0 NOT NULL
	, CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES account(id)
	, CONSTRAINT fk_fin_trans_type FOREIGN KEY (trans_type_id) REFERENCES fin_trans_type(id)
);

CREATE SEQUENCE fin_trans_seq
	INCREMENT BY 1 START WITH 1;

--drop TRIGGER balance_trg
CREATE OR REPLACE TRIGGER fin_trans_trg
	BEFORE INSERT ON fin_trans
	FOR EACH ROW 
BEGIN 
	IF :NEW.id IS NULL THEN 
		SELECT fin_trans_seq.nextval INTO :NEW.id FROM dual;
	END IF;
END;

