-- 1)
INSERT INTO employee (employee_id, last_name, first_name, middle_initial, job_id, manager_id, hire_date, salary, commission, department_id)
VALUES (    7955, 'BELL', 'MICAELA', 'B', 670, 7839, TO_DATE('06/09/2004', 'DD/MM/YYYY'), 5000, 1000, 12);

-- 2)
COMMIT;

-- 3)
DELETE FROM employee 
WHERE (employee_id = 7955);

-- 4)
ROLLBACK;

-- 5)
SELECT *
FROM job;

-- 6)
UPDATE customer
SET name = 'JOCKSPORTS ¡modificado!'
WHERE customer_id = 100;

-- 7)
SAVEPOINT a;

-- 8)
UPDATE customer
SET name = 'TKB SPORT SHOP ¡modificado!'
WHERE customer_id = 101;

-- 9)
SAVEPOINT b;

-- 10)
ROLLBACK TO SAVEPOINT b;

-- 11)
SELECT *
FROM customer;

-- 12) Se debe hacer un:
ROLLBACK TO SAVEPOINT a -- Deshacemos lo que ocurrió luego del savepoint a
COMMIT; -- Guardamos en la BD 
-- Igualmente hay que tener en cuenta que de esta forma se pierde la modificación realizada y guardada por el:
SAVEPOINT b;

-- 13) No, no se puede hacer un:
DELETE FROM department
WHERE department_id = 10;
-- Porque es una Foregin Key, por lo que ya tiene muchas dependencias con otras tablas. Sería una mala práctica eliminar por cascada.

-- 14) Esto falla, porque la tabla LOCATION no tiene ninguna fila con LOCATION_ID = 100. 
-- Se exige que todo LOCATION_ID en DEPARTMENT exista previamente en LOCATION.
INSERT INTO department (department_id, name, location_id)
VALUES (50, 'EDUCATION', 100); -- Para que funcione, habría que insertar antes la localidad 100 en la tabla LOCATION.

-- 15) No, no te permite hacer: 
INSERT INTO department (department_id, name)
VALUES (43, 'OPERATIONS'); -- Porque ya existe un department_id = 43 con nombre 'SALES' y no se pueden repetir la clave primaria FK. 

-- 16)
-- 17)
-- 18)
-- 19)
-- 20)
