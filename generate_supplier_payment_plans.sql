WITH invoice_cte AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY supplier_id, due_date) AS inv_num 
    FROM invoice
),
invoice_details AS (
    SELECT i.*, s.name AS supplier_name, 
           DATE_DIFF('month', CURRENT_DATE, i.due_date) AS num_months_per_invoice 
    FROM invoice_cte i
    JOIN supplier s ON s.supplier_id = i.supplier_id
),
splits AS (
    SELECT *, invoice_amount / num_months_per_invoice AS monthly_payments 
    FROM invoice_details
    CROSS JOIN UNNEST(SEQUENCE(0, num_months_per_invoice - 1)) AS t(m)
),
added_min AS (
    SELECT *, 
           SUM(monthly_payments) OVER (PARTITION BY inv_num ORDER BY m DESC) AS cum_pending 
    FROM splits
)
SELECT supplier_id, supplier_name, 
       SUM(monthly_payments) AS payment_due, 
       SUM(cum_pending) - SUM(monthly_payments) AS invoice_amount,
       CASE 
           WHEN m = 0 THEN 'End of this month'
           WHEN m = 1 THEN 'End of next month'
           ELSE 'End of the month after'
       END AS payment_date
FROM added_min
GROUP BY supplier_id, supplier_name, m
ORDER BY supplier_id,m;
