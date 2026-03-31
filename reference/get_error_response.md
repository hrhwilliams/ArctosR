# Get the last error message of a query object

Returns the error string returned from Arctos if the last response in a
query object returned a status code other than HTTP 200 for debugging
purposes.

## Usage

``` r
get_error_response(query)
```

## Arguments

- query:

  A query object to return the error string of

## Value

The error string of a failing response object, or "No error" if the
query didn't fail

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # query with an invalid column name 'paarts'
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "paarts", "partdetail")
  )

  get_error_response(query)
}
```
