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
    "TODO" as referralPath,
    "TODO" as fullReferrer,
    "TODO" as campaign,
    "TODO" as source,
    "TODO" as medium,
    "TODO" as sourceMedium,
    "TODO" as keyword,
    "TODO" as adContent,
    "TODO" as socialNetwork,
    "TODO" as hasSocialSourceReferral,
    "TODO" as campaignCode,
    -- METRICS
    "TODO" as organicSearches
  ) AS traffic_sources
  ,STRUCT(
    "TODO" as continent,
    "TODO" as subContinent,
    "TODO" as country,
    "TODO" as region,
    "TODO" as metro,
    "TODO" as city,
    "TODO" as latitude,
    "TODO" as longitude,
    "TODO" as networkDomain,
    "TODO" as networkLocation,
    "TODO" as cityId,
    "TODO" as continentId,
    "TODO" as countryIsoCode,
    "TODO" as metroId,
    "TODO" as regionId,
    "TODO" as regionIsoCode,
    "TODO" as subContinentCode
  ) AS geo_network
  ,STRUCT(
    "TODO" as userAgeBracket,
    "TODO" as userGender,
    "TODO" as interestOtherCategory,
    "TODO" as interestAffinityCategory,
    "TODO" as interestInMarketCategory
  ) AS audience
  ,STRUCT(
    -- METRICS
    "TODO" as pageLoadTime,
    "TODO" as pageLoadSample,
    "TODO" as avgPageLoadTime,
    "TODO" as domainLookupTime,
    "TODO" as avgDomainLookupTime,
    "TODO" as pageDownloadTime,
    "TODO" as avgPageDownloadTime,
    "TODO" as redirectionTime,
    "TODO" as avgRedirectionTime,
    "TODO" as serverConnectionTime,
    "TODO" as avgServerConnectionTime,
    "TODO" as serverResponseTime,
    "TODO" as avgServerResponseTime,
    "TODO" as speedMetricsSample,
    "TODO" as domInteractiveTime,
    "TODO" as avgDomInteractiveTime,
    "TODO" as domContentLoadedTime,
    "TODO" as avgDomContentLoadedTime,
    "TODO" as domLatencyMetricsSample
  ) AS site_speed
  ,STRUCT(
    "TODO" as exceptionDescription,
    -- METRICS
    "TODO" as exceptions,
    "TODO" as exceptionsPerScreenview,
    "TODO" as fatalExceptions,
    "TODO" as fatalExceptionsPerScreenview  
  ) AS exceptions
  ,STRUCT(
    "TODO" as date,
    "TODO" as year,
    "TODO" as month,
    "TODO" as week,
    "TODO" as day,
    "TODO" as hour,
    "TODO" as minute,
    "TODO" as nthMonth,
    "TODO" as nthWeek,
    "TODO" as nthDay,
    "TODO" as nthMinute,
    "TODO" as dayOfWeek,
    "TODO" as dayOfWeekName,
    "TODO" as dateHour,
    "TODO" as dateHourMinute,
    "TODO" as yearMonth,
    "TODO" as yearWeek,
    "TODO" as isoWeek,
    "TODO" as isoYear,
    "TODO" as isoYearIsoWeek,
    "TODO" as nthHour    
  ) AS time
  ,STRUCT(
    "TODO" as appInstallerId,
    "TODO" as appVersion,
    "TODO" as appName,
    "TODO" as appId,
    "TODO" as screenName,
    "TODO" as screenDepth,
    "TODO" as landingScreenName,
    -- METRICS
    "TODO" as exitScreenName,
    "TODO" as screenviews,
    "TODO" as uniqueScreenviews,
    "TODO" as screenviewsPerSession,
    "TODO" as timeOnScreen,
    "TODO" as avgScreenviewDuration
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
