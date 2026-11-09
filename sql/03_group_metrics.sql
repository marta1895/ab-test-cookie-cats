-- Q1: Metrics by group
SELECT 
	version,
	COUNT(*) AS players_cnt,
	ROUND(100.0 * COUNT(CASE WHEN retention_1 = TRUE THEN 1 END) / COUNT(*), 2) AS retention_1_pct,
	ROUND(100.0 * COUNT(CASE WHEN retention_7 = TRUE THEN 1 END) / COUNT(*), 2) AS retention_7_pct,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY sum_gamerounds) AS median_gamerounds,
	ROUND(AVG(sum_gamerounds), 1) AS mean_gamerounds
FROM players
GROUP BY version
ORDER BY version;

--Results:
--#|version|players_cnt|retention_1_pct|retention_7_pct|median_gamerounds|mean_gamerounds|
--+-------+-----------+---------------+---------------+-----------------+---------------+
--1|gate_30|      44699|          44.82|          19.02|             17.0|           51.3|
--2|gate_40|      45489|          44.23|          18.20|             16.0|           51.3|