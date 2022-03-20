SELECT TOP 1 eID, employee_name, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS latency
FROM complaint JOIN employee ON eID = employee_id
GROUP BY eID
ORDER BY latency