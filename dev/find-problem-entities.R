# Find the exact problem entities
load('data/milestone.RData')

# Find entries with entities
has_entities <- grepl("&[a-z]+;", milestone$description, ignore.case=TRUE)
problem_descs <- milestone$description[has_entities]

cat("Found", length(problem_descs), "descriptions with entities\n\n")

for(i in 1:length(problem_descs)) {
  cat("=== Entry", i, "===\n")
  # Find the entities in this description
  entities <- regmatches(problem_descs[i], gregexpr("&[a-z]+;", problem_descs[i], ignore.case=TRUE))[[1]]
  cat("Entities found:", paste(unique(entities), collapse=", "), "\n")

  # Show a snippet around the first entity
  first_entity <- entities[1]
  pos <- regexpr(first_entity, problem_descs[i], fixed=TRUE)[1]
  start <- max(1, pos - 30)
  end <- min(nchar(problem_descs[i]), pos + 30)
  cat("Context: ...", substr(problem_descs[i], start, end), "...\n\n")
}
