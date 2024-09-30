-- Create the INVOICE table
CREATE TABLE invoice (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

-- Create the SUPPLIER table
CREATE TABLE supplier (
    supplier_id TINYINT,
    name VARCHAR
);

-- Insert supplier data with generated supplier_id sorted alphabetically

INSERT INTO supplier (supplier_id, name)
SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS supplier_id,  -- Generate supplier_id based on alphabetical order
    name
FROM
(
    SELECT 'Party Animals' AS name UNION ALL
    SELECT 'Catering Plus' UNION ALL
    SELECT 'Dave''s Discos' UNION ALL
    SELECT 'Entertainment Tonight' UNION ALL
    SELECT 'Ice Ice Baby'
) AS supplier_data;

-- Insert invoice data into the INVOICE table
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
SELECT
    s.supplier_id,  
    invoice_data.invoice_amount,
    DATE_TRUNC('month', DATE_ADD('month', invoice_data.months_due + 1, CURRENT_DATE)) - INTERVAL '1' day AS due_date
FROM
(
    -- Invoice data from files
    
    SELECT 'Party Animals' AS company_name, 6000 AS invoice_amount, 3 AS months_due UNION ALL
    SELECT 'Catering Plus', 2000, 2 UNION ALL
    SELECT 'Catering Plus', 1500, 3 UNION ALL
    SELECT 'Dave''s Discos', 500, 1 UNION ALL
    SELECT 'Entertainment Tonight', 6000, 3 UNION ALL
    SELECT 'Ice Ice Baby', 4000, 6
) AS invoice_data
JOIN supplier s
ON s.name = invoice_data.company_name;
