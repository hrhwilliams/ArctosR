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

#' @title Metadata
#' @description Metadata for a specific HTTP response from Arctos.
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @export
Metadata <- R6::R6Class("Metadata",
  public = list(
    url = NULL,
    params = NULL,
    status_code = 0,
    system_timestamp = NULL,
    arctos_timestamp = NULL,
    timezone = "GMT",
    to_list = function() {
      return(list(
        url = self$url,
        params = self$params,
        status_code = self$status_code,
        system_timestamp = self$system_timestamp,
        arctos_timestamp = self$arctos_timestamp,
        timezone = self$timezone
      ))
    }
  )
)
