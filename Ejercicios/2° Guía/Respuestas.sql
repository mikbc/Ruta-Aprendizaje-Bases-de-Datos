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


-- 7)
-- 8)
-- 9)
-- 10)
