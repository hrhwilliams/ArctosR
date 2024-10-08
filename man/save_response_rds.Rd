% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frontend.R
\name{save_response_rds}
\alias{save_response_rds}
\title{save_response_rds}
\usage{
save_response_rds(query, filename)
}
\arguments{
\item{query}{The query object to be saved.}

\item{filename}{Name of the file to be saved.}
}
\value{
Nothing.
}
\description{
Save the query object as an RDS file which stores the entire state of the
query and can be loaded at a later time.
}
