catalog_search_raw <- function(queries) {
  queries$method <- "getCatalogData"
  queries$queryformat <- "struct"

  url <- build_authenticated_url("catalog.cfc", queries)
  curl::curl_fetch_memory(new_arctosr_handle(), url = url)
}

catalog_about_raw <- function() {
  url <- build_url("catalog.cfc", list("method" = "about"))
  curl::curl_fetch_memory(new_arctosr_handle(), url = url)
}

catalog_search <- function(...) {
  r <- catalog_search_raw(list(...))

  if (r$status_code == 200) {
    jsonlite::parse_json(rawToChar(r$content))
  } else {
    r
    # report error
  }
}

catalog_about <- function() {
  r <- catalog_about_raw()

  if (r$status_code == 200) {
    jsonlite::parse_json(rawToChar(r$content))
  } else {
    r
    # report error
  }
}
