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

#' @title Request
#' @description A generic Arctos request. Not intended to be used directly. See
#' InfoRequestBuilder and CatalogRequestBuilder.
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @export
Request <- R6::R6Class("Request",
  public = list(
    params = NULL,
    end_point = NULL,
    timestamp = NULL,
    with_endpoint = function(endpoint) {
      self$end_point <- tolower(endpoint)
      return(invisible(self))
    },
    add_param = function(...) {
      params <- list(...)

      if (!is.null(params$api_key)) {
        stop("Set the API key for this request only when calling $perform.")
      }

      self$params <- c(self$params, params)
      return(invisible(self))
    },
    add_params = function(l) {
      params <- l

      if (!is.null(params$api_key)) {
        stop("Set the API key for this request only when calling $perform.")
      }

      self$params <- c(self$params, params)
      return(invisible(self))
    },
    serialize = function() {
      stop("Unimplemented.")
    },
    perform = function(api_key = NULL) {
      if (is.null(self$end_point)) {
        stop("No endpoint given.")
      }

      if (!is.null(api_key)) {
        self$params$api_key <- api_key
      }

      raw_response <- perform_request(self$url)
      if (is.null(raw_response)) {
        return(NULL)
      }

      self$timestamp <- Sys.time()
      attr(self$timestamp, "tzone") <- "GMT"
      self$params$api_key <- NULL

      return(ArctosR::Response$new(self, raw_response))
    },
    from_raw_response = function(raw_response) {
      return(ArctosR::Response$new(self, raw_response))
    }
  ),
  active = list(
    url = function() {
      return(build_url(self$end_point, self$params))
    }
  )
)
