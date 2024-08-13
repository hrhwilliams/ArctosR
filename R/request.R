#' @title Request
#' @description A generic Arctos request. Not intended to be used directly. See
#' InfoRequestBuilder and CatalogRequestBuilder.
#'
#' @import R6
#' @export
Request <- R6::R6Class("Request",
  public = list(
    with_endpoint = function(endpoint) {
      private$end_point <- endpoint
      invisible(self)
    },

    add_param = function(...) {
      private$url_params <- c(private$url_params, list(...))
      invisible(self)
    },

    add_params = function(params) {
      private$url_params <- c(private$url_params, params)
      invisible(self)
    },

    perform = function() {
      if (is.null(private$end_point)) {
        stop("No endpoint given")
      }

      raw_response <- perform_request(self$url)
      ArctosR::Response$new(raw_response, private$url_params)
    }
  ),
  active = list(
    url = function() {
      build_url(private$end_point, private$url_params)
    }
  ),
  private = list(
    url_params = list(),
    end_point = NULL
  )
)
