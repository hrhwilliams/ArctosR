#' @title Metadata
#' @description Metadata for a specific HTTP response from Arctos.
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @export
Metadata <- R6::R6Class("Metadata",
  public = list(
    url = NULL,
    params = NULL,
    status_code = 0,
    system_timestamp = NULL,
    arctos_timestamp = NULL,
    timezone = "GMT",

    to_list = function() {
      return(list(
        url = self$url,
        params = self$params,
        status_code = self$status_code,
        system_timestamp = self$system_timestamp,
        arctos_timestamp = self$arctos_timestamp,
        timezone = self$timezone)
      )
    }
  )
)
