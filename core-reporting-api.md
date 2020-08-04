# Analytics Dimensions & Metrics

This document defines a mapping between Ethereum network data and analytics dimensions and metrics as defined by the Google Analytics [Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/v3/).

The sections listed below are taken directly from the Google Analytics [Dimensions & Metrics Explorer](https://ga-dev-tools.appspot.com/dimensions-metrics-explorer/).

# Applicable Sections

## User
### Dimensions
- User Type `ga:userType`
- Count of Sessions `ga:sessionCount`
- Days Since Last Session `ga:daysSinceLastSession`
- Users `ga:users`
- New Users `ga:newUsers`
### Metrics
- % New Sessions `ga:percentNewSessions`
- 1 Day Active Users `ga:1dayUsers`
- 7 Day Active Users `ga:7dayUsers`
- 14 Day Active Users `ga:14dayUsers`
- 28 Day Active Users `ga:28dayUsers`
- 30 Day Active Users `ga:30dayUsers`
- Number of Sessions per User `ga:sessionsPerUser`

## Session
### Dimensions
- Session Duration `ga:sessionDurationBucket`
### Metrics
- Sessions `ga:sessions`
- Bounces `ga:bounces`
- Bounce Rate `ga:bounceRate`
- Session Duration `ga:sessionDuration`
- Avg. Session Duration `ga:avgSessionDuration`
- Unique Dimension Combinations `ga:uniqueDimensionCombinations`
- Hits `ga:hits`

## Traffic Sources
### Dimensions
(relevant for contracts interacted with before current scope, such as on-chain use of tokens after withdrawal from a known exchange address)
- Referral Path `ga:referralPath`
- Full Referrer `ga:fullReferrer`
(application-specific dimensions)
- Campaign `ga:campaign`
- Source `ga:source`
- Medium `ga:medium`
- Source / Medium `ga:sourceMedium`
(these can perhaps map to a list of social network contracts)
- Social Network `ga:socialNetwork`
- Social Source Referral `ga:hasSocialSourceReferral`

## Geo Network - maybe inferrable
### Dimensions
(maybe inferrable based on median UTC time offset of a user's transaction timestamps)
- Longitude `ga:longitude`

## Audience - maybe inferrable
### Dimensions
(application-specific dimensions)
- Age `ga:userAgeBracket`
- Gender `ga:userGender`

## Site Speed - this probably can map to gas

## Exceptions - failed tx, maybe suicides
### Dimensions
(likely related to trace data)
- Exception Description `ga:exceptionDescription`
### Metrics
- Exceptions `ga:exceptions`
- Exceptions / Screen `ga:exceptionsPerScreenview`
- Crashes `ga:fatalExceptions`
- Crashes / Screen `ga:fatalExceptionsPerScreenview`

## Time
### Dimensions
(can all be derived from block_timestamp)
- Date `ga:date`
- Year `ga:year`
- Month of the year `ga:month`
- Week of the Year `ga:week`
- Day of the month `ga:day`
- Hour `ga:hour`
- Minute `ga:minute`
- Month Index `ga:nthMonth`
- Week Index `ga:nthWeek`
- Day Index `ga:nthDay`
- Minute Index `ga:nthMinute`
- Day of Week `ga:dayOfWeek`
- Day of Week Name `ga:dayOfWeekName`
- Hour of Day `ga:dateHour`
- Date Hour and Minute `ga:dateHourMinute`
- Month of Year `ga:yearMonth`
- Week of Year `ga:yearWeek`
- ISO Week of the Year `ga:isoWeek`
- ISO Year `ga:isoYear`
- ISO Week of ISO Year `ga:isoYearIsoWeek`
- Hour Index `ga:nthHour`

## App Tracking
(contract level)
### Dimensions
- App Installer ID `ga:appInstallerId` *contract creator address*
- App Version `ga:appVersion` *application specific dimension*
- App Name `ga:appName` *from some registry TODO*
- App ID `ga:appId` *contract address*
- Screen Name `ga:screenName` *application specific dimension*
- Landing Screen `ga:landingScreenName` *first tx in scope*
- Exit Screen `ga:exitScreenName` *last tx in scope*
### Metrics
- Screen Views `ga:screenviews`
- Unique Screen Views `ga:uniqueScreenviews`
- Screens / Session `ga:screenviewsPerSession`
- Time on Screen `ga:timeOnScreen`
- Avg. Time on Screen `ga:avgScreenviewDuration`

## Page Tracking
(contract method level, nests under "App Tracking")
### Dimensions
- Page Title `ga:pageTitle`
- Landing Page `ga:landingPagePath`
- Second Page `ga:secondPagePath`
- Exit Page `ga:exitPagePath`
- Previous Page Path `ga:previousPagePath`
- Page Depth `ga:pageDepth`
### Metrics
- Page Value `ga:pageValue`
- Entrances `ga:entrances`
- Entrances / Pageviews `ga:entranceRate`
- Pageviews `ga:pageviews`
- Pages / Session `ga:pageviewsPerSession`
- Unique Pageviews `ga:uniquePageviews`
- Time on Page `ga:timeOnPage`
- Avg. Time on Page `ga:avgTimeOnPage`
- Exits `ga:exits`
- % Exit `ga:exitRate`

## Event Tracking
(trace/log/event level - nests under "Page Tracking")
### Dimensions
- Event Category `ga:eventCategory`
- Event Action `ga:eventAction`
- Event Label `ga:eventLabel`
### Metrics
- Total Events `ga:totalEvents`
- Unique Events `ga:uniqueEvents`
- Event Value `ga:eventValue`
- Avg. Value `ga:avgEventValue`
- Sessions with Event `ga:sessionsWithEvent`
- Events / Session with Event `ga:eventsPerSessionWithEvent`

# Application Specific Sections
Goal Conversions
Content Grouping
Ecommerce

# Inapplicable Sections
Adwords
Platform or Device
System
Internal Search
Social Interactions
User Timings
Content Experiments
Custom Variables or Columns
DoubleClick Campaign Manager
Adsense
Publisher
Ad Exchange
DoubleClick for Publishers Backfill
DoubleClick for Publishers
Lifetime Value and Cohorts
Channel Grouping
DoubleClick Bid Manager
DoubleClick Search
