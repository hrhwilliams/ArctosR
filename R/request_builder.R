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

#' @title RequestBuilder
#' @description A builder for a generic Arctos request. Not to be used directly.
#'
#' @import R6
#' @export
RequestBuilder <- R6::R6Class("RequestBuilder",
  public = list(
    #' @description Turn on printing of debug information.
    debug = function() {
      private$debug_print <- TRUE
      invisible(self)
    },
    build_request = function() {
      stop("Unimplemented for this type")
    }
  ),
  private = list(
    debug_print = FALSE
  )
)
