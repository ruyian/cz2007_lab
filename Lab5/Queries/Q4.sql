-- Let us define the “latency” of an employee by the average that he/she takes to process a complaint.
-- Find the employee with the smallest latency.

-- Subquery: latency_record
-- We first aggregate the latency defined in the question
-- Then we select the employee(s) by clauses TOP 1 WITH TIES and ORDER BY
-- Note: We use WITH TIES to allow multiple results
WITH latency_record AS(
   SELECT TOP 1 WITH TIES employee_id, AVG(CAST(DATEDIFF(second, resolved_timestamp, assigned_timestamp) as FLOAT)) AS latency
   FROM complaint
   GROUP BY employee_id
   ORDER BY latency
)

-- Fetch all information of the employee(s) from table employee
SELECT employee_id, employee_name, salary
FROM employee
WHERE employee_id IN (SELECT employee_id FROM latency_record)