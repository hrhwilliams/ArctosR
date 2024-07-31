#' @title RequestBuilder
#' @description A builder for a generic Arctos request. Not to be used directly.
#'
#' @import R6
#' @export
RequestBuilder <- R6::R6Class("RequestBuilder",
  public = list(
    #' @description Set the API key for this request
    #'
    #' @param api_key API key in string format.
    set_api_key = function(api_key) {
      private$api_key <- api_key
      invisible(self)
    },

    #' @description Turn on printing of debug information.
    debug = function() {
      private$debug_print <- TRUE
      invisible(self)
    },

    #' @description Use the package's default API key for this request.
    default_api_key= function() {
      private$api_key <- PACKAGE_API_KEY
      invisible(self)
    },

    perform_request = function() {
      stop("Unimplemented for this type")
    }
  ),
  private = list(
    api_key = NULL,
    debug_print = FALSE
  )
)


