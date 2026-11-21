fixture_response <- function(name) {
  path <- test_path("fixtures", paste0(name, ".json"))
  arctos_response(
    status_code = 200,
    type = "application/json;charset=UTF-8",
    date_header = "Thu, 26 Sep 2024 01:58:51 GMT",
    body = readChar(path, file.size(path), useBytes = TRUE)
  )
}
