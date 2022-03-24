-- Let us define the “latency” of an employee by the average that he/she takes to process a complaint.
-- Find the employee with the smallest latency.

SELECT eID, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS AvgLatency INTO LatencyRecord
FROM complaint
GROUP BY eID;

SELECT eID
FROM LatencyRecord
WHERE AvgLatency = (SELECT MIN(AvgLatency) FROM LatencyRecord);


-- old version - abandoned for having low efficiency (join)
/*
SELECT  eID, AVG(DATEDIFF(second, resolved_timestamp, assigned_timestamp)) AS latency
FROM complaint
GROUP BY eID
ORDER BY latency
*/