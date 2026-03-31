# Get query records as a data frame

Obtain the data frame with the records from a successful query.

## Usage

``` r
response_data(query)
```

## Arguments

- query:

  The query object to extract the data frame from.

## Value

A data frame with the information requested in the query.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # Request to download all available data
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  # Grab the dataframe of records from the query
  df <- response_data(query)
}
```
