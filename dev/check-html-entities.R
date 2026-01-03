# Check if HTML entities are present in the .RData files

cat("=== Checking milestone.RData ===\n")
load('data/milestone.RData')
desc_sample <- milestone$description[1:10]
cat("\nSample description:\n")
cat(desc_sample[2], "\n")
cat("\nHTML entities check:\n")
cat("Named entities (&xxx;):", any(grepl("&[a-z]+;", desc_sample, ignore.case=TRUE)), "\n")
cat("Numeric entities (&#xxx;):", any(grepl("&#[0-9]+;", desc_sample)), "\n")

cat("\n=== Checking author.RData ===\n")
load('data/author.RData')
names_sample <- na.omit(author$givennames)[1:20]
cat("\nSample givennames:\n")
print(names_sample[c(5,10,15)])
cat("\nHTML entities check:\n")
cat("Named entities (&xxx;):", any(grepl("&[a-z]+;", names_sample, ignore.case=TRUE)), "\n")
cat("Numeric entities (&#xxx;):", any(grepl("&#[0-9]+;", names_sample)), "\n")

cat("\n=== Checking reference.RData ===\n")
load('data/reference.RData')
titles_sample <- na.omit(reference$title)[1:20]
cat("\nSample titles:\n")
print(titles_sample[2])
cat("\nHTML entities check:\n")
cat("Named entities (&xxx;):", any(grepl("&[a-z]+;", titles_sample, ignore.case=TRUE)), "\n")
cat("Numeric entities (&#xxx;):", any(grepl("&#[0-9]+;", titles_sample)), "\n")

cat("\n=== Checking mediaitem.RData ===\n")
load('data/mediaitem.RData')
media_titles <- na.omit(mediaitem$title)[1:20]
cat("\nSample media titles:\n")
print(media_titles[2])
cat("\nHTML entities check:\n")
cat("Named entities (&xxx;):", any(grepl("&[a-z]+;", media_titles, ignore.case=TRUE)), "\n")
cat("Numeric entities (&#xxx;):", any(grepl("&#[0-9]+;", media_titles)), "\n")

cat("\n=== CONCLUSION ===\n")
cat("If all checks return FALSE, then HTML conversion is complete in .RData files\n")
cat("and html2latin1/html2utf8 are not needed in R/ accessor functions.\n")
