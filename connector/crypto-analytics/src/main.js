var cc = DataStudioApp.createCommunityConnector();

// https://developers.google.com/datastudio/connector/reference#isadminuser
function isAdminUser() {
  // TODO: update. Set to true to ease initial debugging.
  return true;
}

var bqTypes = DataStudioApp.createCommunityConnector().BigQueryParameterType;

// https://developers.google.com/datastudio/connector/reference#getconfig
function getConfig(request) {
  var config = cc.getConfig();

  config
    .newInfo()
    .setId("cryptoAnalytics")
    .setText("Google Data Studio - Community crypto analytics connector");

  return config.build();
}

function getFields() {
  var fields = cc.getFields();
  var types = cc.FieldType;
  var aggregations = cc.AggregationType;

  fields
    .newDimension()
    .setId("count")
    .setName("count")
    .setType(types.NUMBER);

  return fields;
}

// https://developers.google.com/datastudio/connector/reference#getschema
function getSchema(request) {
  return { schema: getFields().build() };
}

// https://developers.google.com/datastudio/connector/reference#getdata
var sqlString = "SELECT COUNT(*) AS count FROM origin-214503.marketplace.listings;"

function getData(request) {
  //var url = (request.configParams && request.configParams.url);
  //var projectId = (request.configParams && request.configParams.projectId);
  try {
    var authToken = ScriptApp.getOAuthToken();
    return cc
      .newBigQueryConfig()
      .setAccessToken(authToken)
      .setUseStandardSql(true)
      .setBillingProjectId("origin-214503")
      .setQuery(sqlString)
      .build();
  } catch (e) {
    cc.newUserError()
      .setDebugText("Error fetching data from API. Exception details: " + e)
      .setText(
        "There was an error communicating with the service. Try again later, or file an issue if this error persists."
      )
      .throwException();
  }
}
