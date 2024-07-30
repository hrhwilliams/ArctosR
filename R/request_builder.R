#' @title RequestBuilder
#' @description A builder for a generic Arctos request. Not to be used directly.
#'
#' @import R6
#' @export
RequestBuilder <- R6::R6Class("RequestBuilder",
  public = list(
    set_api_key = function(api_key) {
      private$api_key <- api_key
      invisible(self)
    },

    default_api_key= function() {
      private$api_key <- PACKAGE_API_KEY
      invisible(self)
    },

    perform_request = function() {
      stop("unable to perform request for generic builder")
    }
  ),
  private = list(
    api_key = NULL
  )
)

