library(milestoneR)

# Test all the accessor functions
cat("Testing milestone()...\n")
m <- milestone()
cat("  - Loaded", nrow(m), "rows\n")
cat("  - Columns:", paste(names(m), collapse = ", "), "...\n")

cat("\nTesting authors()...\n")
a <- authors()
cat("  - Loaded", nrow(a), "rows\n")
cat("  - Columns:", paste(names(a), collapse = ", "), "...\n")

cat("\nTesting reference()...\n")
r <- reference()
cat("  - Loaded", nrow(r), "rows\n")
cat("  - Columns:", paste(names(r), collapse = ", "), "...\n")

cat("\nTesting mediaitem()...\n")
mi <- mediaitem()
cat("  - Loaded", nrow(mi), "rows\n")
cat("  - Columns:", paste(names(mi), collapse = ", "), "\n")

cat("\nAll functions tested successfully!\n")
