# Get parameters to define valid results in queries

Request information about all valid result columns to request from
Arctos.

## Usage

``` r
get_result_parameters()
```

## Value

Data frame listing valid result columns and associated description and
category. The returned columns are: `display`, `obj_name`, `query_cost`,
`category`, `description`, `default_order`. The names in `obj_name` are
passed to
[`get_records`](https://hrhwilliams.github.io/ArctosR/reference/get_records.md)
in the `columns` parameter as a `list`.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  r <- get_result_parameters()
}
```
