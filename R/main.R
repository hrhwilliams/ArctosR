library(curl)

req <- curl_fetch_memory("https://arctos.database.museum/")
str(req)
