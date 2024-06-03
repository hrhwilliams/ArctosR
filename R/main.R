catalog_search <- function(queries) {
  url_query <- encode_params(queries)

  res <- curl::new_handle() |>
    curl::handle_setheaders("User-Agent"="ArctosR/0.1.0") |>
    curl::curl_fetch_memory(
      url = sprintf("https://arctos.database.museum/component/api/v2/catalog.cfc?%s", url_query)
    )
  res
}
