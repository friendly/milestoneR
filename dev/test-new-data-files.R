# Test new RData files by loading them directly

cat("=== Testing new lookup table data files ===\n\n")

cat("Testing aspect.RData...\n")
load('data/aspect.RData')
cat("  - Loaded", nrow(aspect), "rows\n")
cat("  - Columns:", paste(names(aspect), collapse=", "), "\n")
cat("  - Values:", paste(aspect$name, collapse=", "), "\n\n")

cat("Testing subject.RData...\n")
load('data/subject.RData')
cat("  - Loaded", nrow(subject), "rows\n")
cat("  - Columns:", paste(names(subject), collapse=", "), "\n")
cat("  - Values:", paste(subject$name, collapse=", "), "\n\n")

cat("Testing keyword.RData...\n")
load('data/keyword.RData')
cat("  - Loaded", nrow(keyword), "rows\n")
cat("  - Columns:", paste(names(keyword), collapse=", "), "\n")
cat("  - First 5:", paste(head(keyword$name, 5), collapse=", "), "\n\n")

cat("=== Testing linking table data files ===\n\n")

cat("Testing milestone2aspect.RData...\n")
load('data/milestone2aspect.RData')
cat("  - Loaded", nrow(milestone2aspect), "rows\n")
cat("  - Columns:", paste(names(milestone2aspect), collapse=", "), "\n\n")

cat("Testing milestone2subject.RData...\n")
load('data/milestone2subject.RData')
cat("  - Loaded", nrow(milestone2subject), "rows\n")
cat("  - Columns:", paste(names(milestone2subject), collapse=", "), "\n\n")

cat("Testing milestone2keyword.RData...\n")
load('data/milestone2keyword.RData')
cat("  - Loaded", nrow(milestone2keyword), "rows\n")
cat("  - Columns:", paste(names(milestone2keyword), collapse=", "), "\n\n")

cat("Testing milestone2author.RData...\n")
load('data/milestone2author.RData')
cat("  - Loaded", nrow(milestone2author), "rows\n")
cat("  - Columns:", paste(names(milestone2author), collapse=", "), "\n\n")

cat("Testing milestone2reference.RData...\n")
load('data/milestone2reference.RData')
cat("  - Loaded", nrow(milestone2reference), "rows\n")
cat("  - Columns:", paste(names(milestone2reference), collapse=", "), "\n\n")

cat("All data files tested successfully!\n")
