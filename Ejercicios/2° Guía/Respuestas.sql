-- 1)
V_var number(8,3); -- ✓ CORRECTA: Número de 8 dígitos totales. 3 de esos son decimales.
V_a, V-b number; -- X INCORRECTO: No se pueden declarar dos variables en una misma oración.
V_fec_ingreso Date := sysdate +2; -- ✓ CORRECTA: Suma 2 días a la fecha actual.
V_nombre varchar2(30) not null; /* X INCORRECTO: Hay que asignarle obligatoriamente un valor de inicialización. Ej:*/ V_nombre VARCHAR2(30) NOT NULL := 'SIN ASIGNAR';
V_logico boolean default ‘TRUE’; -- X INCORRECTO: Está mal el tipo de dato, ya que no se le puede asignar un texto a un boolean. Sería un VARCHAR2.

-- 2)
SET SERVEROUTPUT ON
DECLARE
    v_username VARCHAR2(10);
    v_date DATE := SYSDATE;
BEGIN
    v_username := '&username'; -- Va con comillas simples '&username' porque es un string. 
    dbms_output.put_line('Hola, soy '||v_username);
    dbms_output.put_line('Hoy es: '||v_date);
END;

-- 3)
SET SERVEROUTPUT ON
DECLARE
    v_employee_id employee.employee_id%type;
    v_first_name employee.first_name%type;
    v_last_name employee.first_name%type;
    v_salary employee.salary%type;
BEGIN
    v_employee_id := &id_empleado;   
    SELECT first_name, 
            last_name, 
            salary
    INTO v_first_name,
        v_last_name,
        v_salary
    FROM employee
    WHERE (employee_id = v_employee_id);    
    dbms_output.put_line(v_first_name||', '||v_last_name||' tiene un salario de $'||v_salary||' pesos.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe un empleado con el ID: '||v_employee_id||'.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'): '||SQLERRM);
END;

-- 4)
SET SERVEROUTPUT ON
DECLARE
    v_order_id sales_order.order_id%type;
    v_order sales_order%rowtype;
BEGIN
    v_order_id := &nro_orden;
    SELECT *
    INTO v_order
    FROM sales_order
    WHERE order_id = v_order_id;
    
    dbms_output.put_line('DATOS DE LA ORDEN N° '||v_order.order_id);
    dbms_output.put_line('- Fecha de compra: '||v_order.order_date);
    dbms_output.put_line('- ID del cliente: '||v_order.customer_id);
    dbms_output.put_line('- Fecha de envío: '||NVL(TO_CHAR(v_order.ship_date),'Sin enviar')); -- ¡OJO! Recordar usar NVL para fechas
    dbms_output.put_line('- Total: $'||v_order.total);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe una orden de compra con el ID '||v_order_id);
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'):'||SQLERRM);
END;

-- 5)
SET SERVEROUTPUT ON
DECLARE
    v_customer_id customer.customer_id%type;
    v_name customer.name%type;
    v_orders_count NUMBER;
BEGIN
    v_customer_id := &id_cliente;
    
    SELECT COUNT(*), C.name 
    INTO v_orders_count,
        v_name
    FROM sales_order S,
        customer C
    WHERE (S.customer_id = v_customer_id)
        AND (S.customer_id = C.customer_id)
    GROUP BY C.name;
        
    IF v_orders_count <= 3 THEN
        dbms_output.put_line('El cliente '||v_name||' ES REGULAR.');
    ELSIF (v_orders_count >= 4) AND (v_orders_count <= 6) THEN
        dbms_output.put_line('El cliente '||v_name||' ES BUENO.');
    ELSIF v_orders_count > 6 THEN
        dbms_output.put_line('El cliente '||v_name||' ES MUY BUENO.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN  
        dbms_output.put_line('No existe un cliente con el ID '||v_customer_id);
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'): '||SQLERRM);
END;

-- 6)
SET SERVEROUTPUT ON
DECLARE
    v_department_id department.department_id%type;
    v_name department.name%type;
    v_count_employee NUMBER := 0;
BEGIN
    v_department_id := &department_id;
    
    SELECT D.name, COUNT(E.employee_id)
    INTO v_name, v_count_employee
    FROM department D,
        employee E
    WHERE (D.department_id = v_department_id) 
        AND (D.department_id = E.department_id)
    GROUP BY D.name;
    
    IF v_count_employee = 0 THEN
        dbms_output.put_line('Departamento: '||v_name||' | Sin empleados');
    ELSIF v_count_employee >= 1 AND v_count_employee <= 10 THEN
        dbms_output.put_line('Departamento: '||v_name||' | Cantidad de empleados: '||v_count_employee||' (Normal)');
    ELSIF v_count_employee > 10 THEN 
        dbms_output.put_line('Departamento: '||v_name||' | Cantidad de empleados: '||v_count_employee||' (Muchos)');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe un departamento con ID '||v_department_id);
    WHEN OTHERS THEN
        dbms_output.put_line('Error inexplicable ('||SQLCODE||'): '||SQLERRM);
END;

-- 7)
SET SERVEROUTPUT ON
DECLARE
    v_product_id product.product_id%type;
    v_name product.description%type;
    v_count_sales NUMBER;    
BEGIN
    v_product_id := &product_id;
    
    SELECT P.description, COUNT(I.order_id)
    INTO v_name, v_count_sales
    FROM product P,
        item I
    WHERE (P.product_id = I.product_id)
        AND (P.product_id = v_product_id)
    GROUP BY P.description;
    
    IF v_count_sales IS NOT NULL THEN
        dbms_output.put_line('El producto '||v_name||' se vendió '||v_count_sales||' veces.');
    ELSE
        dbms_output.put_line('El producto '||v_name||' no se vendió.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No se encontró producto con ID '||v_product_id);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('El tipo o tamaño del dato ingresado como código de producto no es válido.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'): '||SQLERRM);
END;

-- 8)
SET SERVEROUTPUT ON
DECLARE
    v_employee_id employee.employee_id%type;
    
    TYPE tr_emp IS RECORD ( -- 1) Defino la "forma" (el molde)
        emp_employee_id employee.employee_id%type,
        emp_employee_name employee.first_name%type,
        emp_manager_id employee.manager_id%type,
        emp_manager_name employee.first_name%type);
    
    r_emp tr_emp; -- 2) Declaro una variable con esa forma
BEGIN
    v_employee_id := &employee_id;
    
    SELECT E.employee_id, E.first_name, E.manager_id, M.first_name
    INTO r_emp.emp_employee_id, r_emp.emp_employee_name , r_emp.emp_manager_id, r_emp.emp_manager_name -- 3) Cargo los datos en la variable r_emp que tiene el formato de tr_emp
    FROM employee E,
        employee M
    WHERE (E.manager_id = M.employee_id)
        AND (E.employee_id = v_employee_id);
    
    dbms_output.put_line('Empleado '||r_emp.emp_employee_name||' (ID '||r_emp.emp_employee_id||').');
    IF r_emp.emp_manager_id IS NOT NULL THEN
        dbms_output.put_line('- Su jefe es: '||r_emp.emp_manager_name||' (ID '||r_emp.emp_manager_id||').');
    ELSE
        dbms_output.put_line('No tiene jefe.');
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No se encontró un empleado con el ID '||v_employee_id);
    WHEN VALUE_ERROR THEN 
        dbms_output.put_line('El tipo o tamaño del dato ingresado como código de producto no es válido.');
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'): '||SQLERRM);
END;

-- 9)
SET SERVEROUTPUT ON
DECLARE
    v_employee_id employee.employee_id%type;
    v_first_name employee.first_name%type;
    v_last_name employee.last_name%type;
    v_salary employee.salary%type;
    v_cont NUMBER;
    v_asterisco VARCHAR2(100) := ''; -- SIEMPRE HAY QUE INICIALIZARLO, sino queda en NULL y no podemos agregarle asteriscos (*)
BEGIN
    v_employee_id := &employee_id;
    
    SELECT first_name, last_name, salary
    INTO v_first_name, v_last_name, v_salary
    FROM employee
    WHERE employee_id = v_employee_id;
    
    v_cont := TRUNC(v_salary / 100); -- Ej. Si gana $950 / 100 = 9 -> Debe imprimir 9 asteriscos (*)
    
    FOR i IN 1..v_cont LOOP -- Repite desde uno a v_cont = 9 veces
        v_asterisco := v_asterisco || '*'; -- 1.*, 2.**, 3.***, ..., 9.*********
    END LOOP;
    
    dbms_output.put_line('Empleado '||v_last_name||', '||v_first_name||' ('||v_employee_id||')');
    dbms_output.put_line('Gana $'||v_salary||': '||v_asterisco);
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        dbms_output.put_line('No se encontró un empleado con el ID '||v_employee_id);
    WHEN VALUE_ERROR THEN
        dbms_output.put_line('El valor ingresado como id de empleado es inválido.');    
    WHEN OTHERS THEN
        dbms_output.put_line('Error inesperado ('||SQLCODE||'): '||SQLERRM);
END;

-- 10)
SET SERVEROUTPUT ON
DECLARE
    v_num NUMBER(10);
    
BEGIN
    v_num := &numero;
    
    IF v_num > 10 THEN
        dbms_output.put_line('ADVERTENCIA: Ingresaste un número mayor a 10.');
    ELSIF v_num <= 0 THEN
        dbms_output.put_line('ADVERTENCIA: Debe ingresar un número positivo mayor a 0.');
    ELSIF v_num <= 10 THEN
        dbms_output.put_line('Los primeros '||v_num||' números múltiplos de 3 son...');
        FOR i IN 1..v_num LOOP
            dbms_output.put_line('3 x '||i||' = '||i*3);
        END LOOP;
    END IF;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('El valor ingresado no es un número válido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado (' || SQLCODE || '): ' || SQLERRM);
END;
