new_arctosr_handle <- function() {
  h <- curl::new_handle() |>
    curl::handle_setheaders("User-Agent"="ArctosR/0.1.0")
}

catalog_search <- function(queries) {
  url <- build_authenticated_url("catalog.cfc", queries)
  curl::curl_fetch_memory(new_arctosr_handle(), url = url)
}

catalog_about <- function() {
  url <- build_url("catalog.cfc", list("method" = "about"))
  curl::curl_fetch_memory(new_arctosr_handle(), url = url)
}
