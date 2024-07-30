#' @title InfoRequestBuilder
#' @description
#' Builder for a request for query parameter or result parameter documentation
#' from Arctos. For a valid request, only one method to specify the type of
#' request can be called.
#'
#' @examples
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   all_query_params()$
#'   perform_request()
#'
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   all_result_params()$
#'   perform_request()
#'
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   by_query_category("parts")$
#'   perform_request()
#'
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   by_result_category("core")$
#'   perform_request()
#'
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   for_query_param("guid")$
#'   perform_request()
#'
#' results <- ArctosR::InfoRequestBuilder$new()$
#'   for_result_param("guid")$
#'   perform_request()
#'
#' @import R6
#' @export
InfoRequestBuilder <- R6::R6Class("InfoRequestBuilder",
  inherit = RequestBuilder,
  public  = list(
    #' @description Requests all parameters that can be used as part of a query.
    all_query_params = function() {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$all_query <- TRUE
      invisible(self)
    },

    #' @description Requests all columns that can be returned with a request.
    all_result_params = function() {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$all_result <- TRUE
      invisible(self)
    },

    #' @description Requests all query parameters by category.
    #'
    #' @param category Name of query category.
    by_query_category = function(category) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$query_category <- category
      invisible(self)
    },

    #' @description Requests all result parameters by category.
    #'
    #' @param category Name of result category.
    by_result_category = function(category) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$result_category <- category
      invisible(self)
    },

    #' @description Requests a specific query parameter.
    #'
    #' @param param Name of query parameter.
    for_query_param = function(param) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$query <- param
      invisible(self)
    },

    #' @description Requests a specific result parameter.
    #'
    #' @param param Name of result parameter.
    for_result_param = function(param) {
      if (!private$validate_all_empty()) {
        stop("can only specify one thing to request")
      }

      private$result <- param
      invisible(self)
    },

    #' @description Performs the request.
    #'
    #' @return [data.frame]
    perform_request = function() {
      if (private$validate_all_empty()) {
        stop("nothing specified")
      }

      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "about")

      if (!is.null(private$api_key)) {
        request$add_param(api_key = private$api_key)
      }

      if (private$debug_print) {
        print(request$url)
      }

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
        index <-which(response$json$RESULTS_PARAMS[,2] == private$result)
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
