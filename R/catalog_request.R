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

#' @title CatalogRequestBuilder
#'
#' @import R6
#' @export
CatalogRequestBuilder <- R6::R6Class("CatalogRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    #' @description Sets the limit on how many records to initially request
    #' from Arctos.
    #'
    #' @param limit (`integer(1)`).
    #' @return [CatalogRequestBuilder].
    set_limit = function(limit) {
      private$limit <- limit
      return(invisible(self))
    },

    #' @description Sets the query parameters to use to search Arctos.
    #'
    #' @param query (`list`).
    #' @return [CatalogRequestBuilder].
    set_query = function(...) {
      private$query <- list(...)
      return(invisible(self))
    },

    #' @description Sets the result parameters to use to filter out results.
    #'
    #' @param query (`list`).
    #' @return [CatalogRequestBuilder].
    set_filter = function(...) {
      private$filter_by <- list(...)
      return(invisible(self))
    },

    #' @description Set parts to query over.
    #'
    #' @param parts (`list`).
    #' @return [CatalogRequestBuilder].
    set_parts = function(...) {
      private$parts <- list(...)
      return(invisible(self))
    },

    #' @description Set attributes to query over.
    #'
    #' @param attributes (`list`).
    #' @return [CatalogRequestBuilder].
    set_attributes = function(...) {
      private$attributes <- list(...)
      return(invisible(self))
    },

    #' @description Set components to query over.
    #'
    #' @param components (`list`).
    #' @return [CatalogRequestBuilder].
    set_components = function(...) {
      private$components <- list(...)
      return(invisible(self))
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param cols (`list`).
    #' @return [CatalogRequestBuilder].
    set_columns = function(...) {
      private$cols <- list(...)
      return(invisible(self))
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param cols (`list`).
    #' @return [CatalogRequestBuilder].
    set_columns_list = function(l) {
      private$cols <- l
      return(invisible(self))
    },

    #' @description Sets the columns in the dataframe returned by Arctos.
    #'
    #' @param response a response object from a previous request
    #' @return [FromResponseRequestBuilder].
    from_previous_response = function(response) {
      FromResponseRequestBuilder$new(response)
    },

    #' @description Send a request for data to Arctos with parameters specified
    #' by the other methods called on this class.
    #'
    #' @return [Response].
    build_request = function() {
      if (is.null(private$query)) {
        stop("Unable to build request: No query parameters specified.")
      }

      url_params <- list()
      url_params <- c(url_params, private$query)
      types_list <- list()
      values_list <- list()

      if (!is.null(private$cols)) {
        url_params$cols <- encode_list(private$cols, ",")
      }
      if (!is.null(private$parts)) {
        url_params$cols <- encode_list(private$parts, ",")
      }
      if (!is.null(private$attributes)) {
        url_params$cols <- encode_list(private$attributes, ",")
      }
      if (!is.null(private$components)) {
        url_params$cols <- encode_list(private$components, ",")
      }
      if (!is.null(private$filter_by)) {
        i <- 1

        for (t in names(private$filter_by)) {
          types_list[[sprintf("attribute_type_%d", i)]] <- t
          values_list[[sprintf("attribute_value_%d", i)]] <- private$filter_by[[t]]
          i <- i + 1
        }
      }

      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "getCatalogData")$
        add_param(queryformat = "struct")$
        add_param(length = private$limit)$
        add_params(url_params)$
        add_params(types_list)$
        add_params(values_list)

      return(request)
    }
  ),
  private = list(
    previous_response = NULL,
    request_url = NULL,
    limit = 100,
    query = NULL,
    filter_by = NULL,
    parts = NULL,
    attributes = NULL,
    components = NULL,
    cols = NULL
  )
)
