-- Let us define the “latency” of an employee by the average that he/she takes to process a complaint.
-- Find the employee with the smallest latency.

WITH latency_record AS(
   SELECT TOP 1 WITH TIES employee_id, AVG(CAST(DATEDIFF(second, resolved_timestamp, assigned_timestamp) as FLOAT)) AS latency
   FROM complaint
   GROUP BY employee_id
   ORDER BY latency
)

SELECT employee_id, employee_name, salary
FROM employee
WHERE employee_id IN (SELECT employee_id FROM latency_record)

/*
DROP TABLE IF EXISTS LatencyRecord

SELECT employee_id, AVG(DATEDIFF(second, file_timestamp, resolved_timestamp)) AS AvgLatency INTO LatencyRecord
FROM complaint
GROUP BY employee_id;

-- Find all the information of the employee with the smallest latency
SELECT E.employee_id, E.employee_name, E.salary
FROM LatencyRecord as L, employee as E
WHERE L.employee_id = E.employee_id
   AND AvgLatency = (SELECT MIN(AvgLatency) FROM LatencyRecord);
*/