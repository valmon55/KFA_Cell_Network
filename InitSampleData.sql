BEGIN 
	FOR i IN 1..1000
	LOOP 
		INSERT INTO TRAFFIC(OPER_TYPE_ID, OPER_DATE, AMOUNT, INC_NUMBER, OUT_NUMBER) 
		SELECT 
			t.id,
			SYSDATE - DBMS_RANDOM.VALUE(0, 365*5) oper_date,
			CASE WHEN t.name = 'Call' THEN ROUND(DBMS_RANDOM.VALUE(0, 60),5) -- до 60 мин
				 WHEN t.name = 'Inet' THEN ROUND(DBMS_RANDOM.VALUE(0, 1024*20),5) --до 20 Мб
				 ELSE 1
			END amount,
			'+79' || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 999999999)),9,'0') inc_cell_number,
			'+79' || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 999999999)),9,'0') out_cell_number
		FROM --DUAL
			(
				SELECT id, name FROM (
					SELECT id, name  FROM OPER_TYPE
					ORDER BY dbms_random.value
				) t
				WHERE rownum = 1
			) t /* эта таблица должна содержать только 1 строку, аналогично DUAL */
		CONNECT BY LEVEL <= 1000;
		COMMIT;
	END LOOP;
END; 
	
SELECT * 
FROM TRAFFIC t,
	 OPER_TYPE ot 
WHERE t.OPER_TYPE_ID = ot.ID 
ORDER BY OPER_DATE ;


/*SELECT * FROM (
SELECT * FROM OPER_TYPE ot 
ORDER BY dbms_random.value
)
WHERE rownum = 1*/
	


