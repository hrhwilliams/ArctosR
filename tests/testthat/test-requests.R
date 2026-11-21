library(ArctosR)

test_that("get_records turns an Arctos error into an R error with the message and URL", {
  local_mocked_bindings(perform_request = function(...) fixture_response("error_no_api_key", 401))

  testthat::expect_error(
    get_records(genus = "Canis", api_key = "BAD"),
    "Invalid API key.*record\\.cfc"
  )
})

test_that("get_record_count reports Arctos errors", {
  local_mocked_bindings(perform_request = function(...) fixture_response("error_no_api_key", 401))

  testthat::expect_error(get_record_count(genus = "Canis", api_key = "BAD"), "Invalid API key")
})

test_that("status helpers describe a failed query", {
  local_mocked_bindings(perform_request = function(...) fixture_response("error_no_api_key", 401))

  query <- Query$new()
  query$catalog_request()$set_query(genus = "Canis")
  query$perform("BAD")

  testthat::expect_false(check_for_status(query))
  testthat::expect_match(get_error_response(query), "Invalid API key")
  testthat::expect_match(get_last_response_url(query), "genus=Canis", fixed = TRUE)
})

test_that("get_error_response says so when the query succeeded", {
  local_mocked_bindings(perform_request = function(...) fixture_response("test_request_no_cols"))

  query <- get_records(guid_prefix = "MSB:Mamm", api_key = "KEY")

  testthat::expect_true(check_for_status(query))
  testthat::expect_equal(get_error_response(query), "No error")
})

test_that("a query with nothing to perform or no responses errors clearly", {
  query <- Query$new()

  testthat::expect_error(query$perform(), "Nothing to perform")
  testthat::expect_error(query$last_response, "No responses")
  testthat::expect_error(get_request_url(query), "Query has no requests")
})

test_that("get_query_parameters and get_result_parameters return Arctos documentation", {
  sent_url <- NULL
  local_mocked_bindings(perform_request = function(url) {
    sent_url <<- url
    fixture_response("info_response")
  })

  query_params <- get_query_parameters()
  testthat::expect_match(sent_url, "catalog.cfc?method=about", fixed = TRUE)
  testthat::expect_s3_class(query_params, "data.frame")
  testthat::expect_true(all(c("display", "obj_name", "description") %in% names(query_params)))
  testthat::expect_gt(nrow(query_params), 0)

  result_params <- get_result_parameters()
  testthat::expect_s3_class(result_params, "data.frame")
  testthat::expect_gt(nrow(result_params), 0)
})

test_that("get_relationships asks for related items of one GUID", {
  sent_url <- NULL
  local_mocked_bindings(perform_request = function(url) {
    sent_url <<- url
    fixture_response("test_request_with_cols")
  })

  df <- get_relationships("MSB:Mamm:233627", api_key = "KEY")

  testthat::expect_match(sent_url, "guid=MSB%3AMamm%3A233627", fixed = TRUE)
  testthat::expect_match(sent_url, "return_columns=relatedcatalogeditems", fixed = TRUE)
  testthat::expect_s3_class(df, "data.frame")
})

test_that("perform_request turns a curl response into status, timestamp and parsed JSON", {
  local_mocked_bindings(curl_fetch_memory = function(url, handle) {
    list(
      status_code = 200L,
      type = "application/json;charset=UTF-8",
      headers = charToRaw("HTTP/2 200\r\ncontent-type: application/json\r\ndate: Thu, 26 Sep 2024 01:58:51 GMT\r\n\r\n"),
      content = charToRaw('{"recordsTotal": 7}')
    )
  })

  response <- perform_request("https://example.org")

  testthat::expect_equal(response$status_code, 200L)
  testthat::expect_equal(response$content$recordsTotal, 7)
  testthat::expect_equal(format(response$arctos_timestamp, tz = "GMT"), "2024-09-26 01:58:51")
})
