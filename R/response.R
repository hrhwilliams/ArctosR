arctos_env <- new.env(parent = baseenv())

#' @title Response
#' @description Response returned from Arctos.
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    json = NULL,

    #' @description Creates an Arctos response object from a curl response.
    #'
    #' @param raw_response (`list`)
    #' @param url_params (`list`)
    #' @return [Response].
    initialize = function(raw_response, url_params) {
      private$url <- raw_response$url
      private$url_params <- url_params
      private$api_key <- url_params$api_key
      private$status_code <- raw_response$status_code
      private$type <- raw_response$type
      private$headers <- rawToChar(raw_response$headers)
      private$content <- rawToChar(raw_response$content)

      self$json <- parse_response(raw_response)
      if (is.null(self$json$error)) {
        private$total_records <- self$json$recordsTotal
        private$tbl <- self$json$tbl
        private$data <- as.data.frame(self$json$DATA)
        private$downloaded_records <- nrow(private$data)
        private$index <- private$downloaded_records
      } else {
        private$error = self$json$Message
      }
    },

    was_success = function() {
      private$status_code == 200
    },

    get_table_id = function() {
      private$tbl
    },

    get_api_key = function() {
      private$api_key
    },

    get_total_record_count = function() {
      private$total_records
    },

    get_index = function() {
      private$index
    },

    set_index = function(index) {
      private$index <- index
      invisible(self)
    },

    get_record_count = function() {
      nrow(private$data)
    },

    #' @description Returns any API error returned from Arctos.
    get_error = function() {
      private$error
    },

    #' @description Returns the request URL for debugging purposes.
    get_url = function() {
      private$url
    },

    #' @description Writes the data in the response object to a CSV file.
    save_csv = function(path) {
      if (is.null(private$data)) {
        stop("No data to export.")
      }

      file_ext <- tail(unlist(strsplit(path, "[.]")), n=1)
      if (file_ext != "csv") {
        write.csv(private$data, sprintf("%s.csv", path))
      } else {
        write.csv(private$data, path)
      }
    },

    save_dataframe = function(path) {
      if (is.null(private$data)) {
        stop("No data to export.")
      }
    },

    #' @description Store the entire response object as an .RData file which can
    #' be later loaded using Response$from_file
    #'
    #' @param path (`string`)
    save_object = function(path) {
      arctos_env$arctosr_response <- self

      file_ext <- tail(unlist(strsplit(path, "[.]")), n=1)
      if (file_ext != "RData") {
        save(arctosr_response, file = sprintf("%s.RData", path), envir = arctos_env)
      } else {
        save(arctosr_response, file = path, envir = arctos_env)
      }
    },

    #' @description Returns data from the response as a dataframe object.
    #'
    #' @return (`data.frame`).
    as_data_frame = function() {
      private$data
    },

    #' @description Expand a column of nested JSON tables in the response to a
    #' list of dataframes. This does not modify the original data.
    #'
    #' @param col (`string`)
    expand_col = function(column) {
      if (is.null(private$data)) {
        stop("No data to expand")
      }

      lapply(private$data[[column]], function (j) {
        jsonlite::fromJSON(j, simplifyDataFrame=T)
      })
    }
  ),

  private = list(
    api_key = NULL,
    url = NULL,
    url_params = NULL,
    status_code = integer(0),
    error = NULL,
    type = NULL,
    headers = NULL,
    content = NULL,
    index = integer(0),
    total_records = integer(0),
    downloaded_records = integer(0),
    tbl = NULL,
    data = NULL,
    timestamp = NULL
  )
)

Response$from_file <- function(path) {
  load(path, envir=arctos_env)
  arctos_env$arctosr_response$clone(deep=T)
}
