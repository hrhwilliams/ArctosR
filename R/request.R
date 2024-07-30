#' @title Request
#' @description An Arctos request. Not to be used directly.
#'
#' @import R6
#' @export
Request <- R6::R6Class("Request",
  public = list(
    endpoint = NULL,

    initialize = function(...) {
      private$url_params <- list(...)
      invisible(self)
    },

    with_endpoint = function(endpoint) {
      private$end_point <- endpoint
      invisible(self)
    },

    add_param = function(...) {
      private$url_params <- c(private$url_params, list(...))
      invisible(self)
    },

    perform = function() {
      if (is.null(private$end_point)) {
        stop("No endpoint given")
      }

      url <- build_url(private$end_point, private$url_params)
      raw_response <- perform_request(url)
      ArctosR::Response$new(raw_response, private$url_params)
    }
  ),
  private = list(
    url_params = list(),
    end_point = NULL
  )
)
