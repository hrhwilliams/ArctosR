#' @title Response
#' @description Response returned from Arctos.
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    #' @description Creates an Arctos response object from a curl response.
    #'
    #' @param raw_response (`list`)
    #' @param url_params (`list`)
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
      if (is.null(json$error)) {
        private$total_records <- json$recordsTotal
        private$tbl <- json$tbl
        private$data <- as.data.frame(json$DATA)
        private$downloaded_records <- nrow(private$data)
      } else {
        private$error = json$Message
      }
    },

    #' @description Requests more records from Arctos.
    #'
    #' @param count (`integer`)
    #' @return [Response].
    request_more = function(count) {
      if (!is.null(private$error)) {
        stop("Response returned an error; unable to request data")
      }
      url_params <- list(
        method = "getCatalogData", queryformat = "struct", api_key = private$api_key,
        tbl = private$tbl, start = private$downloaded_records, length = count)
      request_url <- build_url("catalog.cfc", url_params)
      raw_response <- perform_request(request_url)
      json <- parse_response(raw_response)

      if (raw_response$status_code == 200) {
        private$data <- rbind(private$data, as.data.frame(json$DATA))
        private$downloaded_records <- nrow(private$data)
        return(invisible(self))
      } else {
        stop(sprintf("%s: %s", json$error, json$message))
      }
    },

    get_error = function() {
      private$error
    },

    get_url = function() {
      private$url
    },

    #' @description Returns data from the response as a dataframe object.
    #'
    #' @return (`data.frame`).
    as_data_frame = function() {
      private$data
    }
  ),
  private = list(
    api_key = NULL,
    url = NULL,
    url_params = NULL,
    status_code = integer(0),
    error = NULL,
    type = NULL,
    headers = NULL,
    content = NULL,
    total_records = integer(0),
    downloaded_records = integer(0),
    tbl = NULL,
    data = NULL,
    timestamp = NULL
  )
)
