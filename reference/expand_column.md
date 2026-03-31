# Expand information of columns in JSON format

Expand all information contained in a JSON formatted column in a query
object. Information is presented as nested data frames if needed.

## Usage

``` r
expand_column(query, column_name)
```

## Arguments

- query:

  The query object with a JSON formatted column to be expanded.

- column_name:

  (character) The name of the column to be expanded.

## Value

Nothing.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # Request to download all available data
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  # The partdetail column is a JSON list of parts and their attributes
  # This will convert the column to dataframes:
  expand_column(query, "partdetail")
}
```
