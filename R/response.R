#' @title Response
#' @description Response returned from Arctos.
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    request = NULL,
    metadata = NULL,
    response_type = NULL,
    content = NULL,
    start_index = 0,
    stop_index = 1,
    initialize = function(request, raw_response) {
      self$request <- request

      self$metadata <- ArctosR::Metadata$new()
      self$metadata$url <- request$url
      self$metadata$params <- request$params
      self$metadata$status_code <- raw_response$status_code
      self$metadata$system_timestamp <- request$timestamp
      self$metadata$arctos_timestamp <- as.POSIXct(
        get_header(rawToChar(raw_response$headers), "Date: "),
        format = "%a, %d %b %Y %H:%M:%S GMT"
      )

      self$response_type <- raw_response$type
      self$content <- parse_response(raw_response)
    },
    set_start_index = function(start) {
      self$start_index <- start
      self$stop_index <- self$stop_index + start
    },
    was_success = function() {
      return(self$metadata$status_code == 200)
    },
    is_empty = function() {
      return(length(self$content$DATA) == 0)
    },
    to_list = function() {
      return(list(
        metadata = self$metadata$to_list(),
        index_range = self$index_range
      ))
    },
    to_records = function(start = 0) {
      # grab records from content
      df <- as.data.frame(self$content$DATA)
      records <- ArctosR::Records$new(df, self$content$tbl)
      self$start_index <- start
      self$stop_index <- self$start_index + nrow(df) - 1
      return(records)
    }
  ),
  active = list(
    index_range = function() {
      return(c(self$start_index, self$stop_index))
    }
  )
)
