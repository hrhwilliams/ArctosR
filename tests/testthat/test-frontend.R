library(ArctosR)

test_that("get_records_no_cols", {
  raw_response <- readRDS('test_request_no_cols.rds')
  query <- Query$new()
  response <- query$catalog_request_from_raw_response(raw_response)

  df <- response_data(query)
  testthat::expect_s3_class(df, "data.frame")
})

test_that("get_records_with_cols", {
  raw_response <- readRDS('test_request_with_cols.rds')
  query <- Query$new()
  response <- query$catalog_request_from_raw_response(raw_response)

  df <- response_data(query)

  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(sort(colnames(df)), sort(c("collection_object_id", "guid", "parts", "partdetail")))
})

# test_that("get_records_all_records", {
#   response <- get_records(
#     scientific_name="Canis lupus", guid_prefix="MSB:Mamm",
#     all_records = TRUE
#   )
#
#   df <- response_data(response)
#   testthat::expect_s3_class(df, "data.frame")
# })
