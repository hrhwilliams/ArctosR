#' @title InfoRequestBuilder
#'
#' @import R6
#' @export
InfoRequestBuilder <- R6::R6Class("InfoRequestBuilder",
  inherit = RequestBuilder,
  public  = list(
    all_query_params = function() {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$all_query <- TRUE
      invisible(self)
    },

    all_result_params = function() {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$all_result <- TRUE
      invisible(self)
    },

    by_query_category = function(category) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$query_category <- category
      invisible(self)
    },

    by_result_category = function(category) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$result_category <- category
      invisible(self)
    },

    for_query_param = function(param) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$query <- param
      invisible(self)
    },

    for_result_param = function(param) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$result <- param
      invisible(self)
    },

    perform_request = function() {
      if (private$validate_all_empty()) {
        stop("nothing specified")
      }

      request <- ArctosR::Request$new(method = "about")
      request$endpoint <- "catalog.cfc"
      response <- request$perform()

      if (!response$was_success()) {
        stop(response$get_error())
      }

      if (private$all_query) {
        response$json$QUERY_PARAMS
      } else if (private$all_result) {
        response$json$RESULTS_PARAMS
      } else if (!is.null(private$query_category)) {
        response$json$
          QUERY_PARAMS[response$json$QUERY_PARAMS$category == private$query_category,]
      } else if (!is.null(private$result_category)) {
        response$json$
          RESULTS_PARAMS[response$json$RESULTS_PARAMS$category == private$result_category,]
      } else if (!is.null(private$query)) {
        index <-which(response$json$QUERY_PARAMS[,2] == private$query)
        if (length(index) == 0) {
          stop("no such query parameter")
        } else {
          response$json$QUERY_PARAMS[index,]
        }
      } else if (!is.null(private$result)) {
        index <-which(response$json$RESULTS_PARAMS[,2] == private$query)
        if (length(index) == 0) {
          stop("no such result parameter")
        } else {
          response$json$RESULTS_PARAMS[index,]
        }
      }
    }
  ),
  private = list(
    all_query = FALSE,
    all_result = FALSE,
    query_category = NULL,
    result_category = NULL,
    query = NULL,
    result = NULL,

    validate_all_empty = function() {
      !private$all_query &&
      !private$all_result &&
      is.null(private$query_category) &&
      is.null(private$result_category) &&
      is.null(private$query) &&
      is.null(private$result)
    }
  )
)
