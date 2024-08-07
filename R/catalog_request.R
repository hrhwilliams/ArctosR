#' @title CatalogRequestBuilder
#'
#' @examples
#' results <- ArctosR::CatalogRequestBuilder$new()$
#'   default_api_key()$
#'   set_query(scientific_name="Canis lupus")$
#'   set_columns("guid", "parts", "partdetail")$
#'   set_limit(50)$
#'   perform_request()
#'
#' @import R6
#' @export
CatalogRequestBuilder <- R6::R6Class("CatalogRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    #' @description Sets the limit on how many records to initially request
    #' from Arctos.
    #'
    #' @param limit (`integer(1)`).
    #' @return [CatalogRequestBuilder].
    set_limit = function(limit) {
      private$limit <- limit
      invisible(self)
    },

    #' @description Sets the query parameters to use to search Arctos.
    #'
    #' @param query (`list`).
    #' @return [CatalogRequestBuilder].
    set_query = function(...) {
      private$query <- list(...)
      invisible(self)
    },

    #' @description Set parts to query over.
    #'
    #' @param parts (`list`).
    #' @return [CatalogRequestBuilder].
    set_parts = function(...) {
      private$parts <- list(...)
      invisible(self)
    },

    #' @description Set attributes to query over.
    #'
    #' @param attributes (`list`).
    #' @return [CatalogRequestBuilder].
    set_attributes = function(...) {
      private$attributes <- list(...)
      invisible(self)
    },

    #' @description Set components to query over.
    #'
    #' @param components (`list`).
    #' @return [CatalogRequestBuilder].
    set_components = function(...) {
      private$components <- list(...)
      invisible(self)
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param cols (`list`).
    #' @return [CatalogRequestBuilder].
    set_columns = function(...) {
      private$cols <- list(...)
      invisible(self)
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param response a response object from a previous request
    #' @return [FromResponseRequestBuilder].
    from_previous_response = function(response) {
      FromResponseRequestBuilder$new(response)
    },

    #' @description Send a request for data to Arctos with parameters specified
    #' by the other methods called on this class.
    #'
    #' @return [Response].
    perform_request = function(response = NULL, status_code = 200) {
      url_params <- list()
      url_params$method <- "getCatalogData"
      url_params$queryformat <- "struct"
      url_params$api_key <- private$api_key
      url_params$length  <- private$limit

      url_params <- c(url_params, private$query)
      # TODO research how to encode parts queries and attributes queries
      # url_params <- c(url_params, private$parts) ?
      # url_params <- c(url_params, private$attributes) ?
      if (!is.null(private$cols)) {
        url_params$cols <- encode_list(private$cols, ",")
      }
      if (!is.null(private$parts)) {
        url_params$cols <- encode_list(private$parts, ",")
      }
      if (!is.null(private$attributes)) {
        url_params$cols <- encode_list(private$attributes, ",")
      }
      if (!is.null(private$components)) {
        url_params$cols <- encode_list(private$components, ",")
      }

      private$request_url <- build_url("catalog.cfc", url_params)

      if (!is.null(response)) {
        raw_response <- list()
        raw_response$url <- private$request_url
        raw_response$status_code <- status_code
        raw_response$type <- "application/json;charset=UTF-8"
        raw_response$content <- charToRaw(response)
        raw_response$headers <- charToRaw("headers")
      } else {
        raw_response <- perform_request(private$request_url)
      }

      Response$new(raw_response, url_params)
    },

    record_count = function() {
      private$limit <- 1
      response <- self$perform_request()
      response$get_total_record_count()
    }
  ),
  private = list(
    previous_response = NULL,
    request_url = NULL,
    limit = 100,
    query = NULL,
    parts = NULL,
    attributes = NULL,
    components = NULL,
    cols = NULL
  )
)
