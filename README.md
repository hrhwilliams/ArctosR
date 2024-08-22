
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ArctosR

<!-- badges: start -->
<!-- badges: end -->

## GSoC project description

**Student**: Harlan Williams

**GSoC Mentors**: Marlon Cobos, Vijay Barve, Jocelyn Colella, Michelle
Koo

**Organization**: R Project For Statistical Computing

### Motivation

### Status of the project

All commits made can be seen at the
<a href="https://github.com/claununez/biosurvey/commits/master" target="_blank">complete
list of commits</a>.

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
result_params <- get_result_parameters()

# Print the first six rows and first 3 columns to the console.
result_params[1:6,1:3]
#>                     display            obj_name query_cost
#> 1 GUID (DarwinCore Triplet)                guid          1
#> 2    Catalog Number Integer    catalognumberint          1
#> 3               Identifiers         identifiers          1
#> 4        Simple Identifiers othercatalognumbers          1
#> 5                 Accession         accn_number          1
#> 6                     Media               media          1

# If using RStudio, view the entire dataframe of result parameters.
View(result_params)

# Request just the number of records matching a query.
count <- get_record_count(
  scientific_name="Canis lupus", guid_prefix="MSB:Mamm"
)

# Request to download data. This is limited to 100 records by default.
response <- get_records(
  scientific_name="Canis lupus", guid_prefix="MSB:Mamm",
  columns = c("guid", "parts", "partdetail")
)

# Grab the dataframe of records from the response and save that as a csv.
df <- response_data(response)

# Save the response in a flat CSV with an additional metadata file in JSON
save_response_csv(response, "msb-wolves.csv", flat = TRUE, with_metadata = TRUE)

# Save only the dataframe
write.csv(x = df, file="msb-wolves-df.csv")
```
