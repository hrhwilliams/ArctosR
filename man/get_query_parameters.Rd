% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frontend.R
\name{get_query_parameters}
\alias{get_query_parameters}
\title{Get parameters to perform queries}
\usage{
get_query_parameters()
}
\value{
Data frame listing valid query parameters and associated description and
category. The returned columns are: \code{display}, \code{obj_name}, \code{category},
\code{subcategory}, \code{description}. All entries in \code{obj_name} are valid parameters
to pass to \code{\link{get_records}} as keys.
}
\description{
Request information about all valid query parameters for querying Arctos.
}
\examples{
library(ArctosR)

q <- get_query_parameters()

}
