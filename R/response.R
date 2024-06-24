#' @title ArctosResponse
#' @description Response returned from Arctos
#'
#' @imports R6, jsonlite
#' @export
Response <- R6::R6Class("Response",
  public = list(
    #' @description Creates an Arctos response object from a curl response
    #'
    #' @params response (`list`), url_params (`list`)
    #' @return [Response].
    initialize = function(raw_response, url_params) {
      private$url <- raw_response$url
      private$url_params <- url_params
      private$api_key <- url_params$api_key
      private$status_code <- raw_response$status_code
      private$type <- raw_response$type
      private$headers <- rawToChar(raw_response$headers)
      private$content <- rawToChar(raw_response$content)

      json <- parse_response(raw_response)
      private$total_records <- json$recordsTotal
      private$downloaded_records <- length(json$DATA$DATA)
      private$tbl <- json$tbl
      private$data <- as.data.frame(json$DATA)
    },

    #' @description Requests more records from Arctos
    #'
    #' @param count (`integer`)
    #' @return [Response].
    request_more = function(count) {
      url_params <- list(
        method = "getCatalogData", queryformat = "struct", api_key = private$api_key,
        tbl = private$tbl, start = private$downloaded_records, length = count)
      request_url <- build_url("catalog.cfc", url_params)
      raw_response <- perform_request(request_url)
      json <- parse_response(raw_response)

      private$data <- rbind(private$data, as.data.frame(json$DATA))

      invisible(self)
    }
  ),
  private = list(
    api_key = NULL,
    url = NULL,
    url_params = NULL,
    status_code = integer(0),
    type = NULL,
    headers = NULL,
    content = NULL,
    total_records = integer(0),
    downloaded_records = integer(0),
    tbl = NULL,
    data = NULL
  )
)
