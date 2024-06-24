#' @title ArctosResponse
#' @description Response returned from Arctos
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    #' @description Creates an Arctos response object from a curl response
    #'
    #' @param response (`list`) curl response
    #' @return [Response].
    initialize = function(response) {
      private$url <- response$url
      private$status_code <- response$status_code
      private$type <- response$type
      private$headers <- rawToChar(response$headers)
      private$content <- rawToChar(response$content)
    }
  ),
  private = list(
    url = NULL,
    status_code = integer(0),
    type = NULL,
    headers = NULL,
    content = NULL
  )
)
