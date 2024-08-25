#' @importFrom jsonlite fromJSON
#' @importFrom curl handle_setheaders
#' @importFrom curl curl_fetch_memory
#' @importFrom curl curl_escape

ARCTOS_URL <- "https://arctos.database.museum"
ARCTOS_API_URL <- "component/api/v2"
ARCTOSR_AGENT_STRING <- "ArctosR/0.1.0"
PACKAGE_API_KEY <- "DC552937-1341-40FF-BB2EA9A0B4347A82"

WARN_MISSING_API_KEY = "Your API key for Arctos is not currently registered.\nIf you have an API key from Arctos, please set it with the `set_api_key` function."

new_arctosr_handle <- function() {
  h <- curl::new_handle() |>
    handle_setheaders("User-Agent"=ARCTOSR_AGENT_STRING)
}

perform_request <- function(url) {
  curl_fetch_memory(new_arctosr_handle(), url = url)
}

parse_response <- function(raw_response) {
  if (raw_response$type == "application/json;charset=UTF-8") {
    return(fromJSON(rawToChar(raw_response$content), simplifyDataFrame=T))
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
      qq[i] <- paste(c(curl_escape(names(params)[i]), curl_escape(params[[i]])), collapse="=")
    } else {
      qq[i] <- curl_escape(params[[i]])
    }
  }

  paste(qq, collapse=collapse)
}

encode_params <- function(params) {
  encode_list(params, "&")
}

encode_win_filename <- function(path) {
  "\\/:*?\"<>|"
  gsub("[\\\\/:*?\"<>|]", "-", path)
}

file_extension <- function(file_path) {
  split <- unlist(strsplit(file_path, "[.]"))
  if (length(split) < 2) {
    return(NULL)
  }
  return(tail(split, n=1))
}

file_name <- function(file_path) {
  return(head(unlist(strsplit(file_path, "[.]")), n=1))
}

get_header <- function(headers, search) {
  for (header in strsplit(headers, "\r\n", fixed=TRUE)[[1]]) {
    if (tolower(substr(header, 1, nchar(search))) == tolower(search)) {
      return(substr(header, nchar(search) + 1, nchar(header)))
    }
  }

  return(NULL)
}

is_class <- function(object, class) {
  return(class(object)[1] == class)
}
