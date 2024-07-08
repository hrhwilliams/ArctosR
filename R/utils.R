#' @import curl
#' @import jsonlite

ARCTOS_URL <- "https://arctos.database.museum"
ARCTOS_API_URL <- "component/api/v2"
ARCTOSR_AGENT_STRING <- "ArctosR/0.1.0"

WARN_MISSING_API_KEY = "Your API key for Arctos is not currently registered.\nIf you have an API key from Arctos, please set it with the `set_api_key` function."

new_arctosr_handle <- function() {
  h <- curl::new_handle() |>
    curl::handle_setheaders("User-Agent"=ARCTOSR_AGENT_STRING)
}

perform_request <- function(url) {
  curl::curl_fetch_memory(new_arctosr_handle(), url = url)
}

parse_response <- function(raw_response) {
  if (raw_response$type == "application/json;charset=UTF-8") {
    return(jsonlite::fromJSON(rawToChar(raw_response$content), simplifyDataFrame=T))
  } else {
    stop("Expected response in JSON format")
  }
}

build_url <- function(endpoint, queries = NULL) {
  if (is.null(queries)) {
    sprintf("%s/%s/%s", ARCTOS_URL, ARCTOS_API_URL, endpoint)
  } else {
    sprintf("%s/%s/%s?%s", ARCTOS_URL, ARCTOS_API_URL, endpoint, encode_params(queries))
  }
}

encode_list <- function(params, collapse) {
  qq <- c()

  for (i in 1:length(params)) {
    if (!is.null(names(params)) && nchar(names(params)[i]) > 0) {
      qq[i] <- paste(c(curl::curl_escape(names(params)[i]), curl::curl_escape(params[[i]])), collapse="=")
    } else {
      qq[i] <- curl::curl_escape(params[[i]])
    }
  }

  paste(qq, collapse=collapse)
}

encode_params <- function(params) {
  encode_list(params, "&")
}
