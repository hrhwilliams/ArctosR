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

#' @title InfoRequestBuilder
#' @description
#' Builder for a request for query parameter or result parameter documentation
#' from Arctos. For a valid request, only one method to specify the type of
#' request can be called.
#'
#' @import R6
#' @export
InfoRequestBuilder <- R6::R6Class("InfoRequestBuilder",
  inherit = RequestBuilder,
  public = list(
    build_request = function() {
      request <- ArctosR::Request$new()$
        with_endpoint("catalog.cfc")$
        add_param(method = "about")

      return(request)
    }
  )
)
