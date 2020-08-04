# Analytics Dimensions & Metrics

This document defines a mapping between Ethereum network data and analytics dimensions and metrics as defined by the Google Analytics [Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/v3/).

The sections listed below are taken directly from the Google Analytics [Dimensions & Metrics Explorer](https://ga-dev-tools.appspot.com/dimensions-metrics-explorer/).

# Applicable Sections

## User

Dimensions:
- User Type `ga:userType`
- Count of Sessions `ga:sessionCount`
- Days Since Last Session `ga:daysSinceLastSession`
- Users `ga:users`
- New Users `ga:newUsers`

Metrics:
- % New Sessions `ga:percentNewSessions`
- 1 Day Active Users `ga:1dayUsers`
- 7 Day Active Users `ga:7dayUsers`
- 14 Day Active Users `ga:14dayUsers`
- 28 Day Active Users `ga:28dayUsers`
- 30 Day Active Users `ga:30dayUsers`
- Number of Sessions per User `ga:sessionsPerUser`

## Session
## Traffic Sources
## Geo Network - maybe inferrable
## Page Tracking - contract method level, nests under "App Tracking"
## Site Speed - this probably can map to gas
## App Tracking - contract level
## Event Tracking - trace/log/event level - nests under "Page Tracking"
## Exceptions - failed tx, maybe suicides
## Time
## Audience - maybe inferrable

# Contract Specific Sections

## Goal Conversions
## Content Grouping
## Ecommerce

# Inapplicable Sections

## Adwords
## Platform or Device
## System
## Internal Search
## Social Interactions
## User Timings
## Content Experiments
## Custom Variables or Columns
## DoubleClick Campaign Manager
## Adsense
## Publisher
## Ad Exchange
## DoubleClick for Publishers Backfill
## DoubleClick for Publishers
## Lifetime Value and Cohorts
## Channel Grouping
## DoubleClick Bid Manager
## DoubleClick Search
