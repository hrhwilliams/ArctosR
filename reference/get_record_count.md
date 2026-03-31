# Count number of records in a query

Request from Arctos the total number of records that match a specific
query. A list of possible query keys can be obtained from the output of
[`get_query_parameters`](https://hrhwilliams.github.io/ArctosR/reference/get_query_parameters.md).

## Usage

``` r
get_record_count(..., api_key)
```

## Arguments

- ...:

  Query parameters and their values to pass to Arctos to search. For
  example, \`scientific_name = "Canis lupus"“

- api_key:

  (character) The API key to use for this request.

## Value

The number of records matching the given query, as an integer.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  count <- get_record_count(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm"
  )
}
```
