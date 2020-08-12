WITH s0 AS (
  SELECT 
    session_id, 
    transaction_count AS pages,
    CAST(start_time AS DATE) AS date, 
    start_time, end_time, duration
  FROM
    `crypto-public-data.aux.materialized_sessions` AS sessions
  WHERE TRUE
    AND EXISTS(SELECT 1 FROM UNNEST(sessions.to_address_set) AS x WHERE x = '0x32666b64e9fd0f44916e1378efb2cfa3b3b96e80') 
--       '0x903dc47aa7c40f9f59ef1e5c167ce1a9b39a2bff' --origin protocol token
--       '0x32666b64e9fd0f44916e1378efb2cfa3b3b96e80' -- renbridge
    AND ARRAY_LENGTH(sessions.to_address_set) > 1 -- sessions involving more than one to_address
)

,averages AS (
  SELECT
    date, 
    AVG(pages) AS avg_session_pages,
    AVG(duration) AS avg_session_duration
  FROM s0
  GROUP BY date
)
,sums AS (
  SELECT date,
  SUM(pages) AS hits
  FROM s0
  GROUP BY date
)
,bounces AS (
  SELECT 
    date, 
    COUNT(session_id) AS sessions
  FROM s0
  WHERE pages = 1
  GROUP BY date
)
,sessions AS (
  SELECT 
    date, 
    COUNT(session_id) AS sessions
  FROM s0
  WHERE pages > 1
  GROUP BY date
)

##########
##########
##########

SELECT 
  sessions.date,
  s0.session_id
  ,STRUCT(
    "TODO" as userType,
    "TODO" AS sessionCount,
    "TODO" AS daysSinceLastSession,
    "TODO" AS users,
    "TODO" AS newUsers,
    -- METRICS
    "TODO" AS percentNewSessions,
    "TODO" AS _1dayUsers,
    "TODO" AS _7dayUsers,
    "TODO" AS _14dayUsers,
    "TODO" AS _28dayUsers,
    "TODO" AS _30dayUsers,
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
--     "TODO" as referralPath,
    "TODO" as fullReferrer
--     "TODO" as campaign,
--     "TODO" as source,
--     "TODO" as medium,
--     "TODO" as sourceMedium,
--     "TODO" as keyword,
--     "TODO" as adContent,
--     "TODO" as socialNetwork,
--     "TODO" as hasSocialSourceReferral,
--     "TODO" as campaignCode,
--     -- METRICS
--     "TODO" as organicSearches
  ) AS traffic_sources
  ,STRUCT(
--     "TODO" as continent,
--     "TODO" as subContinent,
--     "TODO" as country,
--     "TODO" as region,
--     "TODO" as metro,
--     "TODO" as city,
--     "TODO" as latitude,
    "TODO" as longitude
--     "TODO" as networkDomain,
--     "TODO" as networkLocation,
--     "TODO" as cityId,
--     "TODO" as continentId,
--     "TODO" as countryIsoCode,
--     "TODO" as metroId,
--     "TODO" as regionId,
--     "TODO" as regionIsoCode,
--     "TODO" as subContinentCode
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
--     "N/A" as pageLoadSample,
    "TODO" as avgPageLoadTime
--     "N/A" as domainLookupTime,
--     "N/A" as avgDomainLookupTime,
--     "N/A" as pageDownloadTime,
--     "N/A" as avgPageDownloadTime,
--     "N/A" as redirectionTime,
--     "N/A" as avgRedirectionTime,
--     "N/A" as serverConnectionTime,
--     "N/A" as avgServerConnectionTime,
--     "N/A" as serverResponseTime,
--     "N/A" as avgServerResponseTime,
--     "N/A" as speedMetricsSample,
--     "N/A" as domInteractiveTime,
--     "N/A" as avgDomInteractiveTime,
--     "N/A" as domContentLoadedTime,
--     "N/A" as avgDomContentLoadedTime,
--     "N/A" as domLatencyMetricsSample
  ) AS site_speed
--   ,STRUCT(
--     "TODO" as exceptionDescription,
--     -- METRICS
--     "TODO" as exceptions,
--     "TODO" as exceptionsPerScreenview,
--     "TODO" as fatalExceptions,
--     "TODO" as fatalExceptionsPerScreenview  
--   ) AS exceptions
  ,STRUCT(
    CAST(s0.start_time AS DATE) as date,
    EXTRACT(YEAR FROM start_time) as year,
    EXTRACT(MONTH FROM start_time) as month,
    EXTRACT(WEEK FROM start_time) as week,
    EXTRACT(DAY FROM start_time) as day,
    EXTRACT(HOUR FROM start_time) as hour,
    EXTRACT(MINUTE FROM start_time) as minute,
    "TODO" as nthMonth,
    "TODO" as nthWeek,
    "TODO" as nthDay,
    "TODO" as nthMinute,
    EXTRACT(DAYOFWEEK FROM start_time) as dayOfWeek,
    "TODO" as dayOfWeekName,
    "TODO" as dateHour,
    "TODO" as dateHourMinute,
    "TODO" as yearMonth,
    "TODO" as yearWeek,
    EXTRACT(ISOWEEK FROM start_time) as isoWeek,
    EXTRACT(ISOYEAR FROM start_time) as isoYear,
    "TODO" as isoYearIsoWeek,
    "TODO" as nthHour    
  ) AS time
--   ,STRUCT(
--     "N/A" as appInstallerId,
--     "TODO" as appVersion,
--     "TODO" as appName,
--     "TODO" as appId,
--     "TODO" as screenName,
--     "TODO" as screenDepth,
--     "TODO" as landingScreenName,
--     -- METRICS
--     "TODO" as exitScreenName,
--     "TODO" as screenviews,
--     "TODO" as uniqueScreenviews,
--     "TODO" as screenviewsPerSession,
--     "TODO" as timeOnScreen,
--     "TODO" as avgScreenviewDuration
--   ) AS app_tracking
--   ,STRUCT(
--     "TODO" as pageTitle,
--     "TODO" as landingPageDepth,
--     "TODO" as secondPageDepth,
--     "TODO" as exitPagePath,
--     "TODO" as previousPagePath,
--     "TODO" as pageDepth,
--     -- METRICS
--     "TODO" as pageValue,
--     "TODO" as entrances,
--     "TODO" as entranceRate,
--     "TODO" as pageviews,
--     "TODO" as pageviewsPerSession,
--     "TODO" as uniquePageviews,
--     "TODO" as timeOnPage,
--     "TODO" as avgTimeOnPage,
--     "TODO" as exits,
--     "TODO" as exitRate
--   ) AS page_tracking
--   ,STRUCT(
--     "TODO" as eventCategory,
--     "TODO" as eventAction,
--     "TODO" as eventLabel,
--     -- METRICS
--     "TODO" as totalEvents,
--     "TODO" as uniqueEvents,
--     "TODO" as eventValue,
--     "TODO" as avgEventValue,
--     "TODO" as sessionsWithEvent,
--     "TODO" as eventsPerSessionWithEvent
--   ) AS event_tracking
FROM
  s0,
  sessions,
  bounces,
  averages,
  sums
WHERE TRUE
  AND s0.date = sessions.date
  AND s0.date = bounces.date 
  AND s0.date = averages.date
  AND s0.date = sums.date
ORDER BY date
LIMIT 1000
