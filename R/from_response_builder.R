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

#' @title FromResponseRequestBuilder
#' @description Builder for the case where a request is made with the context
#' of a previous response.
#'
#' @import R6
#' @export
FromResponseRequestBuilder <- R6::R6Class("FromResponseRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    initialize = function(response, records) {
      private$table_id <- records$table_id
      private$start <- response$stop_index + 1
      return(invisible(self))
    },

    #' @description Request at most `count` more records from this response's
    #' original query
    #'
    #' @param count number of additional records to request
    #' @return FromResponseRequestBuilder
    request_more = function(count) {
      private$more <- count
      return(invisible(self))
    },

    #' @description Perform the request.
    #' @return Request
    build_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(tbl = private$table_id)$
        add_param(start = private$start)$
        add_param(length = private$more)
      return(request)
    }
  ),
  private = list(
    response = NULL,
    start = 0,
    table_id = NULL,
    more = 100
  )
)
