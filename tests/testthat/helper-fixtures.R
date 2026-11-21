FIXTURE_DIR <- normalizePath(test_path("fixtures"))

fixture_response <- function(name, status_code = 200) {
  path <- file.path(FIXTURE_DIR, paste0(name, ".json"))
  arctos_response(
    status_code = status_code,
    type = "application/json;charset=UTF-8",
    date_header = "Thu, 26 Sep 2024 01:58:51 GMT",
    body = readChar(path, file.size(path), useBytes = TRUE)
  )
}
