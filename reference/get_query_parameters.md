# Get parameters to perform queries

Request information about all valid query parameters for querying
Arctos.

## Usage

``` r
get_query_parameters()
```

## Value

Data frame listing valid query parameters and associated description and
category. The returned columns are: `display`, `obj_name`, `category`,
`subcategory`, `description`. All entries in `obj_name` are valid
parameters to pass to
[`get_records`](https://hrhwilliams.github.io/ArctosR/reference/get_records.md)
as keys.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  q <- get_query_parameters()
}
```
