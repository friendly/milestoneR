# Test HTML tag stripping
test_string <- "<p>The first world map? (No extant copies, but described in books II and IV of Herodotus' \"Histories'' (<a href=\"?page=references&amp;cite=Robinson:1968\">Robinson:1968</a>)</p>"

cat("Original:\n")
cat(test_string, "\n\n")

cat("After gsub('<[^>]*>', '', ...):\n")
result <- gsub("<[^>]*>", "", test_string)
cat(result, "\n\n")

cat("Still has tags?", grepl("<[^>]+>", result), "\n")
cat("Still has entities?", grepl("&[a-z]+;", result, ignore.case=TRUE), "\n")
