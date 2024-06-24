#' @title RequestBuilder
#' @description An Arctos Request
#'
#' @examples
#' response <- ArctosR::RequestBuilder$new()
#'   $set_api_key(API_KEY)
#'   $set_limit(500)
#'   $set_query(guid_prefix="MSB:Mamm", locality="New Mexico")
#'   $set_parts(has_tissue)
#'   $set_attributes(detected="Orthohauntavirus")
#'   $perform_request()
#'
#' @import R6
#' @export
RequestBuilder <- R6::R6Class("RequestBuilder",
  public = list(
    #' @description Sets the Arctos API key to be used for this request.
    #'
    #' @param key (`string`).
    #' @return [RequestBuilder].
    set_api_key = function(key) {
      private$api_key <- key
      invisible(self)
    },

    #' @description Sets the limit on how many records to initially request
    #' from Arctos.
    #'
    #' @param limit (`integer(1)`).
    #' @return [RequestBuilder].
    set_limit = function(limit) {
      private$limit <- limit
      invisible(self)
    },

    #' @description Sets the query parameters to use to search Arctos
    #'
    #' @param query (`list`).
    #' @return [RequestBuilder].
    set_query = function(query) {
      private$query <- query
      invisible(self)
    },

    #' @description Set parts to query over
    #'
    #' @param parts (`list`).
    #' @return [RequestBuilder].
    set_parts = function(parts) {
      private$parts <- parts
      invisible(self)
    },

    #' @description Set attributes to query over
    #'
    #' @param attributes (`list`).
    #' @return [RequestBuilder].
    set_attributes = function(attributes) {
      private$attributes <- attributes
      invisible(self)
    },

    #' @description Sets the columns in the dataframe returned by Arctos
    #'
    #' @param cols (`list`).
    #' @return [RequestBuilder].
    set_columns = function(cols) {
      private$cols <- cols
      invisible(self)
    },

    #' @description Builds and sends the request to Arctos
    #'
    #' @return [RequestBuilder]
    perform_request = function() {
      url_params <- list()
      url_params$method <- "getCatalogData"
      url_params$queryformat <- "struct"
      url_params$api_key <- private$api_key
      url_params$length  <- private$limit
      url_params <- c(url_params, private$query)
      # TODO research how to encode parts queries and attributes queries
      # url_params <- c(url_params, private$parts) ?
      # url_params <- c(url_params, private$attributes) ?
      url_params$cols <- private$cols

      private$request_url <- build_url("catalog.cfc", url_params)
      raw_response <- perform_request(self$request_url)
      Response$new(raw_response, url_params)
    }
  ),
  private = list(
    request_url = NULL,
    api_key = integer(0),
    limit = integer(1000),
    query = NULL,
    parts = NULL,
    attributes = NULL,
    cols = NULL
  )
)
