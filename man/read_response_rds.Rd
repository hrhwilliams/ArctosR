% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frontend.R
\name{read_response_rds}
\alias{read_response_rds}
\title{Read query records previously saved as an RDS file}
\usage{
read_response_rds(filename)
}
\arguments{
\item{filename}{(character) The name of the file to load in.}
}
\value{
A query object
}
\description{
Load in a query object saved to an RDS file.
}
\examples{
library(ArctosR)

# Request to download all available data
query <- get_records(
  scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
  columns = list("guid", "parts", "partdetail")
)

# Save the data in a .RDS file
save_response_rds(query, "wolves.RDS")

# Load the data from the .RDS just saved
read_response_rds("wolves.RDS")

\dontshow{
unlink("wolves.RDS")
}

}
