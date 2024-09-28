library(ArctosR)

test_that("query info request", {
  q <- Query$new()
  request <- q$info_request()$
    build_request()

  testthat::expect_equal(request$end_point, "catalog.cfc")
  testthat::expect_equal(length(request$params), 1)
  testthat::expect_equal(request$params$method, "about")
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

test_that("get_records_no_cols", {
  local_mocked_bindings(
    perform_request = function(...) {
      return(readRDS("test_request_no_cols.rds"))
    }
  )

  query <- get_records(
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus"
  )

  df <- response_data(query)
  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(nrow(df), 50)
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
        return(NULL)
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
    guid_prefix = "MSB:Mamm", species = "Canis", genus = "lupus"
  )

  df <- response_data(query)
  testthat::expect_s3_class(df, "data.frame")
  testthat::expect_equal(sort(colnames(df)), sort(c("collection_object_id", "guid", "parts", "partdetail")))
  testthat::expect_equal(nrow(df), 50)
})
