# Test new functions by sourcing them directly
source('R/aspect.R')
source('R/subject.R')
source('R/keyword.R')
source('R/milestone2aspect.R')
source('R/milestone2subject.R')
source('R/milestone2keyword.R')
source('R/milestone2author.R')
source('R/milestone2reference.R')

cat("=== Testing new lookup table functions ===\n\n")

cat("Testing aspect()...\n")
asp <- aspect()
cat("  - Loaded", nrow(asp), "rows\n")
cat("  - Columns:", paste(names(asp), collapse=", "), "\n")
cat("  - Values:", paste(asp$name, collapse=", "), "\n\n")

cat("Testing subject()...\n")
subj <- subject()
cat("  - Loaded", nrow(subj), "rows\n")
cat("  - Columns:", paste(names(subj), collapse=", "), "\n")
cat("  - Values:", paste(subj$name, collapse=", "), "\n\n")

cat("Testing keyword()...\n")
kw <- keyword()
cat("  - Loaded", nrow(kw), "rows\n")
cat("  - Columns:", paste(names(kw), collapse=", "), "\n")
cat("  - First 5:", paste(head(kw$name, 5), collapse=", "), "\n\n")

cat("=== Testing linking table functions ===\n\n")

cat("Testing milestone2aspect()...\n")
m2a <- milestone2aspect()
cat("  - Loaded", nrow(m2a), "rows\n")
cat("  - Columns:", paste(names(m2a), collapse=", "), "\n\n")

cat("Testing milestone2subject()...\n")
m2s <- milestone2subject()
cat("  - Loaded", nrow(m2s), "rows\n")
cat("  - Columns:", paste(names(m2s), collapse=", "), "\n\n")

cat("Testing milestone2keyword()...\n")
m2k <- milestone2keyword()
cat("  - Loaded", nrow(m2k), "rows\n")
cat("  - Columns:", paste(names(m2k), collapse=", "), "\n\n")

cat("Testing milestone2author()...\n")
m2aut <- milestone2author()
cat("  - Loaded", nrow(m2aut), "rows\n")
cat("  - Columns:", paste(names(m2aut), collapse=", "), "\n\n")

cat("Testing milestone2reference()...\n")
m2r <- milestone2reference()
cat("  - Loaded", nrow(m2r), "rows\n")
cat("  - Columns:", paste(names(m2r), collapse=", "), "\n\n")

cat("All functions tested successfully!\n")
