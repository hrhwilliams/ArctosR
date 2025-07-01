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

#' @title Query
#' @description The results of a user query. Able to accept multiple responses
#' to increase the record count, or to add columns.
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @export
Query <- R6::R6Class("Query",
  public = list(
    catalog_request = function() {
      private$current_builder <- ArctosR::CatalogRequestBuilder$new()
      return(private$current_builder)
    },
    from_response_request = function() {
      private$current_builder <- ArctosR::FromResponseRequestBuilder$
        new(private$responses[[length(private$responses)]], private$records)
      return(private$current_builder)
    },
    info_request = function() {
      private$current_builder <- ArctosR::InfoRequestBuilder$new()
      return(private$current_builder)
    },
    perform = function(api_key = NULL) {
      if (is.null(private$current_builder)) {
        stop("Nothing to perform.")
      }

      request <- private$current_builder$build_request()
      response <- request$perform(api_key)

      if (is.null(response)) {
        stop("No response")
        return(NULL)
      } else if (response$metadata$status_code != 200) {
        stop(response$metadata$status_code)
      }

      if (is_class(private$current_builder, "CatalogRequestBuilder") || is_class(private$current_builder, "FromResponseRequestBuilder")) {
        private$concatenate_response(response)

        # check if response had no records
        if (response$is_empty()) {
          return(NULL)
        }

        private$current_builder <- NULL

        return(response)
      } else if (is_class(private$current_builder, "InfoRequestBuilder")) {
        return(response)
      } else {
        return(NULL)
      }
    },
    save_metadata_json = function(file_path) {
      file_ext <- file_extension(file_path)
      if (is.null(file_ext) || tolower(file_ext) != "json") {
        file_path <- paste(file_path, "json", sep = ".")
      }

      write(toJSON(lapply(private$responses, function(response) response$to_list()), pretty = TRUE),
        file = file_path
      )
    },
    save_records_csv = function(file_path, expanded = FALSE) {
      if (!expanded) {
        private$records$save_flat_csv(file_path)
      } else {
        private$records$save_nested_csvs(file_path)
      }
    },
    expand_col = function(column_name) {
      private$records$expand_col(column_name)
    },
    get_responses = function() {
      private$responses
    }
  ),
  active = list(
    df = function() {
      return(private$records$df)
    }
  ),
  private = list(
    current_builder = NULL,
    responses = NULL,
    records = NULL,
    concatenate_response = function(response) {
      if (is.null(private$records)) {
        private$records <- response$to_records()
      } else {
        private$records$append(response$to_records())
      }

      if (is.null(private$responses)) {
        private$responses <- c(response)
      } else {
        response$set_start_index(private$responses[[length(private$responses)]]$stop_index + 1)
        private$responses <- c(private$responses, response)
      }
    }
  )
)
