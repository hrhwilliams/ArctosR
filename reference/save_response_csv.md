# save_response_csv

Save the records inside the query object as a CSV file, optionally
alongside metadata relating to the requests made to download the data.

## Usage

``` r
save_response_csv(query, filename, expanded = FALSE, with_metadata = TRUE)
```

## Arguments

- query:

  The query object to be saved

- filename:

  (character) Name of the file to be saved.

- expanded:

  (logical) Setting this option to TRUE will create a folder of CSVs
  representing hierarchical data. See details.

- with_metadata:

  Whether to save the metadata of the response as a JSON file along side
  the CSV or folder of CSVs.

## Value

Nothing.

## Details

Some columns from Arctos are themselves tables, so to accurately
represent the structure of the data, these inner tables can be saved as
separate CSVs that are named according to which record they belong.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # Request to download all available data
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )

  # Save the response in a flat CSV with an additional metadata file in JSON
  save_response_csv(query, "msb-wolves.csv", with_metadata = TRUE)

  DONTSHOW({
  unlink("msb-wolves.csv")
  unlink("msb-wolves.csv.json")
  })
}
```
