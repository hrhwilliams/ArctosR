#' @title Request
#' @description A generic Arctos request. Not intended to be used directly. See
#' InfoRequestBuilder and CatalogRequestBuilder.
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @export
Request <- R6::R6Class("Request",
  public = list(
    params = NULL,
    end_point = NULL,
    timestamp = NULL,

    with_endpoint = function(endpoint) {
      self$end_point <- tolower(endpoint)
      return(invisible(self))
    },

    add_param = function(...) {
      params <- list(...)

      if (!is.null(params$api_key)) {
        stop("Set the API key for this request only when calling $perform.")
      }

      self$params <- c(self$params, params)
      return(invisible(self))
    },

    add_params = function(l) {
      params <- l

      if (!is.null(params$api_key)) {
        stop("Set the API key for this request only when calling $perform.")
      }

      self$params <- c(self$params, params)
      return(invisible(self))
    },

    serialize = function() {
      stop("Unimplemented.")
    },

    perform = function(api_key = NULL) {
      if (is.null(self$end_point)) {
        stop("No endpoint given.")
      }

      if (!is.null(api_key)) {
        self$params$api_key <- api_key
      } else {
        self$params$api_key <- PACKAGE_API_KEY
      }

      raw_response <- perform_request(self$url)
      self$timestamp <- Sys.time()
      attr(self$timestamp, "tzone") <- "GMT"
      self$params$api_key <- NULL

      return(ArctosR::Response$new(self, raw_response))
    }
  ),
  active = list(
    url = function() {
      return(build_url(self$end_point, self$params))
    }
  )
)
