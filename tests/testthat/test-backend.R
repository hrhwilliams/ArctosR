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

test_that("build_url", {
  testthat::expect_equal(
    build_url("catalog.cfc", c(method = "getCatalogData", queryformat = "struct", scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm", length = 50)),
    "https://arctos.database.museum/component/api/v2/catalog.cfc?method=getCatalogData&queryformat=struct&scientific_name=Canis%20lupus&guid_prefix=MSB%3AMamm&length=50"
  )
})

test_that("urlencode list", {
  encode_list(c(hi = "something", "bye", NULL), collapse = ",")
  testthat::expect_equal(
    encode_list(c(one = "one", two = "two"), collapse = "&"),
    "one=one&two=two"
  )
  testthat::expect_equal(
    encode_list(c("one", "two", "three"), collapse = "&"),
    "one&two&three"
  )
})

test_that("file extension", {
  testthat::expect_equal(file_extension("example.csv"), "csv")
  testthat::expect_equal(file_extension("example.json"), "json")
})

test_that("file extension empty", {
  testthat::expect_equal(file_extension("example"), NULL)
})

test_that("file name", {
  testthat::expect_equal(file_name("example.csv"), "example")
  testthat::expect_equal(file_name("example.json"), "example")
})

test_that("arctos_response parses JSON regardless of content-type spelling", {
  response <- arctos_response(200, "application/json; charset=utf-8", "Thu, 26 Sep 2024 01:58:51 GMT", '{"recordsTotal": 3}')
  testthat::expect_equal(response$content$recordsTotal, 3)
  testthat::expect_equal(format(response$arctos_timestamp, tz = "GMT"), "2024-09-26 01:58:51")

  html <- arctos_response(500, "text/html", "Thu, 26 Sep 2024 01:58:51 GMT", "<html></html>")
  testthat::expect_null(html$content)
})

test_that("api key is sent with the request but never stored on it", {
  sent_url <- NULL
  local_mocked_bindings(
    perform_request = function(url) {
      sent_url <<- url
      fixture_response("test_request_no_cols_part3")
    }
  )

  request <- Request$new()$with_endpoint("record.cfc")$add_param(method = "getData")
  response <- request$perform(api_key = "SECRET")

  testthat::expect_match(sent_url, "api_key=SECRET", fixed = TRUE)
  testthat::expect_null(request$params$api_key)
  testthat::expect_no_match(response$metadata$url, "SECRET", fixed = TRUE)
})
