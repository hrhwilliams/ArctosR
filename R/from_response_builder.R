#' @title FromResponseRequestBuilder
#' @description Builder for the case where a request is made with the context
#' of a previous response.
#'
#' @examples
#' response <- ArctosR::CatalogRequestBuilder$new()$
#'   default_api_key()$
#'   set_query(scientific_name="Canis lupus", guid_prefix="MSB:Mamm")$
#'   set_columns("guid", "parts", "partdetail")$
#'   set_limit(500)$
#'   perform_request()
#'
#' response <- ArctosR::CatalogRequestBuilder$new()$
#'   from_previous_response(response)$
#'   request_more(500)$
#'   perform_request()
#'

#' @import R6
#' @export
FromResponseRequestBuilder <- R6::R6Class("FromResponseRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    initialize = function(response) {
      private$response <- response
      private$api_key <- response$get_api_key()
      invisible(self)
    },

    #' @description Request at most `count` more records from this response's
    #' original query
    #'
    #' @param count number of additional records to request
    #' @return FromResponseRequestBuilder
    request_more = function(count) {
      private$more <- count
      invisible(self)
    },

    add_column = function(col) {
      invisible(self)
    },

    #' @description Perform the request.
    #' @return Response
    perform_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(api_key = private$api_key)

      if (private$more > 0) {
        request <- request$add_param(tbl = private$response$get_table_id())$
          add_param(start = private$response$get_index())$
          add_param(length = private$more)
      }

      if (private$debug_print) {
        print(request$url)
      }

      response <- request$perform()
      response$set_index(response$get_index() + private$response$get_index())
      response
    }
  ),
  private = list(
    response = NULL,
    more = 0
  )
)
