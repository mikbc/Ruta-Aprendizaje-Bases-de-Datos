-- 8)
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_order_product IS
        SELECT SO.order_id, 
            SO.order_date, 
            I.product_id
        FROM sales_order SO, 
            item I
        WHERE SO.order_id = I.order_id
        ORDER BY SO.order_id;

BEGIN
    FOR i IN c_order_product LOOP
        dbms_output.put_line('ORDEN: '||i.order_id);
        dbms_output.put_line('- Fecha: '||i.order_date);
        dbms_output.put_line('- ID Producto: '||i.product_id);
        dbms_output.put_line('----------------------');
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;

-- 9)
SET SERVEROUTPUT ON
DECLARE
    v_customer customer.customer_id%TYPE;
    v_cont_order NUMBER := 0;
    
    CURSOR c_order IS 
        SELECT order_id, order_date
        FROM sales_order
        WHERE customer_id = v_customer;
    
    CURSOR c_product (p_order_id sales_order.order_id%TYPE) IS -- Cursor con parámetro 'p_'
        SELECT P.description
        FROM product P,
            item I
        WHERE (P.product_id = I.product_id) 
            AND (I.order_id = p_order_id); -- Igualar a parámetro
BEGIN
    v_customer := &customer_id;
    
    dbms_output.put_line('------ CLIENTE '||v_customer||' ------');
    FOR i IN c_order LOOP
        v_cont_order := v_cont_order +1;
        dbms_output.put_line('ORDEN: '||i.order_id);
        dbms_output.put_line('(Fecha: '||i.order_id||')');
        FOR j IN c_product(i.order_id) LOOP -- Le envío el parámetro con el valor correspondiente
            dbms_output.put_line('- Producto: '||j.description);
        END LOOP;
        dbms_output.put_line('-------------------');
    END LOOP;
    
    IF v_cont_order = 0 THEN
        dbms_output.put_line('Lo siento, no cuenta con órdenes emitidas.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('ERROR: No existe un cliente con el ID '||v_customer);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como ID de cliente es inválido.');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'):'||SQLERRM);
END;

-- 10)
SET SERVEROUTPUT ON
DECLARE
    v_department_id department.department_id%TYPE;
    v_count_department NUMBER := 0;
    
    CURSOR c_employee IS 
        SELECT salary, last_name, first_name
        FROM employee E,
            job J
        WHERE (department_id = v_department_id)
            AND (E.job_id = J.job_id) 
            AND (J.function = 'CLERK')
        ORDER BY last_name;
    
BEGIN
    v_department_id := &department_id;
    
    dbms_output.put_line('DEPARTAMENTO '||v_department_id);
    FOR i IN c_employee LOOP
        v_count_department := v_count_department +1;
        IF i.salary < 1000 THEN
            dbms_output.put_line('- '||i.last_name||', '||i.first_name||' candidato a un aumento');
        ELSIF i.salary >= 1000 THEN
            dbms_output.put_line('- '||i.last_name||', '||i.first_name||' no es candidato a un aumento.'); 
        END IF;
    END LOOP;
    
    IF v_count_department = 0 THEN
        dbms_output.put_line('El departamento '||v_department_id||' no tiene candidatos a aumento de salario.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('ERROR: No existe un departamento con el ID '||v_department_id);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('ERROR: El valor ingresado como ID de departamento es inválido.');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;

-- 11)
SET SERVEROUTPUT ON
DECLARE
   CURSOR c_product IS
    SELECT P.product_id, P.description, PR.list_price
    FROM product P,
        price PR
    WHERE P.product_id = PR.product_id
        AND PR.end_date IS NULL
    ORDER BY PR.list_price DESC;
    
    v_cont NUMBER := 0;
BEGIN
    dbms_output.put_line('TOP 5 PRODUCTOS MÁS CAROS');
    FOR i IN c_product LOOP
        EXIT WHEN v_cont = 5;
        v_cont := v_cont + 1;
        dbms_output.put_line(v_cont||'. PRODUCTO ('||i.product_id||'): '||i.description||' - $'||i.list_price);
    END LOOP;
END;

-- 12)
SET SERVEROUTPUT ON
DECLARE
    v_cont_employee NUMBER := 0;
    CURSOR c_department IS
        SELECT D.department_id, D.name, L.regional_group
        FROM department D,
            location L
        WHERE D.location_id = L.location_id
        ORDER BY D.department_id;
    
    CURSOR c_employee (p_department department.department_id%TYPE) IS -- Cursor con parámetro
        SELECT last_name, first_name, hire_date
        FROM employee
        WHERE department_id = p_department
        ORDER BY first_name;
BEGIN
    FOR i IN c_department LOOP
        dbms_output.put_line(i.department_id||' - '||i.name||' - '||i.regional_group);
        dbms_output.put_line('--------------------------');
        FOR j IN c_employee(i.department_id) LOOP
            v_cont_employee := v_cont_employee +1;
            dbms_output.put_line(j.last_name||','||j.first_name||' '||TO_CHAR(j.hire_date, 'DD-Mon-YYYY'));
        END LOOP;
        
        IF v_cont_employee = 0 THEN
            dbms_output.put_line('Este departamento aún no tiene empleados.');
        END IF;
        v_cont_employee := 0;
        
        dbms_output.put_line('');       
    END LOOP;
END;
