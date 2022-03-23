-- Let us define the “latency” of an employee by the average that he/she takes to process a complaint.
-- Find the employee with the smallest latency.

SELECT employee_id, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS AvgLatency INTO LatencyRecord
FROM complaint
GROUP BY employee_id;

SELECT employee_id
FROM LatencyRecord
WHERE AvgLatency = (SELECT MIN(AvgLatency) FROM LatencyRecord);

-- old version - abandoned for having low efficiency (join)
-- SELECT TOP 1 eID, employee_name, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS latency
-- FROM complaint JOIN employee ON eID = employee_id
-- GROUP BY eID
-- ORDER BY latency