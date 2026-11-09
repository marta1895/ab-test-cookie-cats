--checking row counts
SELECT COUNT(*) AS players, COUNT(DISTINCT userid) AS unique_players
FROM players;

--checking players per group
SELECT version, COUNT(*) AS players
FROM players
GROUP BY version;