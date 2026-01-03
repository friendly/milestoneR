library(here)
library(readr)

# Read aspect lookup table
aspect <- read_csv("data-raw/aspect.csv", show_col_types = FALSE)

# Save to data/
save(aspect, file = here("data", "aspect.RData"))

cat("Created aspect.RData with", nrow(aspect), "rows\n")
