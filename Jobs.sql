-- Create a simple PL/SQL job
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'INC_TRAFFIC',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN
							FOR i IN 1..16
							LOOP 
								INSERT INTO TRAFFIC(OPER_TYPE_ID, OPER_DATE, AMOUNT, INC_NUMBER, OUT_NUMBER) 
								SELECT 
									t.id,
									SYSDATE oper_date,
									CASE WHEN t.name = ''Call'' THEN ROUND(DBMS_RANDOM.VALUE(0, 60),5) -- до 60 мин
										 WHEN t.name = ''Inet'' THEN ROUND(DBMS_RANDOM.VALUE(0, 1024*20),5) --до 20 Мб
										 ELSE 1
									END amount,
									''+79'' || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 999999999)),9,''0'') inc_cell_number,
									''+79'' || LPAD(FLOOR(DBMS_RANDOM.VALUE(0, 999999999)),9,''0'') out_cell_number
								FROM --DUAL
									(
										SELECT id, name FROM (
											SELECT id, name  FROM OPER_TYPE
											ORDER BY dbms_random.value
										) t
										WHERE rownum = 1
									) t /* эта таблица должна содержать только 1 строку, аналогично DUAL */
								;
								COMMIT;
							END LOOP;
                       END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=3',
    auto_drop       => FALSE,
    enabled         => TRUE,
    comments        => 'Incoming Traffic'
  );
END;

--BEGIN DBMS_SCHEDULER.DROP_JOB('INC_TRAFFIC'); END;

BEGIN DBMS_SCHEDULER.SET_ATTRIBUTE('INC_TRAFFIC', 'REPEAT_INTERVAL', 'FREQ=MINUTELY; INTERVAL=3'); END;

BEGIN 
	dbms_scheduler.enable('INC_TRAFFIC');
END;

-- Check job status
SELECT job_name, state, last_start_date, next_run_date
FROM dba_scheduler_jobs
WHERE job_name = 'INC_TRAFFIC';

SELECT T.OPER_DATE,
	   T.AMOUNT,
	   OT.NAME,
	   OT.DECS,
	   T.INC_NUMBER ,
	   T.OUT_NUMBER 
FROM TRAFFIC t,
	 OPER_TYPE ot 
WHERE t.OPER_TYPE_ID = ot.ID 
  AND T.OPER_DATE >= TRUNC(SYSDATE) 
ORDER BY OPER_DATE DESC ;