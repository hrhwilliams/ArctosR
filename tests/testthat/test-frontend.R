library(ArctosR)

test_that("get_result_parameters", {
  result_params <- get_result_parameters()
  testthat::expect_s3_class(result_params, "data.frame")
})

test_that("get_record_count", {
  count <- get_record_count(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm"
  )

  testthat::expect_gt(count, 0)
})

test_that("get_records_no_cols", {
  response <- get_records(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm"
  )

  df <- response_data(response)

  testthat::expect_s3_class(df, "data.frame")
})

test_that("get_records_with_cols", {
  response <- get_records(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  df <- response_data(response)

  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(sort(c("collection_object_id", "guid", "parts", "partdetail")), sort(colnames(df)))
})

test_that("get_records_all_records", {
  count <- get_record_count(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm"
  )

  response <- get_records(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm",
    all_records = TRUE
  )

  df <- response_data(response)
  testthat::expect_equal(nrow(df), count)
})
