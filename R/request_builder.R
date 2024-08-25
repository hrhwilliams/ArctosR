#' @title RequestBuilder
#' @description A builder for a generic Arctos request. Not to be used directly.
#'
#' @import R6
#' @export
RequestBuilder <- R6::R6Class("RequestBuilder",
  public = list(
    #' @description Turn on printing of debug information.
    debug = function() {
      private$debug_print <- TRUE
      invisible(self)
    },

    build_request = function() {
      stop("Unimplemented for this type")
    }
  ),
  private = list(
    debug_print = FALSE
  )
)


