const cc = DataStudioApp.createCommunityConnector();

// https://developers.google.com/datastudio/connector/reference#isadminuser
function isAdminUser() {
  // TODO: update. Set to true to ease initial debugging.
  return true;
}

const MARKETPLACE_ADDRESS = "0x698ff47b84837d3971118a369c570172ee7e54c2";
const OGN_ADDRESS = "0x903dc47aa7c40f9f59ef1e5c167ce1a9b39a2bff";

const DEFAULT_CONTRACT_ADDRESS = MARKETPLACE_ADDRESS;

// TODO: figure out how to programmatically get the user's project ID.
const DEFAULT_PROJECT_ID = "origin-214503";

const bqTypes = DataStudioApp.createCommunityConnector().BigQueryParameterType;

// https://developers.google.com/datastudio/connector/reference#getconfig
function getConfig(request) {
  const config = cc.getConfig();

  config
    .newInfo()
    .setId("cryptoAnalytics")
    .setText("Google Data Studio - Community crypto analytics connector");

  config
    .newTextInput()
    .setId("projectId")
    .setName("Enter your GCP project ID")
    .setHelpText("You can find your GCP project ID on your the GCP console")
    .setPlaceholder(DEFAULT_PROJECT_ID);

  config
    .newTextInput()
    .setId("contractAddress")
    .setName("Enter an Ethereum contact adddress")
    .setPlaceholder(DEFAULT_CONTRACT_ADDRESS)
    .setAllowOverride(true);

  // This forces a date range object to be provided for `getData()` requests.
  // https://developers.google.com/apps-script/reference/data-studio/config#setDateRangeRequired(Boolean)
  // config.setDateRangeRequired(true);

  return config.build();
}

function getFields() {
  const fields = cc.getFields();
  const types = cc.FieldType;

  fields
    .newDimension()
    .setId("referrer")
    .setName("referrer")
    .setDescription("Eth address the call came from")
    .setType(types.TEXT);

  fields
    .newMetric()
    .setId("freq")
    .setName("freq")
    .setDescription("Number of occurences")
    .setType(types.NUMBER);

  return fields;
}

// https://developers.google.com/datastudio/connector/reference#getschema
function getSchema(request) {
  const fields = getFields();
  return cc
    .newGetSchemaResponse()
    .setFields(fields)
    .build();
}

// https://developers.google.com/datastudio/connector/reference#getdata
const sqlString = `
  WITH wanted AS (
  SELECT
    session_id,
    ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY block_timestamp) AS pos,
    CASE WHEN tx.to_address = @contractAddress THEN TRUE ELSE NULL END AS ok,
    tx.to_address
  FROM \`crypto-public-data.aux.materialized_sessions\` AS sessions JOIN UNNEST(transactions) AS tx
  WHERE TRUE
  ),
  raw_referrers AS (
  SELECT
    wanted.session_id, wanted.ok, wanted.pos,
    CASE WHEN wanted.pos-1 > 0 THEN transactions[ORDINAL(wanted.pos-1)].to_address ELSE NULL END AS referrer
  FROM
  \`crypto-public-data.aux.materialized_sessions\` AS sessions, wanted
  WHERE TRUE
    AND wanted.ok IS TRUE
    AND sessions.session_id = wanted.session_id
  ),
  referrers AS (
  SELECT DISTINCT session_id, FIRST_VALUE(referrer) OVER(PARTITION BY session_id ORDER BY pos) AS referrer
  FROM raw_referrers
  WHERE referrer IS NULL OR (referrer != @contractAddress)
  ORDER BY session_id
  )
  SELECT referrer, COUNT(*) AS freq
  FROM referrers
  GROUP BY referrer
  ORDER BY freq DESC`;

function getData(request) {
  const contractAddress = request.configParams.contractAddress;
  if (!contractAddress) {
    cc.newUserError()
      .setDebugText("No contract address provided")
      .setText("No contract address provided")
      .throwException();
  }

  console.log(`REQUEST=${JSON.stringify(request)}`);
  let response;
  try {
    const authToken = ScriptApp.getOAuthToken();
    response = cc
      .newBigQueryConfig()
      .setAccessToken(authToken)
      .setUseStandardSql(true)
      .setBillingProjectId(request.configParams.projectId)
      .setQuery(sqlString)
      .addQueryParameter("contractAddress", bqTypes.STRING, contractAddress)
      .build();
  } catch (e) {
    cc.newUserError()
      .setDebugText("Error fetching data from API. Exception: " + e)
      .setText("Error fetching data from API.")
      .throwException();
  }
  console.log(`RESPONSE=${JSON.stringify(response)}`);
  return response;
}
