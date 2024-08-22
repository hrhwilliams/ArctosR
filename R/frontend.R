#' @export
get_query_parameters <- function() {
  return(ArctosR::InfoRequestBuilder$new()$
           all_query_params()$
           perform_request())
}

#' @export
get_result_parameters <- function() {
  return(ArctosR::InfoRequestBuilder$new()$
           all_result_params()$
           perform_request())
}

#' @export
get_record_count <- function(...) {
  return(ArctosR::CatalogRequestBuilder$new()$
           default_api_key()$
           set_query(...)$
           record_count())
}

#' @export
get_records <- function(..., api_key = NULL, columns = NULL, limit = NULL, all_records = FALSE) {
  builder <- ArctosR::CatalogRequestBuilder$new()

  if (!missing(...)) {
    builder <- builder$set_query(...)
  } else {
    stop("Requires at least one query parameter to be defined.")
  }

  if (!is.null(api_key)) {
    builder <- builder$set_api_key(api_key)
  }

  if (!is.null(columns)) {
    builder <- builder$set_columns_list(columns)
  }

  if (all_records) {
    # download in a while loop
    stop("unimplemented")
  } else {
    if (!is.null(limit)) {
      builder <- builder$limit(limit)
    }
    response <- builder$perform_request()
    return(response)
  }
}

#' @export
response_data <- function(response) {
  return(response$as_data_frame())
}

#' @export
response_metadata <- function(response) {
  return(response$get_metadata())
}

#' @export
save_response_rds <- function(response, filename) {
  saveRDS(response, filename)
}

#' @export
read_response_rds <- function(filename) {
  readRDS(filename)
}

#' @export
save_response_csv <- function(response, path, flat = TRUE, with_metadata = TRUE) {
  if (flat) {
    response$save_flat_csv(path)

    filename <- head(unlist(strsplit(path, "[.]")), n=1)
    if (with_metadata) {
      write(jsonlite::toJSON(response_metadata(response), pretty=TRUE),
            file = sprintf("%s.json", filename))
    }
  } else {
    response$save_expanded_csvs(path)

    if (with_metadata) {
      write(jsonlite::toJSON(response_metadata(response), pretty=TRUE),
            file = sprintf("%s/%s_meta.json", path))
    }
  }
}
