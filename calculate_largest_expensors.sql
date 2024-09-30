WITH empdetails AS (
    SELECT 
        e.employee_id, 
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
        m.employee_id AS manager_id, 
        CONCAT(m.first_name, ' ', m.last_name) AS manager_name
    FROM employee e
    INNER JOIN employee m ON m.employee_id = e.manager_id
)
SELECT 
    ed.employee_id,
    ed.employee_name,
    ed.manager_id,
    ed.manager_name,
    SUM(e.unit_price * e.quantity) AS total_expensed_amount
FROM empdetails ed
INNER JOIN expense e ON ed.employee_id = e.employee_id
GROUP BY 
    ed.employee_id,
    ed.employee_name,
    ed.manager_id,
    ed.manager_name
HAVING SUM(e.unit_price * e.quantity) > 1000
ORDER BY total_expensed_amount DESC;
