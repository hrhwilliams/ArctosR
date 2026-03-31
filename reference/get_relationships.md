# Get the relationships (e.g. "host of") a cataloged item has

A cataloged item in Arctos can be related to any other number of items
by relationships defined in the code table `ctid_references`. This
function will return all items related by any such relationship in the
table in a data frame.

## Usage

``` r
get_relationships(guid, api_key = NULL)
```

## Arguments

- guid:

  The Arctos GUID of the item to query relationships over

- api_key:

  (character) The API key to use for this request.

## Value

a data frame of all related items. This contains URLs

## Examples

``` r
library(ArctosR)

if (interactive()) {
  r <- get_relationships("MSB:Mamm:140026")
}
```
