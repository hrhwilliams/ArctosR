#' @title Get parameters to perform queries
#'
#' @description
#' Request information about all valid query parameters for querying Arctos.
#'
#' @usage get_query_parameters()
#'
#' @returns
#' Data frame listing valid query parameters and associated description and
#' category. The returned columns are: `display`, `obj_name`, `category`,
#' `subcategory`, `description`. All entries in `obj_name` are valid parameters
#' to pass to \code{\link{get_records}} as keys.
#'
#' @export
get_query_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    build_request()
  response <- q$perform()
  return(response$content$QUERY_PARAMS)
}



#' @title  Get parameters to define valid results in queries
#'
#' @description
#' Request information about all valid result columns to request from Arctos.
#'
#' @usage get_result_parameters()
#'
#' @returns
#' Data frame listing valid result columns and associated
#' description and category. The returned columns are: `display`, `obj_name`,
#' `query_cost`, `category`, `description`, `default_order`. The names in
#' `obj_name` are passed to \code{\link{get_records}} in the `columns`
#' parameter as a `list`.
#'
#' @export
get_result_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    build_request()
  response <- q$perform()
  return(response$content$RESULTS_PARAMS)
}



#' @title Count number of records in a query
#'
#' @description
#' Request from Arctos the total number of records that match a specific query.
#' A list of possible query keys can be obtained from the output of
#' \code{\link{get_query_parameters}}.
#'
#' @usage get_record_count(..., api_key = NULL)
#'
#' @param ... Query parameters and their values to pass to Arctos to search.
#' For example, `scientific_name = "Canis lupus"``
#' @param api_key (character) The API key to use for this request.
#' The default, `NULL`, uses the package's default API key.
#'
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



#' @title Get records from Arctos based on a query
#'
#' @description
#' Make a request to Arctos to return data based on a query. The columns
#' (fields) returned are specified in the list defined in `columns`.
#' A list of possible query keys can be obtained from the output of
#' \code{\link{get_query_parameters}}.
#'
#' @usage
#' get_records(..., api_key = NULL, columns = NULL, limit = NULL,
#'             all_records = FALSE)
#'
#' @param ... Query parameters and their values to pass to Arctos to search.
#' For example, `scientific_name = "Canis lupus"`
#' @param api_key (character) The API key to use for this request.
#' The default, `NULL`, uses the package's default API key.
#' @param columns A list of columns to be returned in the table of records
#' to be downloaded from Arctos.
#' @param limit (numeric) The maximum number of records to download at once. Default
#' is 100.
#' @param all_records (logical) If true, the request is performed multiple times
#' to obtain data from Arctos until all records matching the query have been
#' downloaded.
#'
#' @returns
#' A query object consisting of metadata for each request sent to Arctos to
#' fulfill the user's query, and a data frame of records.
#'
#' @export
get_records <- function(..., api_key = NULL, columns = NULL, limit = NULL,
                        all_records = FALSE) {
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

  if (is.null(limit)) {
    limit <- 250
  }

  builder$set_limit(limit)
  query$perform(api_key)

  if (all_records) {
    repeat {
      query$from_response_request()$
        request_more(limit)

      if (is.null(query$perform())) {
        break
      }
    }
  }

  return(query)
}



#' @title Expand information of columns in JSON format
#'
#' @description
#' Expand all information contained in a JSON formatted column in a query
#' object. Information is presented as nested data frames if needed.
#'
#' @usage expand_column(query, column_name)
#'
#' @param query The query object with a JSON formatted column to be expanded.
#' @param column_name (character) The name of the column to be expanded.
#'
#' @returns Nothing.
#'
#' @export
expand_column <- function(query, column_name) {
  query$expand_col(column_name)
}



#' @title Get query records as a data frame
#'
#' @description
#' Obtain the data frame with the records from a successful query.
#'
#' @usage response_data(query)
#'
#' @param query The query object to extract the data frame from.
#'
#' @returns
#' A data frame with the information requested in the query.
#'
#' @export
response_data <- function(query) {
  return(query$df)
}



#' @title Write query records as an RDS file
#'
#' @description
#' Save the query object as an RDS file, which stores the entire state of the
#' query and can be loaded at a later time.
#'
#' @usage save_response_rds(query, filename)
#'
#' @param query The query object to be saved.
#' @param filename (character) Name of the file to be saved.
#'
#' @returns Nothing.
#'
#' @export
save_response_rds <- function(query, filename) {
  saveRDS(query, filename)
}



#' @title Read query records previously saved as an RDS file
#'
#' @description
#' Load in a query object saved to an RDS file.
#'
#' @usage read_response_rds(filename)
#'
#' @param filename (character) The name of the file to load in.
#'
#' @returns A query object
#'
#' @export
read_response_rds <- function(filename) {
  readRDS(filename)
}



#' @title save_response_csv
#'
#' @description
#' Save the records inside the query object as a CSV file, optionally alongside
#' metadata relating to the requests made to download the data.
#'
#' @usage
#' save_response_csv(query, filename, expanded = FALSE, with_metadata = TRUE)
#'
#' @param query The query object to be saved
#' @param filename (character) Name of the file to be saved.
#' @param expanded (logical) Setting this option to TRUE will create a folder
#' of CSVs representing hierarchical data. See details.
#' @param with_metadata Whether to save the metadata of the response as a JSON
#' file along side the CSV or folder of CSVs.
#'
#' @details
#' Some columns from Arctos are themselves tables, so to accurately represent
#' the structure of the data, these inner tables can be saved as separate
#' CSVs that are named according to which record they belong.
#'
#'
#' @returns Nothing.
#'
#' @export
save_response_csv <- function(query, filename, expanded = FALSE, with_metadata = TRUE) {
  query$save_records_csv(filename, expanded = expanded)

  if (with_metadata) {
    query$save_metadata_json(filename)
  }
}
