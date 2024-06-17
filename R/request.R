new_response <- function(query, response) {
  structure(
    list(),
    class = "ArctosResponse",
    query = query,                     # query parameters list
    cols = response$DATA$COLUMNS,      # columns of the returned table
    length = response$recordsTotal,    # number of records
    stop = length(response$DATA$DATA), # maximum index downloaded
    tbl = response$tbl,                # table to query more from
    data = response$DATA$DATA          # data.frame of the returned data
  )
}

request_more(response, stop) {

}

`[.ArctosResponse` <- function(r, i) {
  if (i > attr(r, "stop")) {
    request_more(r, i)
  }

  attr(r, "data")[i]
}
