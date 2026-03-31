# Get the last URL used by a request in a query object

Returns the last URL used by a request in a query object

## Usage

``` r
get_last_response_url(query)
```

## Arguments

- query:

  A query object to return the URL for

## Value

The URL of the last performed request in a query object

## Examples

``` r
library(ArctosR)

if (interactive()) {
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  get_last_response_url(query)
}
```
