# Read query records previously saved as an RDS file

Load in a query object saved to an RDS file.

## Usage

``` r
read_response_rds(filename)
```

## Arguments

- filename:

  (character) The name of the file to load in.

## Value

A query object

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # Request to download all available data
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  # Save the data in a .RDS file
  save_response_rds(query, "wolves.RDS")

  # Load the data from the .RDS just saved
  read_response_rds("wolves.RDS")

  DONTSHOW({
  unlink("wolves.RDS")
  })
}
```
