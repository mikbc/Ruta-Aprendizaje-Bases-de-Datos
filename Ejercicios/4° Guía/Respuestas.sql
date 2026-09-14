-- 1)
CREATE OR REPLACE PROCEDURE ALTA_JOB 
(
  P_FUNCTION IN JOB.FUNCTION%TYPE 
) AS 
    v_job_id job.job_id%TYPE;
    
BEGIN
    SELECT MAX(job_id) + 1
    INTO v_job_id
    FROM job;
    
    INSERT
    INTO job (job_id, function)
    VALUES (v_job_id, UPPER(P_FUNCTION));
    
    COMMIT;
    
    dbms_output.put_line('¡Se insertó el cargo '||UPPER(p_function)||' con éxito! (ID: '||v_job_id||').');
EXCEPTION
    -- No usamos la excepción DUP_VAL_ON_INDEX, porque al sumar 1 al id máximo, nunca se van a repetir las PK.
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||') :'||SQLERRM);
END ALTA_JOB;

-- 2)
CREATE OR REPLACE PROCEDURE UPD_JOB 
(
  PI_JOB_ID IN JOB.JOB_ID%TYPE
, PI_FUNCTION IN JOB.FUNCTION%TYPE 
) AS 
BEGIN
  UPDATE job
  SET function = UPPER(pi_function)
  WHERE job_id = pi_job_id;
  
  IF SQL%ROWCOUNT = 0 THEN
    ROLLBACK;
    dbms_output.put_line('No existe un JOB con el ID '||pi_job_id||', por lo que no se aplicó ninguna modificación.');
  ELSE
    dbms_output.put_line('Se modificó la función al JOB con ID '||pi_job_id||' a '||pi_function||' correctamente.');
    COMMIT;
  END IF;

EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END UPD_JOB;

-- 3)
CREATE OR REPLACE PROCEDURE LISTA_EMP 
(
  PI_DEPARTMENT_ID IN DEPARTMENT.DEPARTMENT_ID%TYPE 
) AS
    CURSOR c_employee IS
        SELECT first_name, last_name
        FROM employee
        WHERE department_id = pi_department_id;
    
    v_cont NUMBER := 0;
    v_existe NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_existe
    FROM department
    WHERE department_id = pi_department_id;
    
    IF v_existe = 0 THEN
        dbms_output.put_line('ERROR: No existe un departamento con ID '||pi_department_id);
    ELSE 
      dbms_output.put_line('DEPARTAMENTO '||pi_department_id);
      FOR i IN c_employee LOOP
        v_cont := v_cont + 1;
        dbms_output.put_line(v_cont||'. '||i.last_name||', '||i.first_name);
      END LOOP;
      
      IF v_cont = 0 THEN 
        dbms_output.put_line('Aún no tiene empleados.');
        END IF;
    END IF;
    
EXCEPTION 
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como ID de departamento es inválido.');
    WHEN OTHERS THEN 
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END LISTA_EMP;

-- 4)
-- 5)
-- 6)
-- 7)
-- 8)
