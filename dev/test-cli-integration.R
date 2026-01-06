# Test the integrated CLI functionality
devtools::load_all()

cat("Testing print_milestone() with result = 'cli':\n")
cat("=" , rep("=", 70), "\n\n", sep = "")

# Test 1: Single milestone with result = "cli"
print_milestone(53, result = "cli")

cat("\n\n")
cat("=" , rep("=", 70), "\n\n", sep = "")

# Test 2: Using the print_milestone_cli() wrapper
cat("Testing print_milestone_cli() wrapper:\n")
cat("=" , rep("=", 70), "\n\n", sep = "")
print_milestone_cli(53)

cat("\n\nBoth methods should produce identical output!\n")
