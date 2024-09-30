WITH RECURSIVE approval_cycles (start_employee, current_employee, next_manager, path, depth) AS (
    SELECT 
        e.employee_id AS start_employee,         
	e.employee_id AS current_employee,       
        e.manager_id AS next_manager,            
        CAST(e.employee_id AS VARCHAR) AS path, 
        1 AS depth                               
    FROM employee e
    UNION ALL
    SELECT 
        ac.start_employee,                       
        e.employee_id AS current_employee,       
        e.manager_id AS next_manager,            
        CONCAT(ac.path, ',', CAST(e.employee_id AS VARCHAR)) AS path,  
        ac.depth + 1                             
    FROM approval_cycles ac
    JOIN employee e ON ac.next_manager = e.employee_id
    WHERE ac.start_employee != ac.next_manager   
    AND POSITION(CAST(e.employee_id AS VARCHAR) IN ac.path) = 0  
)

SELECT 
    ac.start_employee AS employee_id,       
    ac.path AS cycle_path                   
FROM approval_cycles ac
WHERE ac.start_employee = ac.next_manager   
AND ac.depth > 1                            
ORDER BY ac.start_employee;
