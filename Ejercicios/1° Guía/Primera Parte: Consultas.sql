-- 2)
SELECT function
FROM job;

-- 3)
SELECT last_name||', '||first_name 
        AS full_name
FROM employee
ORDER BY last_name;

-- 4)
SELECT (first_name||' '||last_name) 
        AS full_name
FROM employee
WHERE salary>1500 AND salary<2850;

-- 5)
SELECT first_name,
    hire_date
FROM employee
WHERE (hire_date >= TO_DATE('01012006', 'DDMMYYYY'))
    AND (hire_date <= TO_DATE('31122006', 'DDMMYYYY'));

-- 6)
SELECT department_id,
    name
FROM department
WHERE location_id = 122;

-- 7)
SELECT department_id,
    name
FROM department
WHERE location_id = &location_id;

-- 8)
SELECT first_name,
    salary
FROM employee
WHERE manager_id IS NULL;

-- 9)
SELECT first_name, 
    NVL(TO_CHAR(commission), 'Sin comisión') commission
FROM employee;

-- 10)
SELECT (E.first_name||' '||E.last_name) AS full_name,
    E.department_id,
    D.name
FROM employee E,
    department D
WHERE E.department_id = D.department_id;

-- 11)
SELECT (E.first_name||' '||E.last_name) AS employee_full_name, 
    J.function,
    D.name AS department_name,
    E.salary
FROM employee E,
    job J,
    department D
WHERE (E.job_id = J.job_id) AND
    (E.department_id = D.department_id)
ORDER BY E.last_name ASC;

-- 12)
SELECT E.first_name,
    D.name AS department,
    L.regional_group AS location
FROM employee E,
    department D,
    location L
WHERE (E.department_id = D.department_id)
    AND (D.location_id = L.location_id)
    AND (E.commission IS NOT NULL);

-- 13)
SELECT E.employee_id,
    E.last_name,
    E.salary,
    S.grade_id
FROM employee E,
    salary_grade S
WHERE (E.salary >= S.lower_bound)
    OR (E.salary <= S.upper_bound);

-- 14)
SELECT E.employee_id AS employee_id,
    (E.first_name||' '||E.last_name) AS employee_name,
    M.employee_id AS boss_id,
    (M.first_name||' '||M.last_name) AS boss_name
FROM employee E,
    employee M
WHERE E.manager_id = M.employee_id;

-- 15) ??

-- 16)
SELECT O.order_id,
    C.name AS cliente,
    P.description AS product_description
FROM sales_order O,
    customer C,
    item I,
    product P
WHERE (O.customer_id = C.customer_id)
    AND (O.order_id = I.order_id)
    AND (I.product_id = P.product_id)
ORDER BY O.order_id ASC;

-- 17)
SELECT COUNT(employee_id)
FROM employee;

-- 18)
SELECT COUNT(customer_id)
FROM customer
WHERE state = 'NY';

-- 19)
SELECT COUNT(DISTINCT(M.employee_id)) 
    AS JEFES
FROM employee E,
    employee M
WHERE(E.manager_id = M.employee_id);

-- 20)
SELECT (E.last_name||', '||E.first_name) AS full_name, 
    E.salary,
    D.name AS department
FROM employee E,
    department D
WHERE (E.department_id = D.department_id)
    AND job_id = (SELECT job_id
                FROM employee
                WHERE (first_name = 'JOHN')
                    AND (last_name = 'SMITH'))
ORDER BY E.salary, E.last_name;

-- 21)
SELECT (E.last_name||', '||E.first_name) AS full_name,
    D.name AS department,
    E.salary
FROM employee E,
    department D
WHERE (E.department_id = D.department_id) 
    AND E.salary > (SELECT AVG(salary)
                    FROM employee);

-- 22)
-- 23)
-- 24)
-- 25)
-- 26)
-- 27)
-- 28)
-- 29)
-- 30)
-- 31)
-- 32)
-- 33)
-- 34)
-- 35)
