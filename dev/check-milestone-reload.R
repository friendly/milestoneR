# Force reload and check milestone.RData
rm(list=ls())  # Clear environment
load('data/milestone.RData')

cat("First description:\n")
cat(milestone$description[2], "\n\n")

cat("Checking for HTML tags:\n")
has_tags <- grepl("<[^>]+>", milestone$description)
cat("Descriptions with HTML tags:", sum(has_tags, na.rm=TRUE), "/", nrow(milestone), "\n")

if(sum(has_tags, na.rm=TRUE) > 0) {
  cat("\nFirst few with HTML tags:\n")
  print(head(milestone$description[has_tags], 2))
}

cat("\nChecking for HTML entities:\n")
has_entities <- grepl("&[a-z]+;", milestone$description, ignore.case=TRUE)
cat("Descriptions with HTML entities:", sum(has_entities, na.rm=TRUE), "/", nrow(milestone), "\n")

if(sum(has_entities, na.rm=TRUE) > 0) {
  cat("\nFirst few with entities:\n")
  print(head(milestone$description[has_entities], 2))
}
