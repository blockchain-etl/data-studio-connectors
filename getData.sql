WITH s0 AS (
  SELECT 
    session_id, 
    COUNT(*) AS pages, 
    CAST(MIN(block_timestamp) AS DATE) AS d, 
    MIN(block_timestamp) AS start_time, 
    MAX(block_timestamp) AS end_time, 
    UNIX_SECONDS(MAX(block_timestamp)) - UNIX_SECONDS(MIN(block_timestamp)) AS duration
  FROM `crypto-public-data.aux.ethereum_sessions` AS s
  GROUP BY session_id
)
,averages AS (
  SELECT
    d, 
    AVG(pages) AS avg_session_pages,
    AVG(duration) AS avg_session_duration
  FROM s0
  GROUP BY d
)
,bounces AS (
  SELECT 
    d, 
    COUNT(session_id) AS sessions
  FROM s0
  WHERE pages = 1
  GROUP BY d
)
,sessions AS (
  SELECT 
    d, 
    COUNT(session_id) AS sessions
  FROM s0
  WHERE pages > 1
  GROUP BY d
)
SELECT 
  sessions.d AS date,
  sessions.sessions + bounces.sessions AS sessions,
  bounces.sessions AS bounces,
  bounces.sessions / (bounces.sessions + sessions.sessions) AS bounce_rate,
  averages.avg_session_pages,
  averages.avg_session_duration
FROM
  sessions,
  bounces,
  averages
WHERE TRUE
  AND sessions.d = bounces.d 
  AND sessions.d = averages.d
  AND sessions.d >= PARSE_DATE("%Y%m%d", @DS_START_DATE)
  AND sessions.d <= PARSE_DATE("%Y%m%d", @DS_END_DATE)
ORDER BY date
