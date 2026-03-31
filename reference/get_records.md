# Get records from Arctos based on a query

Make a request to Arctos to return data based on a query. The columns
(fields) returned are specified in the list defined in `columns`. A list
of possible query keys can be obtained from the output of
[`get_query_parameters`](https://hrhwilliams.github.io/ArctosR/reference/get_query_parameters.md).

## Usage

``` r
get_records(..., api_key = NULL, columns = NULL, limit = NULL,
            filter_by = NULL, all_records = FALSE)
```

## Arguments

- ...:

  Query parameters and their values to pass to Arctos to search. For
  example, `scientific_name = "Canis lupus"`

- api_key:

  (character) The API key to use for this request.

- columns:

  A list of columns to be returned in the table of records to be
  downloaded from Arctos.

- limit:

  (numeric) The maximum number of records to download at once. Default
  is 100.

- filter_by:

  An optional list of record attributes to filter results by.

- all_records:

  (logical) If true, the request is performed multiple times to obtain
  data from Arctos until all records matching the query have been
  downloaded.

## Value

A query object consisting of metadata for each request sent to Arctos to
fulfill the user's query, and a data frame of records.

## Examples

``` r
library(ArctosR)

if (interactive()) {
  # Request to download all available data
  query <- get_records(
    scientific_name = "Canis lupus", guid_prefix = "MSB:Mamm",
    columns = list("guid", "parts", "partdetail")
  )
}

if (interactive()) {
  # Request to download data about rodents examined for Orthohantavirus
  orthohantavirus_MSB <- get_records(guid_prefix="MSB:Mamm", taxon_name=Rodentia,
                                     filter_by=list("detected"="Orthohantavirus")
  )
}
```
