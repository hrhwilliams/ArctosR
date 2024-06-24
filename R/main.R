catalog_search_raw <- function(queries) {
  queries$method <- "getCatalogData"
  queries$queryformat <- "struct"  # returns rows as "dicts"

  url <- build_authenticated_url("catalog.cfc", queries)
  perform_request(url)
}

catalog_about_raw <- function() {
  url <- build_url("catalog.cfc", list("method" = "about"))
  perform_request(url)
}

#' @examples
#' j <- catalog_search(species="Canis", genus="lupus")
catalog_search <- function(...) {
  response <- catalog_search_raw(list(...))
  json <- jsonlite::fromJSON(rawToChar(response$content), simplifyDataFrame=T)

  if (response$status_code == 200) {
    json
  } else {
    if (!(is.null(json$error) || is.null(json$Message))) {
      stop(sprintf("HTTP %d %s: %s", response$status_code, json$error, json$Message))
    } else {
      stop(sprintf("HTTP %d response from Arctos", response$status_code))
    }
  }
}

catalog_about <- function() {
  response <- catalog_about_raw()
  json <- jsonlite::fromJSON(rawToChar(response$content))

  if (response$status_code == 200) {
    json
  } else {
    if (!(is.null(json$error) || is.null(json$Message))) {
      stop(sprintf("HTTP %d %s: %s", response$status_code, json$error, json$Message))
    } else {
      stop(sprintf("HTTP %d response from Arctos", response$status_code))
    }
  }
}





# grabbing parts from a search:
# part_search=<query, e.g. ectoparasite, endoparasite>
# cols=parts,partdetail

# partdetails returns another json-formatted list in queryformat=struct as
# a string

# finding related records:
# cols=relatedcatalogeditems
# returns (host of), (parasite of) relations for records with parasites
# and parasites that were in a record

# has para in collection
# https://arctos.database.museum/guid/MSB:Mamm:311637
# https://arctos.database.museum/guid/MSB:Para:38129

# examined for and detected orthohauntavirus
# https://arctos.database.museum/guid/MSB:Mamm:131807
