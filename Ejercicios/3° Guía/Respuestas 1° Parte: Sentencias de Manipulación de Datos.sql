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
SET SERVEROUTPUT ON
DECLARE
    v_bajo NUMBER := 0;
    v_medio NUMBER := 0;
    v_alto NUMBER := 0;
    
BEGIN
    -- Si el sueldo es menor a 1300 el incremento es de 10%
    UPDATE employee
    SET commission = commission * 1.10
    WHERE (salary < 1300) 
        AND (commission != 0) 
        AND (commission IS NOT NULL);
    
    v_bajo := SQL%ROWCOUNT; 
    
    -- Si el sueldo está entre 1300 y 1500 el incremento es de 15%
    UPDATE employee
    SET commission = commission * 1.15
    WHERE (salary >= 1300 AND salary <= 1500) 
        AND (commission != 0) 
        AND (commission IS NOT NULL);
            
    v_medio := SQL%ROWCOUNT;
    
    -- Si el sueldo es mayor a 1500 el incremento es de 20%
    UPDATE employee
    SET commission = commission * 1.20
    WHERE (salary > 1500)
        AND (commission != 0) 
        AND (commission IS NOT NULL);
            
    v_alto := SQL%ROWCOUNT;
    
    COMMIT;
    
    IF v_bajo = 0 THEN
        dbms_output.put_line('NO HAY empleados con salarios < 1300.');
    ELSE 
        dbms_output.put_line('- Empleados con salarios < 1300 actualizados (10%): '||v_bajo);
    END IF;
    
    IF v_medio = 0 THEN
        dbms_output.put_line('NO HAY empleados con salarios entre 1300 y 1500.');
    ELSE 
        dbms_output.put_line('- Empleados con salarios entre 1300 y 1500 actualizados (15%): '||v_medio);
    END IF;
    
    IF v_alto = 0 THEN
        dbms_output.put_line('NO HAY empleados con salarios > 1500.');
    ELSE 
        dbms_output.put_line('- Empleados con salarios > 1500 actualizados (20%): '||v_alto);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado: '||SQLCODE||': '||SQLERRM);
END;

-- 3)
SET SERVEROUTPUT ON
DECLARE
    v_job job.job_id%TYPE;
    
    e_fk EXCEPTION;
    PRAGMA exception_init(e_fk, -2292);

BEGIN
    v_job := &job_id;
    
    DELETE
    FROM job
    WHERE job_id = v_job;
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe un cargo con el ID ' || v_job || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cargo ' || v_job || ' eliminado correctamente.');
        COMMIT;
    END IF;

EXCEPTION
    WHEN e_fk THEN
        ROLLBACK;
        dbms_output.put_line('ERROR: No se puede eliminar un cargo que está asignado a empleados.');
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como ID es inválido');
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;

-- 4)
SET SERVEROUTPUT ON
DECLARE
    v_job_id job.job_id%TYPE;
    v_function job.function%TYPE;
    
BEGIN
    SELECT MAX(job_id) + 1
    INTO v_job_id
    FROM job;
    
    v_function := UPPER('&function');
    
    INSERT
    INTO job (
        job_id,
        function)
    VALUES (v_job_id,
            v_function);
    COMMIT;

    dbms_output.put_line('Cargo insertado correctamente:');
    dbms_output.put_line('- Job_Id: ' || v_job_id);
    dbms_output.put_line('- Function: ' || v_function);
    
EXCEPTION -- No usamos DUP_VAL_ON_INDEX porque al siempre hacer MAX(job_id)+1, nunca se va a poder duplicar.
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como FUNCTION es inválido');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;
/* Corroboro haciendo: */ SELECT * FROM job;

-- 5)
SET SERVEROUTPUT ON
DECLARE
    v_product_id product.product_id%TYPE;
    v_cont_ventas NUMBER := 0;
    v_price price.list_price%TYPE;
    
BEGIN
    v_product_id := &product_id;
    
    SELECT COUNT(*)
    INTO v_cont_ventas
    FROM item
    WHERE product_id = v_product_id;

    IF v_cont_ventas = 0 THEN
        UPDATE price
        SET list_price = list_price*0.50
        WHERE product_id = v_product_id
            AND end_date IS NULL;
    ELSIF v_cont_ventas <= 2 THEN
        UPDATE price
        SET list_price = list_price*0.90
        WHERE product_id = v_product_id
            AND end_date IS NULL;
    ELSE
        UPDATE price
        SET list_price = list_price*0.80
        WHERE product_id = v_product_id
            AND end_date IS NULL;
    END IF;
    
    COMMIT;
    
    SELECT list_price
    INTO v_price
    FROM price
    WHERE product_id = v_product_id
    AND end_date IS NULL;
    
    dbms_output.put_line('ID PRODUCTO: '||v_product_id);
    IF v_cont_ventas = 0 THEN
        dbms_output.put_line('Nunca se vendió, por lo que su precio disminuye un 50%.');
        dbms_output.put_line('- Precio actualizado: '||v_price);
    ELSIF v_cont_ventas <= 2 THEN
        dbms_output.put_line('- Cantidad de ventas: '||v_cont_ventas||' (2 o menos veces)');
        dbms_output.put_line('- Precio actualizado: '||v_price||' (Disminuyó 10%)');
    ELSE
        dbms_output.put_line('- Cantidad de ventas: '||v_cont_ventas||' (Más de 2 veces)');
        dbms_output.put_line('- Precio actualizado: '||v_price||' (Disminuyó 20%)');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('ERROR: No se encontró un producto con el ID '||v_product_id);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como ID del producto es incorrecto.');
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;

-- 6)


-- 7)


