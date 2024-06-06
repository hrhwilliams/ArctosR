ARCTOS_URL <- "https://arctos.database.museum"
ARCTOS_API_URL <- "component/api/v2"
ARCTOSR_AGENT_STRING <- "ArctosR/0.1.0"

ARCTOSR_STATE <- list()

WARN_MISSING_API_KEY = "Your API key for Arctos is not currently registered.\nIf you have an API key from Arctos, please set it with the `set_api_key` function."

set_api_key <- function(key) {
  ARCTOSR_STATE$API_KEY <<- key
}

get_api_key <- function() {
  if (is.null(ARCTOSR_STATE$API_KEY)) {
    warning(WARN_MISSING_API_KEY)
    NULL
  } else {
    ARCTOSR_STATE$API_KEY
  }
}

perform_request <- function(url) {
  ARCTOSR_STATE$LAST_REQUEST <<- curl::curl_fetch_memory(new_arctosr_handle(), url = url)
  ARCTOSR_STATE$LAST_REQUEST
}

last_request <- function() {
  ARCTOSR_STATE$LAST_REQUEST
}

new_arctosr_handle <- function() {
  h <- curl::new_handle() |>
    curl::handle_setheaders("User-Agent"=ARCTOSR_AGENT_STRING)
}

build_url <- function(endpoint, queries = NULL) {
  if (is.null(queries)) {
    sprintf("%s/%s/%s", ARCTOS_URL, ARCTOS_API_URL, endpoint)
  } else {
    sprintf("%s/%s/%s?%s", ARCTOS_URL, ARCTOS_API_URL, endpoint, encode_params(queries))
  }
}

build_authenticated_url <- function(endpoint, queries = NULL) {
  queries$api_key <- get_api_key()
  build_url(endpoint, queries)
}

encode_params <- function(params) {
  qq <- c()

  for (i in 1:length(params)) {
    if (!is.null(names(params)) && nchar(names(params)[i]) > 0) {
      qq[i] <- paste(c(curl::curl_escape(names(params)[i]), curl::curl_escape(params[[i]])), collapse="=")
    } else {
      qq[i] <- curl::curl_escape(params[[i]])
    }
  }

  paste(qq, collapse="&")
}
