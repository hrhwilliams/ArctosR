#' @title FromResponseRequestBuilder
#' @description Builder for the case where a request is made with the context
#' of a previous response.
#'
#' @import R6
#' @export
FromResponseRequestBuilder <- R6::R6Class("FromResponseRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    initialize = function(response, records) {
      private$table_id <- records$table_id
      private$start <- response$stop_index + 1
      return(invisible(self))
    },

    #' @description Request at most `count` more records from this response's
    #' original query
    #'
    #' @param count number of additional records to request
    #' @return FromResponseRequestBuilder
    request_more = function(count) {
      private$more <- count
      return(invisible(self))
    },

    #' @description Perform the request.
    #' @return Request
    build_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(tbl = private$table_id)$
        add_param(start = private$start)$
        add_param(length = private$more)
      return(request)
    }
  ),
  private = list(
    response = NULL,
    start = 1,
    table_id = NULL,
    more = 100
  )
)
