% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frontend.R
\name{get_result_parameters}
\alias{get_result_parameters}
\title{get_result_parameters}
\usage{
get_result_parameters()
}
\value{
Data frame listing valid result columns and associated
description and category
}
\description{
Request a data frame containing a list of all valid result columns to request
from Arctos. The returned columns are: \verb{display, obj_name, query_cost, category, description, default_order}. The names in obj_name are passed to
\code{\link{get_records}} in the \code{columns} parameter as a \code{list}.
}
