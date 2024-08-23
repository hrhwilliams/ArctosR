arctos_env <- new.env(parent = baseenv())

#' @title Response
#' @description Response returned from Arctos.
#'
#' @import R6
#' @importFrom jsonlite fromJSON
#' @export
Response <- R6::R6Class("Response",
  public = list(
    json = NULL,

    #' @description Creates an Arctos response object from a curl response.
    #'
    #' @param raw_response (`list`)
    #' @param url_params (`list`)
    #' @return [Response].
    initialize = function(raw_response, url_params, ...) {
      private$url <- raw_response$url
      private$url_params <- url_params
      private$api_key <- url_params$api_key
      private$status_code <- raw_response$status_code
      private$type <- raw_response$type
      private$headers <- rawToChar(raw_response$headers)
      private$content <- rawToChar(raw_response$content)
      private$extra_data <- list(...)

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

    get_metadata = function() {
      list(query = private$extra_data$query)
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

    #' @description
    #' Append the contents of one response object to this one if possible.
    append = function(other) {
      if (!is.null(other$get_error)) {
        stop("Cannot consolidate responses: other response is invalid.")
      }
      if (private$tbl != other$get_table_id()) {
        stop("Cannot consolidate responses: tables don't match.")
      }
      if (colnames(private$data) != colnames(other$as_data_frame())) {
        stop("Cannot consolidate responses: colnames don't match.")
      }
      # one response could have expanded cols and another could not
      # so unexpand to merge.
      # tbl being the same should mean recordCount wasn't invalidated
      private$data <- rbind(private$data, other$as_data_frame())
      private$timestamp <- c(private$timestamp, other$get_timestamp())
    },

    #' @description Writes the data in the response object to a CSV file.
    save_flat_csv = function(path) {
      if (is.null(private$data)) {
        stop("No data to export.")
      }

      for (column in names(private$expanded_cols)) {
        private$data[[column]] = private$expanded_cols[[column]]
      }

      file_ext <- tail(unlist(strsplit(path, "[.]")), n=1)
      if (file_ext != "csv") {
        write.csv(private$data, sprintf("%s.csv", path))
      } else {
        write.csv(private$data, path)
      }

      for (column in names(private$expanded_cols)) {
        self$expand_col(column)
      }
    },

    save_expanded_csvs = function(path) {
      if (is.null(private$data)) {
        stop("No data to export.")
      }

      if (dir.exists(path)) {
        stop("Directory already exists")
      }

      dir.create(path)
      setwd(path)

      recursive_write <- function(df, col_name_path) {
        col_types <- sapply(df, class)
        list_cols <- which(col_types == "list")
        exclude <- names(df) %in% names(list_cols)
        write.csv(df[!exclude], sprintf("%s.csv", encode_win_filename(col_name_path)))

        for (col in names(list_cols)) {
          for (row in 1:nrow(df)) {
            if (is.null(df[[col]][[row]])) {
              next
            }
            recursive_write(df[[col]][[row]], sprintf("%s_%s-%s", encode_win_filename(col_name_path),
              encode_win_filename(df[[1]][[row]]), col))
          }
        }
      }

      recursive_write(private$data, path)
      setwd("..")
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

      if (is.null(private$data[[column]])) {
        stop("No such column")
      }

      if (!(column %in% names(private$expanded_cols))) {
        private$expanded_cols = c(private$expanded_cols,
          setNames(list(private$data[[column]]), c(column))
        )
      }

      private$data[[column]] = lapply(private$data[[column]], function (j) {
        fromJSON(j, simplifyDataFrame=T)
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
    timestamp = NULL,
    expanded_cols = NULL,
    extra_data = NULL
  )
)

Response$from_file <- function(path) {
  load(path, envir=arctos_env)
  arctos_env$arctosr_response$clone(deep=T)
}
