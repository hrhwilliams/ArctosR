# Check if the query object ends with a successful response

Checks if a response failed as part of a query.

## Usage

``` r
check_for_status(query)
```

## Arguments

- query:

  A query object to check the return status of

## Value

TRUE if the query succeeded, FALSE otherwise

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # query with an invalid column name 'paarts'
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "paarts", "partdetail")
  )

  check_for_status(query)
}
```
