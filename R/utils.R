map <- function(f, v) {
  for (i in 1:length(v)) {
    v[i] <- f(v[i])
  }
  v
}

make_query_list <- function(queries) {
  paste(
    map(function (s) curl::curl_escape(s),
        queries),
    collapse = "&"
  )
}

encode_params <- function(params) {
  qq <- c()

  for (i in 1:length(params)) {
    if (nchar(names(params)[i]) > 0) {
      qq[i] <- paste(c(curl::curl_escape(names(params)[i]), curl::curl_escape(params[[i]])), collapse="=")
    } else {
      qq[i] <- curl::curl_escape(params[[i]])
    }
  }

  paste(qq, collapse="&")
}
