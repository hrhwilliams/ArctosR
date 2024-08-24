#' @title Metadata
#' @description Metadata for a specific HTTP response from Arctos.
#'
#' @import R6
#' @export
Metadata <- R6::R6Class("Metadata",
  public = list(
    status_code = 0,
    response_type = NULL,
    response_headers = NULL,
    arctos_timestamp = NULL,
    index_start = 0, # if successful, what indices of the entire response correspond to this response
    index_stop = 0
  ),
  active = list(
    index_range = function() {
      return(c(index_start, index_stop))
    }
  )
)
