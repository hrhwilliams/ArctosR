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
  response <- catalog_search_raw(list(...))
  json <- jsonlite::fromJSON(rawToChar(response$content))

  if (r$status_code == 200) {
    json
  } else {
    stop(sprintf("%s: %s", json$error, json$Message))
  }
}

catalog_about <- function() {
  response <- catalog_about_raw()
  json <- jsonlite::fromJSON(rawToChar(response$content))

  if (response$status_code == 200) {
    json
  } else {
    stop(sprintf("%s: %s", json$error, json$Message))
  }
}
