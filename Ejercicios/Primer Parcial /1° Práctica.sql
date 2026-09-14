/* 1)Realice una consulta SQL que muestre el id de producto, descripción y cantidad de ordenes en las que fue vendido, 
para aquellos productos que estén en menos de 5 ordenes.
Ordenados por nombre de producto.*/
SELECT P.product_id, P.description, COUNT(I.order_id) AS CANT_ORDENES
FROM product P,
    item I
WHERE P.product_id = I.product_id
GROUP BY P.product_id, P.description
HAVING COUNT(I.order_id) < 5
ORDER BY P.description;

/* 2) Escribir una función que recibe como parámetro un nombre de producto y retorna su ID o cancela con excepciones 
propias indicando el error en el mensaje del error.
Contemplar todo error posible.*/
CREATE OR REPLACE FUNCTION F_PRODUCT 
(
  PI_DESCRIPTION IN PRODUCT.DESCRIPTION%TYPE 
) RETURN PRODUCT.PRODUCT_ID%TYPE IS
    v_id product.product_id%TYPE;
BEGIN
    SELECT product_id
    INTO v_id
    FROM product
    WHERE description = PI_DESCRIPTION;

    RETURN v_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: No existe un producto con el nombre '||pi_description);
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002,'ERROR: Existe más de un producto con el nombre '||pi_description);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003,'ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;

/* 3) Escribir un procedimiento que permite dar de alta un nuevo producto.
El procedimiento recibe como parámetro el nombre del producto y el nuevo id.
Validar que no haya en la base un producto con el mismo nombre utilizando la función anterior.
Manejar las excepciones correspondientes.
- Informar si pudo realizar su propósito correctamente
- Utilizar la función del punto anterior
- Si no se pudo realizar informar el motivo correcto. No Cancelar */

/* 4) Escribir un bloque anónimo que permita ingresar como variable de sustitución un código de producto y liste para este 
todo su historial de precios. Indicar el total de actualizaciones. Listar ordenados por fecha de vigencia
- SI el producto no existe informarlo

Producto: xxxxxxxxxxxxxx
Precio lista       Precio Min        F. Desde  F. Hasta
    99.99            99.99           dd/mm/yy  dd/mm/yy
    99.99            99.99           dd/mm/yy  dd/mm/yy
    99.99            99.99           dd/mm/yy  dd/mm/yy */
SET SERVEROUTPUT ON
DECLARE
    v_product_id product.product_id%TYPE;
    
    CURSOR c_product IS
        SELECT list_price, min_price, start_date, end_date
        FROM price
        WHERE product_id = v_product_id
        ORDER BY start_date;
        
    v_cont NUMBER := 0;
BEGIN
    v_product_id := &product_id;
    
    DBMS_OUTPUT.PUT_LINE('Producto: '||v_product_id);
    DBMS_OUTPUT.PUT_LINE('Precio lista       Precio Min        F. Desde    F. Hasta');
    FOR i IN c_product LOOP
        DBMS_OUTPUT.PUT_LINE(i.list_price||'                    '||i.min_price||'            '||NVL(TO_CHAR(i.start_date, 'dd/mm/yy'), '-')||'   '||NVL(TO_CHAR(i.end_date,'dd/mm/yy'), '-'));
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se encontró un producto con el ID '||v_product_id);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El valor ingresado como ID es incorrecto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INESPERADO ('||SQLCODE||'): '||SQLERRM);
END;
