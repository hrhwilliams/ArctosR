# ArctosR
# Copyright (C) 2024-2025  Harlan Williams
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Get parameters to perform queries
#'
#' @description
#' Request information about all valid query parameters for querying Arctos.
#'
#' @usage get_query_parameters()
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   q <- get_query_parameters()
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   r <- get_result_parameters()
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   count <- get_record_count(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm"
#'   )
#' }
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
  query <- Query$new()
  query$catalog_request()$
    set_query(...)$
    set_limit(1)
  response <- query$perform(api_key)

  if (!check_for_status(query)) {
    stop(get_error_response(query))
  }

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
#'             filter_by = NULL, all_records = FALSE)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#' }
#'
#' if (interactive()) {
#'   # Request to download data about rodents examined for Orthohantavirus
#'   orthohantavirus_MSB <- get_records(guid_prefix="MSB:Mamm", taxon_name=Rodentia,
#'                                      filter_by=list("detected"="Orthohantavirus")
#'   )
#' }
#'
#' @param ... Query parameters and their values to pass to Arctos to search.
#' For example, `scientific_name = "Canis lupus"`
#' @param api_key (character) The API key to use for this request.
#' The default, `NULL`, uses the package's default API key.
#' @param columns A list of columns to be returned in the table of records
#' to be downloaded from Arctos.
#' @param limit (numeric) The maximum number of records to download at once. Default
#' is 100.
#' @param filter_by An optional list of record attributes to filter results by.
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
                        filter_by = NULL, all_records = FALSE) {
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

  if (!is.null(filter_by)) {
    do.call(builder$set_filter, filter_by)
  }

  if (is.null(limit)) {
    limit <- 100
  }

  builder$set_limit(limit)
  query$perform(api_key)

  if (!check_for_status(query)) {
    stop(get_error_response(query))
  }

  if (all_records) {
    repeat {
      query$from_response_request()$
        request_more(limit)

      if (is.null(query$perform())) {
        break
      }

      if (!check_for_status(query)) {
        stop(get_error_response(query))
      }
    }
  }

  return(query)
}



#' @title Get the relationships (e.g. "host of") a cataloged item has
#'
#' @description A cataloged item in Arctos can be related to any other number of
#' items by relationships defined in the code table `ctid_references`. This
#' function will return all items related by any such relationship in the table
#' in a data frame.
#'
#' @usage get_relationships(guid)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   r <- get_relationships("MSB:Mamm:140026")
#' }
#'
#' @param guid The Arctos GUID of the item to query relationships over
#'
#' @returns a data frame of all related items. This contains URLs
#'
#' @export
get_relationships <- function(guid) {
  query <- Query$new()
  builder <- query$catalog_request()
  builder$set_query(guid=guid)
  builder$set_columns("relatedcatalogeditems")
  result <- query$perform()
  return(response_data(query))
}



#' @title Check if the query object ends with a successful response
#'
#' @description
#' Checks if a response failed as part of a query.
#'
#' @usage
#' check_for_status(query)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # query with an invalid column name 'paarts'
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "paarts", "partdetail")
#'   )
#'
#'   check_for_status(query)
#' }
#'
#' @param query A query object to check the return status of
#'
#' @returns
#' TRUE if the query succeeded, FALSE otherwise
#'
#' @export
check_for_status <- function(query) {
  r <- query$last_response

  if (is.null(r)) {
    stop("No response")
  }

  return(r$was_success())
}



#' @title Get the last error message of a query object
#'
#' @description
#' Returns the error string returned from Arctos if the last response in a
#' query object returned a status code other than HTTP 200 for debugging
#' purposes.
#'
#' @usage
#' get_error_response(query)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # query with an invalid column name 'paarts'
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "paarts", "partdetail")
#'   )
#'
#'   get_error_response(query)
#' }
#'
#' @param query A query object to return the error string of
#'
#' @returns
#' The error string of a failing response object, or "No error" if the query
#' didn't fail
#'
#' @export
get_error_response <- function(query) {
  if (!check_for_status(query)) {
    last_response <- query$last_response
    return(last_response$content$Message)
  } else {
    return("No error")
  }
}



#' @title Get the last URL used by a request in a query object
#'
#' @description
#' Returns the last URL used by a request in a query object
#'
#' @usage
#' get_last_response_url(query)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   get_last_response_url(query)
#' }
#'
#' @param query A query object to return the URL for
#'
#' @returns
#' The URL of the last performed request in a query object
#'
#' @export
get_last_response_url <- function(query) {
  return(query$last_response$metadata$url)
}



#' @title Expand information of columns in JSON format
#'
#' @description
#' Expand all information contained in a JSON formatted column in a query
#' object. Information is presented as nested data frames if needed.
#'
#' @usage expand_column(query, column_name)
#'
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   # The partdetail column is a JSON list of parts and their attributes
#'   # This will convert the column to dataframes:
#'   expand_column(query, "partdetail")
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   # Grab the dataframe of records from the query
#'   df <- response_data(query)
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   # Save the data in a .RDS file
#'   save_response_rds(query, "wolves.RDS")
#'
#'
#'   \dontshow{
#'   unlink("wolves.RDS")
#'   }
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   # Save the data in a .RDS file
#'   save_response_rds(query, "wolves.RDS")
#'
#'   # Load the data from the .RDS just saved
#'   read_response_rds("wolves.RDS")
#'
#'   \dontshow{
#'   unlink("wolves.RDS")
#'   }
#' }
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
#' @examples
#' library(ArctosR)
#'
#' if (interactive()) {
#'   # Request to download all available data
#'   query <- get_records(
#'     scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
#'     columns = list("guid", "parts", "partdetail")
#'   )
#'
#'   # Save the response in a flat CSV with an additional metadata file in JSON
#'   save_response_csv(query, "msb-wolves.csv", with_metadata = TRUE)
#'
#'   \dontshow{
#'   unlink("msb-wolves.csv")
#'   unlink("msb-wolves.csv.json")
#'   }
#' }
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
