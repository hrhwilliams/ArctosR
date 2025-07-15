# ArctosR
# Copyright (C) 2024-2025  Harlan Williams
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

library(ArctosR)
library(utils)

test_that("query info build request", {
  q <- Query$new()
  request <- q$info_request()$
    build_request()

  testthat::expect_equal(request$end_point, "catalog.cfc")
  testthat::expect_equal(length(request$params), 1)
  testthat::expect_equal(request$params$method, "about")
})

test_that("query info perform request", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("params_response.rds"))
    }
  )

  query_params <- get_query_parameters()
  result_params <- get_result_parameters()

  testthat::expect_s3_class(query_params, "data.frame")
  testthat::expect_s3_class(result_params, "data.frame")
  testthat::expect_gt(nrow(query_params), 0)
  testthat::expect_gt(nrow(result_params), 0)
})

test_that("query catalog request", {
  q <- Query$new()
  request <- q$catalog_request()$
    set_query(guid_prefix = "MSB:Mamm", genus = "Canis", species = "lupus")$
    set_limit(100)$
    set_columns("guid", "scientific_name", "relatedcatalogeditems")$
    build_request()

  testthat::expect_equal(request$end_point, "catalog.cfc")
  testthat::expect_equal(length(request$params), 7)
  testthat::expect_equal(request$params$method, "getCatalogData")
  testthat::expect_equal(request$params$queryformat, "struct")
  testthat::expect_equal(request$params$length, 100)
  testthat::expect_equal(request$params$guid_prefix, "MSB:Mamm")
  testthat::expect_equal(request$params$genus, "Canis")
  testthat::expect_equal(request$params$cols, "guid,scientific_name,relatedcatalogeditems")
  testthat::expect_equal(
    request$url,
    "https://arctos.database.museum/component/api/v2/catalog.cfc?method=getCatalogData&queryformat=struct&length=100&guid_prefix=MSB%3AMamm&genus=Canis&species=lupus&cols=guid%2Cscientific_name%2Crelatedcatalogeditems"
  )
})

test_that("query catalog request with record filters", {
  q <- Query$new()
  request <- q$catalog_request()$
    set_query(guid_prefix = "MSB:Mamm", genus = "Canis", species = "lupus")$
    set_limit(100)$
    set_columns("guid", "scientific_name", "relatedcatalogeditems")$
    set_filter(sex="=male", weight=">100")$
    build_request()

  testthat::expect_equal(request$end_point, "catalog.cfc")
  testthat::expect_equal(length(request$params), 11)
  testthat::expect_equal(request$params$method, "getCatalogData")
  testthat::expect_equal(request$params$queryformat, "struct")
  testthat::expect_equal(request$params$length, 100)
  testthat::expect_equal(request$params$guid_prefix, "MSB:Mamm")
  testthat::expect_equal(request$params$genus, "Canis")
  testthat::expect_equal(request$params$cols, "guid,scientific_name,relatedcatalogeditems")
  testthat::expect_equal(
    request$url,
    "https://arctos.database.museum/component/api/v2/catalog.cfc?method=getCatalogData&queryformat=struct&length=100&guid_prefix=MSB%3AMamm&genus=Canis&species=lupus&cols=guid%2Cscientific_name%2Crelatedcatalogeditems&attribute_type_1=sex&attribute_type_2=weight&attribute_value_1=%3Dmale&attribute_value_2=%3E100"
  )
})

test_that("get_record_count", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_no_cols.rds"))
    }
  )

  records <- get_record_count(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus"
  )

  testthat::expect_equal(records, 1694)
})

test_that("get_records_no_cols", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_no_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    limit = 50
  )

  df <- response_data(query)
  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(nrow(df), 50)

  response <- query$get_responses()[[1]]$to_list()
  testthat::expect_true(query$get_responses()[[1]]$was_success())
  testthat::expect_equal(query$get_responses()[[1]]$index_range, c(0, 49))
  testthat::expect_equal(response$index_range, c(0, 49))
  testthat::expect_equal(response$metadata$status_code, 200)
})

test_that("get_records missing query", {
  testthat::expect_condition(get_records())
})

test_that("get_records_no_cols concatenate", {
  i <- 0
  local_mocked_bindings(
    perform_request = function(...) {
      i <<- i + 1

      if (i == 1) {
        return(readRDS("test_request_no_cols.rds"))
      } else if (i == 2) {
        return(readRDS("test_request_no_cols_part2.rds"))
      } else {
        return(readRDS("test_request_no_cols_part3.rds"))
      }
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    all_records = TRUE
  )

  df <- response_data(query)
  testthat::expect_equal(nrow(df), 100)
})

test_that("get_records_with_cols", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_with_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    columns = list("guid", "parts", "partdetail")
  )

  df <- response_data(query)
  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(sort(colnames(df)), sort(c("collection_object_id", "guid", "parts", "partdetail")))
  testthat::expect_equal(nrow(df), 50)
})

test_that("expand_cols", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_with_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    columns = list("guid", "parts", "partdetail")
  )

  expand_column(query, "partdetail")
  df <- response_data(query)

  testthat::expect_s3_class(df$partdetail[[1]], "data.frame")
  testthat::expect_equal(sort(colnames(df)), sort(c("collection_object_id", "guid", "parts", "partdetail")))
  testthat::expect_equal(nrow(df), 50)
})

test_that("expand_cols fail", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_with_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    columns = list("guid", "parts", "partdetail")
  )

  testthat::expect_condition(expand_column(query, "no col"))
})

test_that("re-expand cols after write", {

  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_with_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus",
    columns = list("guid", "parts", "partdetail")
  )

  expand_column(query, "partdetail")
  df <- response_data(query)
  testthat::expect_s3_class(df$partdetail[[1]], "data.frame")

  old_wd <- getwd()
  on.exit(setwd(old_wd))
  tmp <- tempfile()
  dir.create(tmp)
  setwd(tmp)

  with_mocked_bindings(
    save_response_csv(query, "save_csv_test", expanded=TRUE),
    write_csv = function(...) {}
  )

  df <- response_data(query)
  testthat::expect_s3_class(df$partdetail[[1]], "data.frame")

  # test that save_response_csv resets user's working directory
  testthat::expect_equal(basename(getwd()), basename(tmp))
})
