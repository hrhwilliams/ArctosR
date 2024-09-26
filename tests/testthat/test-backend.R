library(ArctosR)

test_that("build_url", {
  testthat::expect_equal(
    build_url('catalog.cfc', c(method='getCatalogData', queryformat='struct', scientific_name='Canis lupus', guid_prefix="MSB:Mamm", length=50)),
    "https://arctos.database.museum/component/api/v2/catalog.cfc?method=getCatalogData&queryformat=struct&scientific_name=Canis%20lupus&guid_prefix=MSB%3AMamm&length=50"
  )
})

test_that("file extension", {
  testthat::expect_equal(file_extension("example.csv"),  "csv")
  testthat::expect_equal(file_extension("example.json"), "json")
})

test_that("file extension empty", {
  testthat::expect_equal(file_extension("example"), NULL)
})

test_that("file name", {
  testthat::expect_equal(file_name("example.csv"),  "example")
  testthat::expect_equal(file_name("example.json"), "example")
})
