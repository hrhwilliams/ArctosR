library(ArctosR)

test_that("readme example", {
  result_params <- get_result_parameters()
  testthat::expect_s3_class(result_params, "data.frame")

  count <- get_record_count(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm"
  )

  testthat::expect_gt(count, 0)

  response <- get_records(
    scientific_name="Canis lupus", guid_prefix="MSB:Mamm",
    columns = c("guid", "parts", "partdetail")
  )

  df <- response_data(response)
  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(sort(c("collection_object_id", "guid", "parts", "partdetail")), sort(colnames(df)))
})
