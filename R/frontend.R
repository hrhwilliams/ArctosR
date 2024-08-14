get_query_parameters <- function() {
  return(ArctosR::InfoRequestBuilder$new()$
           all_query_params()$
           perform_request())
}

get_result_parameters <- function() {
  return(ArctosR::InfoRequestBuilder$new()$
           all_result_params()$
           perform_request())
}

get_record_count <- function(...) {
  return(ArctosR::CatalogRequestBuilder$new()$
           default_api_key()$
           set_query(...)$
           record_count())
}

get_records <- function(..., columns = NULL, limit = NULL, all_records = FALSE) {
  builder <- ArctosR::CatalogRequestBuilder$new()

  if (!missing(...)) {
    builder <- builder$set_query(...)
  } else {
    stop("Requires at least one query parameter to be defined.")
  }

  if (!is.null(columns)) {
    builder <- builder$set_columns(columns)
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

response_data <- function(response) {
  return(response$as_data_frame())
}

response_metadata <- function(response) {
  return(response$get_metadata())
}

# expand dataframe by default
# => need to just record which columns need to be expanded

# saveRDS the expanded dataframe

save_response_csv <- function(response, path, expanded = FALSE, with_metadata = TRUE) {
  if (expanded) {
    stop("unimplemented")
  } else {
    response$save_flat_csv(path)

    if (with_metadata) {
      write(jsonlite::toJSON(response_metadata(response), pretty=TRUE),
            file = sprintf("%s.json", path))
    }
  }
}

save_response_object <- function(response, path) {
  response$save_object(path)
}
