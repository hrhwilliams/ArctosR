#' @importFrom utils head

#' @export
get_query_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    all_query_params()
  response <- q$perform()
  return(response$content$QUERY_PARAMS)
}

#' @export
get_result_parameters <- function() {
  q <- Query$new()
  q$info_request()$
    all_result_params()
  response <- q$perform()
  return(response$content$RESULTS_PARAMS)
}

#' @export
get_record_count <- function(..., api_key = NULL) {
  q <- Query$new()
  q$catalog_request()$
    set_query(...)$
    set_limit(1)
  response <- q$perform(api_key)

  return(response$content$recordsTotal)
}

#' @export
get_records <- function(..., api_key = NULL, columns = NULL, limit = NULL, all_records = FALSE) {
  query <- Query$new()
  builder <- query$catalog_request()

  if (!missing(...)) {
    builder$set_query(...)
  } else {
    stop("Requires at least one query parameter to be defined.")
  }

  if (!is.null(columns)) {
    do.call(builder$set_columns, columns)
    # builder$set_columns(columns)
  }

  if (!is.null(limit)) {
    builder$set_limit(limit)
  }

  query$perform(api_key)

  if (all_records) {
    repeat {
      query$from_response_request()$
        request_more(100)

      if(is.null(query$perform())) {
        break
      }
    }
  }

  return(query)
}

#' @export
response_data <- function(query) {
  return(query$df)
}

#' @export
save_response_rds <- function(query, filename) {
  saveRDS(query, filename)
}

#' @export
read_response_rds <- function(filename) {
  readRDS(filename)
}

#' @export
save_response_csv <- function(query, filename, expanded = FALSE, with_metadata = TRUE) {
  query$save_records_csv(filename, expanded = expanded)

  if (with_metadata) {
    query$save_metadata_json(filename)
  }
}
