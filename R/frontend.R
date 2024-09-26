#' @title get_query_parameters
#' @description
#' Request a data frame containing a list of all valid query parameters for
#' querying Arctos. The returned columns are: `display, obj_name, category,
#' subcategory, description`. All entries in obj_name are valid parameters to
#' pass to \code{\link{get_records}} as keys.
#'
#' @usage get_query_parameters()
#' @returns Data frame listing valid query parameters and associated
#' description and category
#'
#' @export
get_query_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    build_request()
  response <- q$perform()
  return(response$content$QUERY_PARAMS)
}

#' @title get_result_parameters
#' @description
#' Request a data frame containing a list of all valid result columns to request
#' from Arctos. The returned columns are: `display, obj_name, query_cost,
#' category, description, default_order`. The names in obj_name are passed to
#' \code{\link{get_records}} in the `columns` parameter as a `list`.
#'
#' @usage get_result_parameters()
#' @returns Data frame listing valid result columns and associated
#' description and category
#'
#' @export
get_result_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    build_request()
  response <- q$perform()
  return(response$content$RESULTS_PARAMS)
}

#' @title get_record_count
#' @description
#' Request from Arctos the total number of records that match a specific query.
#' A list of possible query keys can be obtained from the output of
#' \code{\link{get_query_parameters}}.
#'
#' @usage get_record_count(..., api_key = NULL)
#' @param ... Query parameters and their values to pass to Arctos to search.
#' For example, `scientific_name = "Canis lupus"``
#' @param api_key The API key to use for this request. If NULL, the package's
#' default API key is used.
#' @returns The number of records matching the given query, as an integer.
#'
#' @export
get_record_count <- function(..., api_key = NULL) {
  q <- Query$new()
  q$catalog_request()$
    set_query(...)$
    set_limit(1)
  response <- q$perform(api_key)

  return(response$content$recordsTotal)
}

#' @title get_records
#' @description
#' Make a request to Arctos to return a table with the columns specified in the
#' list passed as `columns` of all records matching a query.
#' A list of possible query keys can be obtained from the output of
#' \code{\link{get_query_parameters}}.
#'
#' @usage get_records(..., api_key = NULL, columns = NULL, limit = NULL, all_records = FALSE)
#' @param ... Query parameters and their values to pass to Arctos to search.
#' For example, `scientific_name = "Canis lupus"`
#' @param api_key The API key to use for this request. If NULL, the package's
#' default API key is used.
#' @param columns A list of columns to be returned in the table of records
#' to be downloaded from Arctos.
#' @param limit The maximum number of records to download at one time. Default
#' is 100.
#' @param all_records If true, continue to request more records from Arctos
#' until all records matching the query have been downloaded.
#'
#' @returns A query object consisting of metadata for each request sent to
#' Arctos to fulfil the user's query, and a data frame of records.
#'
#' @export
get_records <- function(..., api_key = NULL, columns = NULL, limit = NULL, all_records = FALSE) {
  query <- Query$new()
  builder <- query$catalog_request()

  if (!missing(...)) {
    builder$set_query(...)
  } else {
    stop("Requires at least one query parameter to be defined.")
  }

  if (!is.null(columns)) {
    do.call(builder$set_columns, columns)
    # builder$set_columns(columns)
  }

  if (!is.null(limit)) {
    builder$set_limit(limit)
  }

  query$perform(api_key)

  if (all_records) {
    repeat {
      query$from_response_request()$
        request_more(100)

      if(is.null(query$perform())) {
        break
      }
    }
  }

  return(query)
}

#' @title expand_column
#' @description
#' Expand a column in the records if the data in that column is a JSON formatted
#' table.
#'
#' @param query The query object whose records contain a column to be expanded.
#' @param column_name The name of the column to be expanded.
#'
#' @usage expand_column(query, column_name)
#' @returns Nothing.
#'
#' @export
expand_column <- function(query, column_name) {
  query$expand_col(column_name)
}

#' @title response_data
#' @description
#' Obtain just the dataframe from a successful query.
#'
#' @usage response_data(query)
#' @param query The query object to extract the dataframe from.
#' @returns A data frame
#'
#' @export
response_data <- function(query) {
  return(query$df)
}

#' @title save_response_rds
#' @description
#' Save the query object as an RDS file which stores the entire state of the
#' query and can be loaded at a later time.
#'
#' @usage save_response_rds(query, filename)
#' @param query The query object to be saved.
#' @param filename Name of the file to be saved.
#' @returns Nothing.
#'
#' @export
save_response_rds <- function(query, filename) {
  saveRDS(query, filename)
}

#' @title read_response_rds
#' @description
#' Load in a query object saved to an RDS file
#'
#' @usage read_response_rds(filename)
#' @param filename The file to load in.
#' @returns A query object
#'
#' @export
read_response_rds <- function(filename) {
  readRDS(filename)
}

#' @title save_response_csv
#' @description
#' Save the records inside the query object as a CSV file, optionally alongside
#' metadata relating to the requests made to download the data.
#'
#' @usage save_response_csv(query, filename, expanded = FALSE, with_metadata = TRUE)
#' @param query The query object to be saved
#' @param filename Name of the file to be saved.
#' @param expanded Some columns from Arctos are themselves tables, so to accurately
#' represent the structure of the data, these inner tables can be saved as separate
#' CSVs that are named according to which record they belong. Setting this option
#' to TRUE will create a folder of CSVs representing hierarchical data.
#' @param with_metadata Whether to save the metadata of the response as a JSON
#' file along side the CSV or folder of CSVs.
#'
#' @export
save_response_csv <- function(query, filename, expanded = FALSE, with_metadata = TRUE) {
  query$save_records_csv(filename, expanded = expanded)

  if (with_metadata) {
    query$save_metadata_json(filename)
  }
}
