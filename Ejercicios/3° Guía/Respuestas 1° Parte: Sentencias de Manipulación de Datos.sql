-- 1)
SET SERVEROUTPUT ON
DECLARE
    v_employee_id employee.employee_id%type;
    v_salary employee.salary%type;
    v_commission employee.commission%type;
BEGIN
    v_employee_id := &employee_id;
    
    SELECT salary, commission
    INTO v_salary, v_commission
    FROM employee
    WHERE employee_id = v_employee_id;
    
    dbms_output.put_line('EMPLEADO '||v_employee_id);
    dbms_output.put_line('| Salario: $'||v_salary);
    dbms_output.put_line('| Comisión: '||NVL(TO_CHAR(v_commission),'No cuenta con comisión'));

    IF v_commission IS NULL OR v_commission = 0 THEN
        dbms_output.put_line('Lo siento, como el empleado no cuenta con comisión, no se puede aplicar el incremento.');
    ELSIF v_salary < 1300 THEN
        UPDATE employee
        SET commission = commission*1.10
        WHERE employee_id = v_employee_id;
        v_commission := v_commission * 1.10;
        COMMIT; -- ¡Recordar hacer COMMIT;!
        dbms_output.put_line('¡Se aplicó un incremento del 10% a su comisión!');
        dbms_output.put_line('- Comisión actualizada: $'||v_commission||'. -');
    ELSIF v_salary >= 1300 AND v_salary <=1500 THEN
        UPDATE employee
        SET commission = commission*1.15
        WHERE employee_id = v_employee_id;
        v_commission := v_commission * 1.15;
        COMMIT; -- ¡Recordar hacer COMMIT;!
        dbms_output.put_line('¡Se aplicó un incremento del 15% a su comisión!');
        dbms_output.put_line('- Comisión actualizada: $'||v_commission||'. -');
    ELSIF v_salary > 1500 THEN
        UPDATE employee
        SET commission = commission*1.20
        WHERE employee_id = v_employee_id;
        v_commission := v_commission * 1.20;
        COMMIT; -- ¡Recordar hacer COMMIT;!
        dbms_output.put_line('¡Se aplicó un incremento del 20% a su comisión!');
        dbms_output.put_line('- Comisión actualizada: $'||v_commission||'. -');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe el empleado con el ID '||v_employee_id);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('El valor ingresado para el id del empleado es inválido');
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado: '||SQLCODE||': '||SQLERRM);
END;

-- 2)
-- 3)
-- 4)
-- 5)
-- 6)
-- 7)
