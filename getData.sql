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
,sums AS (
  SELECT d,
  SUM(pages) AS hits
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
  sessions.d AS date
  ,STRUCT(
    "TODO" as userType,
    "TODO" AS sessionCount,
    "TODO" AS daysSinceLastSession,
    "TODO" AS users,
    "TODO" AS newUsers,
    -- METRICS
    "TODO" AS percentNewSessions,
    "TODO" AS `1dayUsers`,
    "TODO" AS `7dayUsers`,
    "TODO" AS `14dayUsers`,
    "TODO" AS `28dayUsers`,
    "TODO" AS `30dayUsers`,
    "TODO" AS sessionsPerUser
  ) AS user
  ,STRUCT(
    "TODO" AS sessionDurationBucket,
    -- METRICS
    sessions.sessions + bounces.sessions AS sessions,
    bounces.sessions AS bounces,
    bounces.sessions / (bounces.sessions + sessions.sessions) AS bounceRate,
    "TODO" AS sessionDuration,
    averages.avg_session_duration as avgSessionDuration,
    "TODO" AS uniqueDimensionCombinations,
    sums.hits
  ) AS session
  ,STRUCT(
    "TODO" as todo
  ) AS traffic_sources
  ,STRUCT(
    "TODO" as todo
  ) AS geo_network
  ,STRUCT(
    "TODO" as todo
  ) AS audience
  ,STRUCT(
    "TODO" as todo
  ) AS site_speed
  ,STRUCT(
    "TODO" as todo
  ) AS exceptions
  ,STRUCT(
    "TODO" as todo
  ) AS time
  ,STRUCT(
    "TODO" as todo
  ) AS app_tracking
  ,STRUCT(
    "TODO" as pageTitle,
    "TODO" as landingPageDepth,
    "TODO" as secondPageDepth,
    "TODO" as exitPagePath,
    "TODO" as previousPagePath,
    "TODO" as pageDepth,
    -- METRICS
    "TODO" as pageValue,
    "TODO" as entrances,
    "TODO" as entranceRate,
    "TODO" as pageviews,
    "TODO" as pageviewsPerSession,
    "TODO" as uniquePageviews,
    "TODO" as timeOnPage,
    "TODO" as avgTimeOnPage,
    "TODO" as exits,
    "TODO" as exitRate
  ) AS page_tracking
  ,STRUCT(
    "TODO" as eventCategory,
    "TODO" as eventAction,
    "TODO" as eventLabel,
    -- METRICS
    "TODO" as totalEvents,
    "TODO" as uniqueEvents,
    "TODO" as eventValue,
    "TODO" as avgEventValue,
    "TODO" as sessionsWithEvent,
    "TODO" as eventsPerSessionWithEvent
  ) AS event_tracking
FROM
  sessions,
  bounces,
  averages,
  sums
WHERE TRUE
  AND sessions.d = bounces.d 
  AND sessions.d = averages.d
  AND sessions.d = sums.d
ORDER BY date
LIMIT 1000
