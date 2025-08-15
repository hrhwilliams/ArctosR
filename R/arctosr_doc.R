#' ArctosR: An Interface to the Arctos Database
#'
#' @description
#' The `ArctosR` package provides a set of functions to help users
#' perform requests to the Arctos API to download data. It provides a set of
#' builder classes for performing complex requests, as well as a set of simple
#' functions for automating many common requests and workflows.
#'
#' @section About Arctos:
#' Arctos is a collection management information system serving over 5 million
#' records from natural and cultural history collections. Arctos integrates
#' access to collections from disciplines such as anthropology, botany,
#' entomology, ethnology, herpetology, geology, ichthyology, mammalogy,
#' mineralogy, ornithology, paleontology, parasitology, as well as archival and
#' cultural collections. The Arctos database is accessible through a web
#' interface at <https://arctos.database.museum/> More information about Arctos,
#' can be found at <https://arctosdb.org/about/>, and in Cicero et al. (2024)
#' <doi:10.1371/journal.pone.0296478>.
#'
#' @section Functions in ArctosR:
#' \code{\link{get_query_parameters}}, \code{\link{get_result_parameters}},
#' \code{\link{get_record_count}}, \code{\link{get_records}},
#' \code{\link{check_for_status}}, \code{\link{get_error_response}},
#' \code{\link{get_last_response_url}},
#' \code{\link{response_data}}, \code{\link{save_response_rds}},
#' \code{\link{read_response_rds}}, \code{\link{save_response_csv}},
#' \code{\link{expand_column}}
#'
"_PACKAGE"
