#' @title ArctosResponse
#' @description Response returned from Arctos
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    #' @description Creates response object
    #'
    #' @return [Response].
    initialize = function() {

    }
  ),
  private = list(
    status_code = integer(0)
  )
)
