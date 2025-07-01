
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ArctosR

<!-- badges: start -->

[![R-CMD-check](https://github.com/hrhwilliams/ArctosR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/hrhwilliams/ArctosR/actions/workflows/R-CMD-check.yaml)
[![codecov.io](https://codecov.io/gh/hrhwilliams/ArctosR/branch/main/graphs/badge.svg)](https://app.codecov.io/gh/hrhwilliams/ArctosR?branch=main)
<!-- badges: end -->

## GSoC project description

**Student**: Harlan Williams

**GSoC Mentors**: Marlon Cobos, Vijay Barve, Jocelyn Colella, Michelle
Koo

**Organization**: R Project For Statistical Computing

### Motivation

Arctos (<https://arctosdb.org/>) has an extensive database that connects
\>100 data fields to physical specimen records using standard DarwinCore
vocabulary, many of which are only accessible through its web interface.
Data can be accessed through the web interface, but downloads are memory
intensive, such that only a subset of fields or specimens can be queried
at once. The goal of this package is to provide a programmatic way to
access these data for researchers, in hopes of improving their workflows
and the accessibility of biodiversity data stored on Arctos.

The main difficulties in accessing Arctos via the API is pagination of
records, requiring multiple API queries, and hierarchical data where
specific columns in Arctos records could themselves be tables or point
to other Arctos records. This package was developed specifically to
handle these two difficulties for the user. Pagination is handled by
package internals so that the user only has to ask for all records
pertaining to a query to get all of those records.

The user also is able to expand columns representing hierarchical data
and explore that data within RStudio natively, making analysis of that
data much more intuitive.

### Status of the project

At the time of submission for GSoC 2024 a set of functions for querying
from Arctos as well as looking up documentation for Arctos are available
to the user. The user is also able to explore downloaded records in a
hierarchical manner by expanding columns returned from Arctos which
represent tables of tables. These records are then able to be saved in a
CSV format or stored as R objects for further data analysis tasks by
researchers.

With these functions, ArctosR can be integrated into existing data
analysis pipelines to provide updated records. Each query in ArctosR is
also accompanied by metadata, allowing for better data documentation and
query reproducibility by other researchers. At this stage the project
fulfills the goals set out in the proposal, the only thing remaining is
for it to be submitted to CRAN.

A complete history of commits can be accessed
<a href="https://github.com/hrhwilliams/ArctosR/commits/main/" target="_blank">here</a>.

## Installation

### CRAN

ArctosR can be installed from [CRAN](https://cran.r-project.org/) by
running the command in R:

``` r
install.packages("ArctosR")
```

### GitHub

You can install the development version of ArctosR from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("hrhwilliams/ArctosR")
```

## Example

``` r
library(ArctosR)

# Request a list of all result parameters. These are the names that can show up
# as columns in a dataframe returned by ArctosR.
result_params <- get_result_parameters()

# Print the first six rows and first 3 columns to the console.
result_params[1:6, 1:3]
#>                     display            obj_name query_cost
#> 1 GUID (DarwinCore Triplet)                guid          1
#> 2    Catalog Number Integer    catalognumberint          1
#> 3               Identifiers         identifiers          1
#> 4        Simple Identifiers othercatalognumbers          1
#> 5                 Accession         accn_number          1
#> 6                     Media               media          1

# If using RStudio, view the entire dataframe of result parameters.
View(result_params)

# Request just the number of records matching a query.
count <- get_record_count(
  scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm"
)

# Request to download data. This is limited to 100 records by default.
response <- get_records(
  scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
  columns = list("guid", "parts", "partdetail")
)

# Request to download all available data.
response <- get_records(
  scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
  columns = list("guid", "parts", "partdetail"),
  all_records = TRUE
)

# Grab the dataframe of records from the response and save that as a csv.
df <- response_data(response)

# Save the response in a flat CSV with an additional metadata file in JSON
save_response_csv(response, "msb-wolves.csv", with_metadata = TRUE)

# Save only the dataframe
write.csv(x = df, file = "msb-wolves-df.csv")
```
