# Demonstration: Comparing print_milestone() vs print_milestone_cli()
#
# This script demonstrates the enhanced output provided by the new
# print_milestone_cli() function using the {cli} package.

library(milestoneR)

# Use Halley's 1701 contour map as example
halley_id <- 53

cat("\n")
cat("=" ,"=", "=" ," ORIGINAL: print_milestone() ","=","=","=","\n\n")
print_milestone(halley_id)

cat("\n\n")
cat("=","=","="," ENHANCED: print_milestone_cli() ","=","=","=","\n\n")
print_milestone_cli(halley_id)


cat("\n\n")
cat("=","=","="," MULTIPLE MILESTONES WITH CLI ","=","=","=","\n\n")
# Show how multiple milestones are separated with visual rules
print_milestone_cli(c(53, 35))


cat("\n\n")
cat("=","=","="," SELECTIVE SECTIONS ","=","=","=","\n\n")
# Show only authors, media, and references
print_milestone_cli(53, include = c("authors", "media", "references"))


cat("\n\n")
cat("=","=","="," INTEGRATION WITH SEARCH ","=","=","=","\n\n")
# Demonstrate integration with search functions
playfair_ids <- search_authors("Playfair")
cat("Found", length(playfair_ids), "milestones by Playfair\n\n")
print_milestone_cli(playfair_ids)


cat("\n\n")
cat("Key Features of print_milestone_cli():\n")
cat("  • Clickable hyperlinks for media URLs (in modern terminals)\n")
cat("  • Visual headers with dividers (── Media ──)\n")
cat("  • Bulleted lists for media and references\n")
cat("  • Bold/italic formatting for better readability\n")
cat("  • Visual separators between multiple milestones\n")
cat("  • Properly escaped special characters (curly braces)\n")
cat("\n")
