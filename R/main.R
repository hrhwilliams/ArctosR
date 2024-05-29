library(curl)

arctosr_req <- function() {
  res <- new_handle() |>
    handle_setheaders("User-Agent"="ArctosR") |>
    curl_fetch_memory(url = "https://arctos.database.museum/")
  res
}

res <- arctosr_req()
str(res)
