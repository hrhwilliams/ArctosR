
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ArctosR

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of ArctosR from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("hrhwilliams/ArctosR")
```

## Example

``` r
library(ArctosR)

# Request a list of all result parameters. These are the names that can show up
# as columns in a dataframe returned by ArctosR.
result_params <- ArctosR::InfoRequestBuilder$new()$
  all_result_params()$
  perform_request()

# Request just the number of records matching a query.
count <- ArctosR::CatalogRequestBuilder$new()$
  default_api_key()$
  set_query(scientific_name="Canis lupus", guid_prefix="MSB:Mamm")$
  record_count()

# Request to download data.
response <- ArctosR::CatalogRequestBuilder$new()$
  default_api_key()$
  set_query(scientific_name="Canis lupus", guid_prefix="MSB:Mamm")$
  set_columns("guid", "parts", "partdetail")$
  set_limit(500)$
  perform_request()

responses <- c(response)
data <- response$as_data_frame()

# Because Arctos paginates the records returned by a query, it is necessary to
# keep requesting data until the number of rows of the dataframe is equal to the
# count originally returned by Arctos.
while (nrow(data) < count) {
  response <- ArctosR::CatalogRequestBuilder$new()$
    from_previous_response(response)$
    request_more(500)$
    perform_request()

  data <- rbind(data, response$as_data_frame())
  responses <- c(responses, response)
}

# Saves the dataframe as a comma-separated value file.
write.csv(data, "msb_canis_lupus.csv")
```
