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
      return(invisible(self))
    },

    #' @description Sets the query parameters to use to search Arctos.
    #'
    #' @param query (`list`).
    #' @return [CatalogRequestBuilder].
    set_query = function(...) {
      private$query <- list(...)
      return(invisible(self))
    },

    #' @description Set parts to query over.
    #'
    #' @param parts (`list`).
    #' @return [CatalogRequestBuilder].
    set_parts = function(...) {
      private$parts <- list(...)
      return(invisible(self))
    },

    #' @description Set attributes to query over.
    #'
    #' @param attributes (`list`).
    #' @return [CatalogRequestBuilder].
    set_attributes = function(...) {
      private$attributes <- list(...)
      return(invisible(self))
    },

    #' @description Set components to query over.
    #'
    #' @param components (`list`).
    #' @return [CatalogRequestBuilder].
    set_components = function(...) {
      private$components <- list(...)
      return(invisible(self))
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param cols (`list`).
    #' @return [CatalogRequestBuilder].
    set_columns = function(...) {
      private$cols <- list(...)
      return(invisible(self))
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param cols (`list`).
    #' @return [CatalogRequestBuilder].
    set_columns_list = function(l) {
      private$cols <- l
      return(invisible(self))
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
    build_request = function() {
      if (is.null(private$query)) {
        stop("Unable to build request: No query parameters specified.")
      }

      url_params <- list()
      url_params <- c(url_params, private$query)

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

      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(length = private$limit)$
        add_params(url_params)

      return(request)
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
