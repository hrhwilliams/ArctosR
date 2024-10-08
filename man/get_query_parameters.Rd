% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frontend.R
\name{get_query_parameters}
\alias{get_query_parameters}
\title{get_query_parameters}
\usage{
get_query_parameters()
}
\value{
Data frame listing valid query parameters and associated
description and category
}
\description{
Request a data frame containing a list of all valid query parameters for
querying Arctos. The returned columns are: \verb{display, obj_name, category, subcategory, description}. All entries in obj_name are valid parameters to
pass to \code{\link{get_records}} as keys.
}
