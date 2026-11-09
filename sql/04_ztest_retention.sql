-- Q2: Z-test for retention_7 and retention_1

-- Z-test for retention_7
WITH group_counts AS (
    -- raw counts per group; cast to numeric here so all later divisions keep decimals
    SELECT
        COUNT(CASE WHEN version = 'gate_30' THEN 1 END)::numeric                           AS n30,
        COUNT(CASE WHEN version = 'gate_40' THEN 1 END)::numeric                           AS n40,
        COUNT(CASE WHEN version = 'gate_30' AND retention_7 = TRUE THEN 1 END)::numeric    AS retained_30,
        COUNT(CASE WHEN version = 'gate_40' AND retention_7 = TRUE THEN 1 END)::numeric    AS retained_40
    FROM players
),
group_rates AS (
    -- retention share per group, and pooled share (both groups as one)
    SELECT
        n30,
        n40,
        retained_30 / n30                          AS p30,
        retained_40 / n40                          AS p40,
        (retained_30 + retained_40) / (n30 + n40)  AS p_pool
    FROM group_counts
)
-- two-proportion z-test
SELECT
    ROUND(p30 * 100, 2)          AS gate_30_pct,
    ROUND(p40 * 100, 2)          AS gate_40_pct,
    ROUND((p40 - p30) * 100, 2)  AS diff_points,
    ROUND((p40 - p30) / SQRT(p_pool * (1 - p_pool) * (1 / n30 + 1 / n40)), 3) AS z
FROM group_rates;
-- Two-proportion z-test for retention_7 (primary metric)
-- Result: gate_30 19.02%, gate_40 18.20%, diff -0.82 pp, z = -3.157 (significant at α = 0.05)


-- Z-test for retention_1
WITH group_counts AS (
    -- raw counts per group; cast to numeric here so all later divisions keep decimals
    SELECT
        COUNT(CASE WHEN version = 'gate_30' THEN 1 END)::numeric                           AS n30,
        COUNT(CASE WHEN version = 'gate_40' THEN 1 END)::numeric                           AS n40,
        COUNT(CASE WHEN version = 'gate_30' AND retention_1 = TRUE THEN 1 END)::numeric    AS retained_30,
        COUNT(CASE WHEN version = 'gate_40' AND retention_1 = TRUE THEN 1 END)::numeric    AS retained_40
    FROM players
),
group_rates AS (
    -- retention share per group, and pooled share (both groups as one)
    SELECT
        n30,
        n40,
        retained_30 / n30                          AS p30,
        retained_40 / n40                          AS p40,
        (retained_30 + retained_40) / (n30 + n40)  AS p_pool
    FROM group_counts
)
-- two-proportion z-test
SELECT
    ROUND(p30 * 100, 2)          AS gate_30_pct,
    ROUND(p40 * 100, 2)          AS gate_40_pct,
    ROUND((p40 - p30) * 100, 2)  AS diff_points,
    ROUND((p40 - p30) / SQRT(p_pool * (1 - p_pool) * (1 / n30 + 1 / n40)), 3) AS z
FROM group_rates;
-- Two-proportion z-test for retention_1 (secondary metric)
-- Result: gate_30 44.82%, gate_40 44.23%, diff -0.59 pp, z = -1.787 (not significant at α = 0.025)