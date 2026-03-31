# Get the first URL in a completed query

Returns the first URL used by a completed query which can be shared. The
API key is automatically stripped from the URL for security.

## Usage

``` r
get_request_url(query)
```

## Arguments

- query:

  A completed query returned from `get_records`

## Value

A URL as a string

## Examples

``` r
library(ArctosR)

if (interactive()) {
  q <- get_records(guid_prefix="MSB:Mamm")
  url <- get_request_url(q)
}
```
