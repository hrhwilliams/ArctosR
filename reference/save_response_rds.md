# Write query records as an RDS file

Save the query object as an RDS file, which stores the entire state of
the query and can be loaded at a later time.

## Usage

``` r
save_response_rds(query, filename)
```

## Arguments

- query:

  The query object to be saved.

- filename:

  (character) Name of the file to be saved.

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

  # Save the data in a .RDS file
  save_response_rds(query, "wolves.RDS")


  DONTSHOW({
  unlink("wolves.RDS")
  })
}
```
