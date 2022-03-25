-- Let us define the “latency” of an employee by the average that he/she takes to process a complaint.
-- Find the employee with the smallest latency.

DROP TABLE IF EXISTS LatencyRecord

SELECT employee_id, AVG(DATEDIFF(second, file_timestamp, resolved_timestamp)) AS AvgLatency INTO LatencyRecord
FROM complaint
GROUP BY employee_id;

/*
-- proof check
SELECT *
FROM LatencyRecord;
*/

-- Find all the information of the employee with the smallest latency
SELECT E.employee_id, E.employee_name, E.salary
FROM LatencyRecord as L, employee as E
WHERE L.employee_id = E.employee_id
   AND AvgLatency = (SELECT MIN(AvgLatency) FROM LatencyRecord);


-- old version - abandoned for having low efficiency (join)
/*
SELECT TOP 1 employee_id, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS latency
FROM complaint
GROUP BY employee_id
ORDER BY latency
*/