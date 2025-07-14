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

#' @title Response
#' @description Response returned from Arctos.
#'
#' @import R6
#' @export
Response <- R6::R6Class("Response",
  public = list(
    request = NULL,
    metadata = NULL,
    response_type = NULL,
    content = NULL,
    start_index = 0,
    stop_index = 1,
    initialize = function(request, raw_response) {
      self$request <- request

      self$metadata <- ArctosR::Metadata$new()
      self$metadata$url <- request$url
      self$metadata$params <- request$params
      self$metadata$status_code <- raw_response$status_code
      self$metadata$system_timestamp <- request$timestamp
      self$metadata$arctos_timestamp <- as.POSIXct(
        get_header(rawToChar(raw_response$headers), "Date: "),
        format = "%a, %d %b %Y %H:%M:%S GMT"
      )

      self$response_type <- raw_response$type
      if (response_is_json(raw_response)) {
        self$content <- parse_response(raw_response)
      }
    },
    set_start_index = function(start) {
      self$start_index <- start
      self$stop_index <- self$stop_index + start
    },
    was_success = function() {
      return(self$metadata$status_code == 200)
    },
    is_empty = function() {
      return(length(self$content$DATA) == 0)
    },
    has_json_content = function() {
      return(!is.null(self$content))
    },
    to_list = function() {
      return(list(
        metadata = self$metadata$to_list(),
        index_range = self$index_range
      ))
    },
    to_records = function(start = 0) {
      # grab records from content
      df <- as.data.frame(self$content$DATA)
      records <- ArctosR::Records$new(df, self$content$tbl)
      self$start_index <- start
      self$stop_index <- self$start_index + nrow(df) - 1
      return(records)
    }
  ),
  active = list(
    index_range = function() {
      return(c(self$start_index, self$stop_index))
    }
  )
)
