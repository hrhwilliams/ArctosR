catalog_search_raw <- function(queries) {
  queries$method <- "getCatalogData"
  queries$queryformat <- "struct"

  url <- build_authenticated_url("catalog.cfc", queries)
  perform_request(url)
}

catalog_about_raw <- function() {
  url <- build_url("catalog.cfc", list("method" = "about"))
  perform_request(url)
}

catalog_search <- function(...) {
  response <- catalog_search_raw(list(...))
  json <- jsonlite::fromJSON(rawToChar(response$content))

  if (response$status_code == 200) {
    json
  } else {
    if (!(is.null(json$error) || is.null(json$Message))) {
      stop(sprintf("HTTP %d %s: %s", response$status_code, json$error, json$Message))
    } else {
      stop(sprintf("HTTP %d response from Arctos", response$status_code))
    }
  }
}

catalog_about <- function() {
  response <- catalog_about_raw()
  json <- jsonlite::fromJSON(rawToChar(response$content))

  if (response$status_code == 200) {
    json
  } else {
    if (!(is.null(json$error) || is.null(json$Message))) {
      stop(sprintf("HTTP %d %s: %s", response$status_code, json$error, json$Message))
    } else {
      stop(sprintf("HTTP %d response from Arctos", response$status_code))
    }
  }
}
