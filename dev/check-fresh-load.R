# Fresh load from the just-generated file
file_path <- 'data/milestone.RData'
cat("File info:\n")
cat("  Size:", file.size(file_path), "bytes\n")
cat("  Modified:", as.character(file.mtime(file_path)), "\n\n")

# Load in a fresh environment
e <- new.env()
load(file_path, envir = e)

cat("First description:\n")
cat(e$milestone$description[2], "\n\n")

cat("Has HTML tags?", grepl("<[^>]+>", e$milestone$description[2]), "\n")
cat("Has HTML entities?", grepl("&[a-z]+;", e$milestone$description[2], ignore.case=TRUE), "\n")
