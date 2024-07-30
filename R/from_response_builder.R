#' @title FromResponseRequestBuilder

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

    request_more = function(count) {
      private$more <- count
      invisible(self)
    },

    perform_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(api_key = private$api_key)

      if (private$more > 0) {
        request <- request$add_param(tbl = response$get_table_id())$
          add_param(start = response$get_record_count())$
          add_param(length = private$more)
      }

      request$perform()
    }
  ),
  private = list(
    response = NULL,
    more = 0
  )
)
