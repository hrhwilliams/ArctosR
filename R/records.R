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

#' @title Records
#' @description A (possibly nested) data frame of records returned by a static
#' set of query and result parameters
#'
#' @import R6
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite fromJSON
#' @importFrom jsonlite validate
#' @export
Records <- R6::R6Class("Records",
  public = list(
    df = NULL,
    initialize = function(df, tbl) {
      private$tbl <- tbl
      private$raw <- df
      self$df <- df
    },
    append = function(other) {
      private$raw <- rbind(private$raw, other$raw_df)
      private$refresh()
    },

    #' @description Writes the data in the response object to a CSV file.
    save_flat_csv = function(file_path) {
      file_ext <- file_extension(file_path)
      if (is.null(file_ext) || tolower(file_ext) != "csv") {
        file_path <- paste(file_path, "csv", sep = ".")
      }

      if (is.null(self$df)) {
        stop("No data to export.")
      }

      write_csv(private$raw, file_path)
    },
    save_nested_csvs = function(file_path) {
      if (is.null(self$df)) {
        stop("No data to export.")
      }

      if (dir.exists(file_path)) {
        stop("Directory already exists")
      }

      old_wd <- getwd()
      on.exit(setwd(old_wd))

      dir.create(file_path)
      setwd(file_path)

      recursive_write <- function(df, col_name_path) {
        col_types <- sapply(df, class)
        list_cols <- which(col_types == "list")
        exclude <- names(df) %in% names(list_cols)
        write_csv(df[!exclude], sprintf("%s.csv", encode_win_filename(col_name_path)))

        for (col in names(list_cols)) {
          for (row in 1:nrow(df)) {
            if (is.null(df[[col]][[row]])) {
              next
            }
            recursive_write(df[[col]][[row]], sprintf(
              "%s_%s-%s", encode_win_filename(col_name_path),
              encode_win_filename(df[[1]][[row]]), col
            ))
          }
        }
      }

      recursive_write(self$df, file_path)
    },

    #' @description Expand a column of nested JSON tables in the response to a
    #' list of dataframes.
    #'
    #' @param col (`string`)
    expand_col = function(column) {
      if (is.null(private$raw)) {
        stop("No data to expand")
      }

      if (is.null(private$raw[[column]])) {
        stop("No such column")
      }

      private$expanded <- union(private$expanded, column)
      private$refresh()
    }
  ),
  active = list(
    records = function() {
      return(nrow(self$df))
    },
    column_names = function() {
      return(colnames(self$df))
    },
    table_id = function() {
      return(private$tbl)
    },
    raw_df = function() {
      return(private$raw)
    }
  ),
  private = list(
    raw = NULL,
    expanded = character(0),
    tbl = NULL,
    refresh = function() {
      df <- private$raw
      for (column in private$expanded) {
        df[[column]] <- lapply(df[[column]], function(j) {
          if (!validate(j)) {
            return(NULL)
          } else {
            fromJSON(j, simplifyDataFrame = TRUE)
          }
        })
      }
      self$df <- df
    }
  )
)
