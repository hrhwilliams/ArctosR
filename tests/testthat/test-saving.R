library(ArctosR)

new_temp_dir <- function() {
  dir <- tempfile()
  dir.create(dir)
  dir
}

test_that("save_response_csv writes the records and metadata without the API key", {
  local_mocked_bindings(perform_request = function(...) fixture_response("test_request_no_cols"))
  old_wd <- setwd(new_temp_dir())
  on.exit(setwd(old_wd), add = TRUE)

  query <- get_records(guid_prefix = "MSB:Mamm", api_key = "SECRET-KEY-123", limit = 50)
  save_response_csv(query, "canis")

  testthat::expect_equal(nrow(read.csv("canis.csv")), 50)
  metadata <- paste(readLines("canis.json"), collapse = "\n")
  testthat::expect_match(metadata, "guid_prefix", fixed = TRUE)
  testthat::expect_no_match(metadata, "SECRET-KEY-123", fixed = TRUE)
})

test_that("save_response_csv can skip the metadata file", {
  local_mocked_bindings(perform_request = function(...) fixture_response("test_request_no_cols"))
  old_wd <- setwd(new_temp_dir())
  on.exit(setwd(old_wd), add = TRUE)

  query <- get_records(guid_prefix = "MSB:Mamm", api_key = "KEY")
  save_response_csv(query, "canis.csv", with_metadata = FALSE)

  testthat::expect_true(file.exists("canis.csv"))
  testthat::expect_false(file.exists("canis.json"))
})

test_that("expanded save writes one CSV per nested table and refuses to overwrite", {
  old_wd <- setwd(new_temp_dir())
  on.exit(setwd(old_wd), add = TRUE)
  records <- Records$new(
    data.frame(guid = c("a", "b"), parts = c('[{"part":"skin"}]', '[{"part":"skull"},{"part":"tail"}]')),
    "tbl"
  )
  records$expand_col("parts")

  records$save_nested_csvs("out")

  testthat::expect_setequal(list.files("out"), c("out.csv", "out_a-parts.csv", "out_b-parts.csv"))
  testthat::expect_equal(read.csv("out/out_b-parts.csv")$part, c("skull", "tail"))
  testthat::expect_error(records$save_nested_csvs("out"), "Directory already exists")
})

test_that("saving or expanding empty records errors", {
  records <- Records$new(NULL, "tbl")

  testthat::expect_error(records$save_flat_csv(tempfile()), "No data to export")
  testthat::expect_error(records$save_nested_csvs(tempfile()), "No data to export")
  testthat::expect_error(records$expand_col("parts"), "No data to expand")
})

test_that("a saved query reads back with the same records", {
  local_mocked_bindings(perform_request = function(...) fixture_response("test_request_no_cols"))

  query <- get_records(guid_prefix = "MSB:Mamm", api_key = "KEY", limit = 50)
  path <- tempfile(fileext = ".rds")
  save_response_rds(query, path)

  testthat::expect_equal(response_data(read_response_rds(path)), response_data(query))
})
