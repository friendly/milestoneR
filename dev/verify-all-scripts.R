# Verify all data-raw scripts can source html2latin1.R from the new location

scripts <- c(
  "data-raw/read-mstone.R",
  "data-raw/read_author.R",
  "data-raw/read_media.R",
  "data-raw/read_refs.R",
  "data-raw/resolve-links.R"
)

cat("Testing all data-raw scripts...\n\n")

for(script in scripts) {
  cat("Testing:", script, "... ")
  result <- tryCatch({
    source(script, local = TRUE)
    "OK"
  }, error = function(e) {
    paste("ERROR:", e$message)
  })
  cat(result, "\n")
}

cat("\nAll scripts tested!\n")
