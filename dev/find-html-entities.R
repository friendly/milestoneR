# Find specific HTML entities still present in the .RData files

cat("=== Finding HTML entities in milestone.RData ===\n")
load('data/milestone.RData')
desc_with_entities <- milestone$description[grepl("&[a-z]+;", milestone$description, ignore.case=TRUE)]
cat("Found", length(desc_with_entities), "descriptions with HTML entities\n")
cat("\nExamples:\n")
for(i in 1:min(3, length(desc_with_entities))) {
  # Extract just the entity
  entities <- regmatches(desc_with_entities[i], gregexpr("&[a-z]+;", desc_with_entities[i], ignore.case=TRUE))
  cat("  ", unique(unlist(entities)), "\n")
}

cat("\n=== Finding HTML entities in reference.RData ===\n")
load('data/reference.RData')

# Check all character fields
fields_to_check <- c('author', 'title', 'journal', 'booktitle', 'publisher', 'editor')
for(field in fields_to_check) {
  if(field %in% names(reference)) {
    vals <- reference[[field]]
    vals <- vals[!is.na(vals)]
    with_entities <- vals[grepl("&[a-z]+;", vals, ignore.case=TRUE)]
    if(length(with_entities) > 0) {
      cat("\nField:", field, "- Found", length(with_entities), "with entities\n")
      entities <- unique(unlist(regmatches(with_entities, gregexpr("&[a-z]+;", with_entities, ignore.case=TRUE))))
      cat("  Entities:", paste(entities[1:min(5, length(entities))], collapse=", "), "\n")
    }
  }
}
