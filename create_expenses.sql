CREATE TABLE expense (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);


INSERT INTO expense (employee_id, unit_price, quantity)
SELECT
    e.employee_id,         
    ed.unit_price,
    ed.quantity
FROM
(
    -- Subquery that holds raw data
    SELECT 'Alex Jacobson' AS employee_name, 6.50 AS unit_price, 14 AS quantity UNION ALL
    SELECT 'Alex Jacobson', 11.00, 20 UNION ALL
    SELECT 'Alex Jacobson', 22.00, 18 UNION ALL
    SELECT 'Alex Jacobson', 13.00, 75 UNION ALL
    SELECT 'Andrea Ghibaudi', 300.00, 1 UNION ALL
    SELECT 'Darren Poynton', 40.00, 9 UNION ALL
    SELECT 'Umberto Torrielli', 17.50, 4
) ed
JOIN
    employee e
ON
    TRIM(e.first_name) || ' ' || TRIM(e.last_name) = ed.employee_name;
