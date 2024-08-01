test_that("request all query parameters", {
  results <- ArctosR::InfoRequestBuilder$new()$
    all_query_params()$
    perform_request()

  expect_vector(results)
})

test_that("request all result parameters", {
  results <- ArctosR::InfoRequestBuilder$new()$
    all_query_params()$
    perform_request()

  expect_vector(results)
})
