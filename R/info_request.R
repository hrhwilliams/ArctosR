#' @title InfoRequestBuilder
#' @description
#' Builder for a request for query parameter or result parameter documentation
#' from Arctos. For a valid request, only one method to specify the type of
#' request can be called.
#'
#' @import R6
#' @export
InfoRequestBuilder <- R6::R6Class("InfoRequestBuilder",
  inherit = RequestBuilder,
  public  = list(
    build_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "about")

      return(request)
    }
  )
)
