# ArctosR
# Copyright (C) 2024-2025  Harlan Williams
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @importFrom jsonlite fromJSON
#' @importFrom curl handle_setheaders
#' @importFrom curl curl_fetch_memory
#' @importFrom curl curl_escape
#' @importFrom utils head
#' @importFrom utils tail

ARCTOS_URL <- "https://arctos.database.museum"
ARCTOS_API_URL <- "component/api/v2"
ARCTOSR_AGENT_STRING <- "ArctosR/0.1.3"
PACKAGE_API_KEY <- NULL # default package API key has been discontinued

WARN_MISSING_API_KEY <- "Your API key for Arctos is not currently registered.\nIf you have an API key from Arctos, please set it with the `set_api_key` function."

new_arctosr_handle <- function() {
  h <- curl::new_handle() |>
    handle_setheaders("User-Agent" = ARCTOSR_AGENT_STRING)
}

perform_request <- function(url) {
  raw <- curl_fetch_memory(url, handle = new_arctosr_handle())
  arctos_response(
    status_code = raw$status_code,
    type = raw$type,
    date_header = get_header(rawToChar(raw$headers), "Date: "),
    body = rawToChar(raw$content)
  )
}

arctos_response <- function(status_code, type, date_header, body) {
  is_json <- !is.null(type) && grepl("application/json", type, fixed = TRUE)
  list(
    status_code = status_code,
    type = type,
    arctos_timestamp = as.POSIXct(date_header, format = "%a, %d %b %Y %H:%M:%S GMT", tz = "GMT"),
    content = if (is_json) fromJSON(body, simplifyDataFrame = TRUE) else NULL
  )
}

build_url <- function(endpoint, queries = NULL) {
  if (is.null(queries)) {
    sprintf("%s/%s/%s", ARCTOS_URL, ARCTOS_API_URL, endpoint)
  } else {
    sprintf("%s/%s/%s?%s", ARCTOS_URL, ARCTOS_API_URL, endpoint, encode_params(queries))
  }
}

get_api_key <- function(callee_name, api_key) {
  if (is.null(api_key)) {
    api_key <- Sys.getenv("ARCTOSR_API_KEY")

    if (api_key == "") {
      stop(sprintf(
        "ARCTOSR_API_KEY is not set in your .Renviron.  Either set it with `usethis::edit_r_environ()`, or pass in your API key directly via the `api_key` parameter, e.g., as `%s(..., api_key=\"8acd28be-e559-485c-870e-374fa4a6730e\")`",
        callee_name
      ))
    }
  }

  return(api_key)
}

encode_list <- function(params, collapse) {
  qq <- c()

  for (i in 1:length(params)) {
    if (!is.null(names(params)) && nchar(names(params)[i]) > 0) {
      qq[i] <- paste(c(curl_escape(names(params)[i]), curl_escape(params[[i]])), collapse = "=")
    } else {
      qq[i] <- curl_escape(params[[i]])
    }
  }

  paste(qq, collapse = collapse)
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
  return(tail(split, n = 1))
}

file_name <- function(file_path) {
  return(head(unlist(strsplit(file_path, "[.]")), n = 1))
}

get_header <- function(headers, search) {
  for (header in strsplit(headers, "\r\n", fixed = TRUE)[[1]]) {
    if (tolower(substr(header, 1, nchar(search))) == tolower(search)) {
      return(substr(header, nchar(search) + 1, nchar(header)))
    }
  }

  return(NULL)
}

is_class <- function(object, class) {
  return(class(object)[1] == class)
}

write_csv <- function(...) {
  utils::write.csv(...)
}
